from http.client import HTTPResponse
from rest_framework.decorators import api_view


@api_view(['GET'])
def ping(request):
    return HTTPResponse("pong")