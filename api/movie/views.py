from rest_framework.decorators import api_view
from rest_framework.response import Response

from rest_framework.decorators import authentication_classes, permission_classes
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from django.contrib.auth.models import User

from django.http import HttpResponseBadRequest

from .models import Movie
import json
import pickle
import pandas as pd


@api_view(['GET'])
def get_routes(request):
    routes = [
        {
            'Endpoint': '/list/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a list of movie IDs sorted by popularity (Requires authentication)'
        },
        {
            'Endpoint': '/<id>/',
            'method': 'GET',
            'body': None,
            'description': 'Returns information for a movie based on ID (Requires authentication)'
        },
        {
            'Endpoint': '/status/<id>/',
            'method': 'GET',
            'body': None,
            'description': 'Returns status information for a movie (Requires authentication)'
        },
        {
            'Endpoint': '/batchrecommend/',
            'method': 'POST',
            'body': {'liked': [], 'disliked': []},
            'description': 'Recommends movies based off of likes and dislikes (Requires authentication)'
        },
        {
            'Endpoint': '/batchget/',
            'method': 'POST',
            'body': [],
            'description': 'Gets the data for a list of movie IDs (Requires authentication)'
        },
    ]
    return Response(routes)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def list_movies(request):
    popular_movie_df = __get_movie_dataframe()
    
    user_movies = Movie.objects.filter(user=request.user).values_list('movie_id', flat=True)
    
    # Convert user movie IDs to a set for faster lookup
    user_movie_ids = set(user_movies)

    filtered_df = popular_movie_df[~popular_movie_df.index.isin(user_movie_ids)]
    id_list = filtered_df.index.tolist()

    return Response(id_list)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_movie(request, pk):
    movie = __get_movie_by_id(int(pk))

    if movie is None:
        return HttpResponseBadRequest("Invalid movie ID provided")

    movie["id"] = int(pk)

    return Response(movie)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_movie_status(request, pk):
    if not __movie_exists(int(pk)):
        return HttpResponseBadRequest("Invalid movie ID provided")

    movie_id = int(pk)
    user = User.objects.get(username=request.user.username)

    movie = Movie.objects.filter(user=user, movie_id=movie_id)

    if len(movie) == 0:
        return HttpResponseBadRequest("Movie/user combination not found") 

    movie = movie[0]

    return Response({"user":user.username, "movie": movie.movie_id, "status": movie.status})

@api_view(['POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def batch_recommend(request):
    liked_movies = request.data["liked"]
    disliked_movies = request.data["disliked"]

    movies = __get_movie_dataframe()
    similarity = __get_movie_similarity_matrix()
    return_count = 5
    
    recommender = {}

    # Add movies to db
    for movie_id in liked_movies:
        Movie.objects.get_or_create(movie_id=movie_id, user=request.user, status='like')
    for movie_id in disliked_movies:
        Movie.objects.get_or_create(movie_id=movie_id, user=request.user, status='dislike')
    
    # Handle liked movies
    for movie in Movie.objects.filter(user=request.user, status='like'):
        if not movie.movie_id in movies.index:
            continue
    
        movie_index = movies.index.get_loc(movie.movie_id)
        
        # Calculate similarity scores
        distance = sorted(list(enumerate(similarity[movie_index])), reverse=True, key=lambda vector: vector[1])

        # Recommend similar movies, excluding the movie itself
        for i in distance[1:1+return_count]:
            movies_id = movies.iloc[i[0]].name  # Get the ID from the DataFrame index
            recommender.setdefault(str(movies_id), 0)
            recommender[str(movies_id)] += 1
            
    # Handle disliked movies
    for movie in Movie.objects.filter(user=request.user, status='dislike'):
        if not movie.movie_id in movies.index:
            continue
    
        movie_index = movies.index.get_loc(movie.movie_id)
        
        recommender[str(movie_id)] = -10000  # make it so already disliked movies won't appear

        distance = sorted(list(enumerate(similarity[movie_index])), reverse=True, key=lambda vector: vector[1])

        for i in distance[1:1+return_count]:
            movies_id = movies.iloc[i[0]].name
            recommender.setdefault(str(movies_id), 0)
            recommender[str(movies_id)] -= 1
    
    # Remove keys with negative values
    keys_to_delete = [key for key in recommender if recommender[key] < 0]
    for key in keys_to_delete:
        del recommender[key]
    
    sorted_keys = reversed(sorted(recommender, key=lambda k: recommender[k]))

    return Response(sorted_keys)

@api_view(['POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def batch_get_movie(request):
    movies = request.data

    response = []

    for movie_id in movies:
        movie = __get_movie_by_id(int(movie_id))

        if movie is None:
            return HttpResponseBadRequest("Invalid movie ID provided")
        
        movie["id"] = str(movie_id)

        response.append(movie)
        
    return Response(response)

def __get_movie_by_id(movie_id: int):
    movies = __get_movie_dataframe()
    if __movie_exists(movie_id):
        return movies.loc[movie_id].to_dict()
    return None

def __movie_exists(movie_id: int):
    movies = __get_movie_dataframe()
    return movie_id in movies.index

def __get_movie_dataframe():
    return pd.read_pickle("movie/files/movies.pkl")

def __get_movie_similarity_matrix():
    return pickle.load(open("movie/files/similarity.pkl", "rb"))
