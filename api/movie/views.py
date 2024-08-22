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
    with open("movie/files/popular.json", "r") as f:
        popular_movie_list = json.load(f)
    
    movies = Movie.objects.filter(user=request.user)

    for movie in movies:
        if movie.movie_id in popular_movie_list:
            popular_movie_list.remove(movie.movie_id)

    return Response(popular_movie_list)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@api_view(['GET'])
def get_movie(request, pk):
    movie_list = __get_movies()
    
    if not __movie_exists(pk, movie_list):
        return HttpResponseBadRequest("Invalid movie ID provided")

    movie = movie_list[pk]
    movie["id"] = int(pk)

    return Response(movie)

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_movie_status(request, pk):
    if not __movie_exists(pk, __get_movies()):
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

    movies = pickle.load(open("movie/files/movies_list.pkl", "rb"))
    similarity = pickle.load(open("movie/files/similarity.pkl", "rb"))
    return_count = 5
    
    recommender = {}

    # Add movies to db
    for movie_id in liked_movies:
        Movie.objects.create(movie_id=movie_id, user=request.user, status='like')
    for movie_id in disliked_movies:
        Movie.objects.create(movie_id=movie_id, user=request.user, status='dislike')
    
    # Handle liked movies
    for movie in Movie.objects.filter(user=request.user, status='like'):
        movie_id = movie.movie_id
        index = movies[movies['id'] == movie_id].index[0]
        recommender[str(movie_id)] = -10000  # make it so already liked movies won't appear

        distance = sorted(list(enumerate(similarity[index])), reverse=True, key=lambda vector:vector[1])
        
        for i in distance[1:1+return_count]:
            movies_id = movies.iloc[i[0]].id
            recommender.setdefault(str(movies_id), 0)
            recommender[str(movies_id)] += 1

    # Handle disliked movies
    for movie in Movie.objects.filter(user=request.user, status='dislike'):
        movie_id = movie.movie_id
        index = movies[movies['id'] == movie_id].index[0]
        recommender[str(movie_id)] = -10000  # make it so already disliked movies won't appear

        distance = sorted(list(enumerate(similarity[index])), reverse=True, key=lambda vector:vector[1])
        
        for i in distance[1:1+return_count]:
            movies_id = movies.iloc[i[0]].id
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

    movie_list = __get_movies()

    for movie_id in movies:
        if not __movie_exists(str(movie_id), movie_list):
            return HttpResponseBadRequest("Invalid movie ID provided")

        movie = movie_list[str(movie_id)]
        movie["id"] = movie_id
        
        response.append(movie)
        
    return Response(response)

def __get_movies():
    with open("movie/files/movies.json", "r") as f:
        movie_list = json.load(f)

    return movie_list

def __movie_exists(movie_id, movie_list):
    return movie_id in movie_list
    