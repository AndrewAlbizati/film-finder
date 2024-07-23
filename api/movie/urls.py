from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    path('list/', views.list),
    path('<str:pk>/', views.getMovie),
]