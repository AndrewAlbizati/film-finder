from django.urls import path
from . import views

urlpatterns = [
    path('', views.get_routes),
    path('list/', views.list_movies),
    path('get/<str:pk>/', views.get_movie),
    path('status/<str:pk>/', views.get_movie_status),
    path('batchrecommend/', views.batch_recommend),
    path('batchget/', views.batch_get_movie),
]