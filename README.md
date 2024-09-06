# Film Finder
A fullstack application developed using Flutter and Django that allows users to discover new movies based on their preferences. The app leverages an AI recommendation algorithm to suggest films tailored to what users like or dislike.

## Demo
This app is deployed to the web via Firebase, and can be found [here](https://film-finder-dd678.firebaseapp.com/).

The API is deployed to the web via Render, and can be found [here](https://film-finder-up8b.onrender.com/api/).

## Features
- AI recommendation algorithm using a token vectorizer and cosine similarity
- Intuitive UI for swiping right on liked movies, and left on disliked movies
- User authentication utilizing Django's token-based system
- Sensitive account information secured with an encryption algorithm
- Responsive design with mobile-first approach

## Tech Stack
### Frontend
- Flutter

### Backend
- Django
- SQLite

## Getting Started
Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
- Python [3.11](https://www.python.org/downloads/release/python-3110/)
- Flutter [3.13.9](https://docs.flutter.dev/release/archive)
- [Git](https://git-scm.com/downloads)

## Installation
1. Clone the repository
```bash
git clone https://github.com/AndrewAlbizati/film-finder.git
cd film-finder
```

2. Install dependencies for both frontend and backend:

Backend:
```bash
cd api
pipenv shell
```

Frontend:
```bash
cd app
```

3. Setup environment variables
```
SECRET_KEY=
DEBUG=
ALLOWED_HOSTS=
```


## Usage
To run the fullstack app locally:
1. Backend
```
cd api
python manage.py runserver
```

2. Frontend: Open a new terminal tab/window:
```bash
cd app
flutter run -d chrome
```

Visit `http://localhost:3000` to view the app.

## API Documentation

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
