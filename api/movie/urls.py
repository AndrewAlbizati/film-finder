from django.urls import path
from . import views

urlpatterns = [
    path('', views.get_routes),
    path('list/', views.list_movies),
    path('get/<str:pk>/', views.get_movie),
    path('status/<str:pk>/', views.get_movie_status),
    path('like/<str:pk>/', views.add_liked_movie),
    path('dislike/<str:pk>/', views.add_disliked_movie),
    path('unwatched/<str:pk>/', views.add_unwatched_movie),
    path('recommend/', views.recommend),
]