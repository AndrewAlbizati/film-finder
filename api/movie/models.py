from django.db import models
from django.contrib.auth.models import User


class Movie(models.Model):
    movie_id = models.IntegerField()
    user = models.ForeignKey(User, on_delete=models.CASCADE)

    status = models.CharField(max_length=255, choices=(
        ('like', 'Like'),
        ('unwatched', 'Unwatched'),
        ('dislike', 'Dislike'),
    ), default='dislike')

    created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Movie: {self.movie_id}, Status: {self.status}"
