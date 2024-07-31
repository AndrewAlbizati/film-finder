from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authtoken.models import Token

from rest_framework.decorators import authentication_classes, permission_classes
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404

from django.http import HttpResponseBadRequest, HttpResponseNotFound

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
            'description': 'Returns a list of movie IDs sorted by popularity'
        },
        {
            'Endpoint': '/<id>/',
            'method': 'GET',
            'body': None,
            'description': 'Returns information for a movie based on ID'
        },
        {
            'Endpoint': '/status/<id>/',
            'method': 'GET',
            'body': None,
            'description': 'Returns status information for a movie (Requires authentication)'
        },
        {
            'Endpoint': '/like/<id>',
            'method': 'POST',
            'body': None,
            'description': 'Adds a like status for a movie (Requires authentication)'
        },
        {
            'Endpoint': '/dislike/<id>',
            'method': 'POST',
            'body': None,
            'description': 'Adds a dislike status for a movie (Requires authentication)'
        },
        {
            'Endpoint': '/unwatched/<id>',
            'method': 'POST',
            'body': None,
            'description': 'Adds an unwatched status for a movie (Requires authentication)'
        },
    ]
    return Response(routes)

@api_view(['GET'])
def list_movies(request):
    with open("movie/files/popular.json", "r") as f:
        popular_movie_list = json.load(f)

    return Response(popular_movie_list)

@api_view(['GET'])
def get_movie(request, pk):
    movie_list = __get_movies()
    
    if not __movie_exists(pk):
        return HttpResponseBadRequest("Invalid movie ID provided")

    movie = movie_list[pk]

    return Response(movie)

@api_view(['POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def add_liked_movie(request, pk):
    if not __movie_exists(pk):
        return HttpResponseBadRequest("Invalid movie ID provided")
    
    movie_id = int(pk)
    user = User.objects.get(username=request.user.username)
    status = 'like'

    if len(Movie.objects.filter(user=user, movie_id=movie_id)) != 0:
        return HttpResponseBadRequest("Movie already has status")

    movie = Movie.objects.create(movie_id=movie_id, user=user, status=status)
    return Response({f"add liked movie for {request.user.email}, {pk}"})

@api_view(['POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def add_disliked_movie(request, pk):
    if not __movie_exists(pk):
        return HttpResponseBadRequest("Invalid movie ID provided")

    movie_id = int(pk)
    user = User.objects.get(username=request.user.username)
    status = 'dislike'

    if len(Movie.objects.filter(user=user, movie_id=movie_id)) != 0:
        return HttpResponseBadRequest("Movie already has status")

    movie = Movie.objects.create(movie_id=movie_id, user=user, status=status)
    return Response({f"add disliked movie for {request.user.email}, {pk}"})

@api_view(['POST'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def add_unwatched_movie(request, pk):
    if not __movie_exists(pk):
        return HttpResponseBadRequest("Invalid movie ID provided")

    movie_id = int(pk)
    user = User.objects.get(username=request.user.username)
    status = 'unwatched'

    if len(Movie.objects.filter(user=user, movie_id=movie_id)) != 0:
        return HttpResponseBadRequest("Movie already has status")

    movie = Movie.objects.create(movie_id=movie_id, user=user, status=status)
    return Response({f"add unwatched movie for {request.user.email}, {pk}"})

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_movie_status(request, pk):
    if not __movie_exists(pk):
        return HttpResponseBadRequest("Invalid movie ID provided")

    movie_id = int(pk)
    user = User.objects.get(username=request.user.username)

    movie = Movie.objects.filter(user=user, movie_id=movie_id)

    if len(movie) == 0:
        return HttpResponseBadRequest("Movie/user combination not found") 

    movie = movie[0]

    return Response({"user":user.username, "movie": movie.movie_id, "status": movie.status})

@api_view(['GET'])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def recommend(request):
    user = User.objects.get(username=request.user.username)
    movies = pickle.load(open("movie/files/movies_list.pkl", "rb"))
    similarity = pickle.load(open("movie/files/similarity.pkl", "rb"))
    return_count = 5
    
    recommender = {}

    liked_movies = Movie.objects.filter(user=user, status='like')
    for movie in liked_movies:
        movie_id = movie.movie_id
        
        index = movies[movies['id'] == movie_id].index[0]
        recommender[str(movie_id)] = -10000

        distance = sorted(list(enumerate(similarity[index])), reverse=True, key=lambda vector:vector[1])
        
        for i in distance[1:1+return_count]:
            movies_id = movies.iloc[i[0]].id
            recommender.setdefault(str(movies_id), 0)
            recommender[str(movies_id)] += 1

    keys_to_delete = [key for key in recommender if recommender[key] < 0]
    for key in keys_to_delete:
        del recommender[key]
    
    sorted_keys = reversed(sorted(recommender, key=lambda k: recommender[k]))

    return Response(sorted_keys)
    #return Response(recommender)

def __get_movies():
    with open("movie/files/movies.json", "r") as f:
        movie_list = json.load(f)

    return movie_list

def __movie_exists(movie_id):
    return movie_id in __get_movies()
    