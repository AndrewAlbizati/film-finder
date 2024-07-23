from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authtoken.models import Token

from rest_framework.decorators import authentication_classes, permission_classes
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404

from django.http import HttpResponseBadRequest

import json


@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            
        }
    ]
    return Response(routes)

@api_view(['GET'])
def list(request):
    with open("movie/files/popular.json", "r") as f:
        popular_movie_list = json.load(f)

    return Response(popular_movie_list)

@api_view(['GET'])
def getMovie(request, pk):
    with open("movie/files/movies.json", "r") as f:
        movie_list = json.load(f)
    
    if not pk in movie_list:
        return HttpResponseBadRequest("Invalid movie ID provided")

    movie = movie_list[pk]

    return Response(movie)

