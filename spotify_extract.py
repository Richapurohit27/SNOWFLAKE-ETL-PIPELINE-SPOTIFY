import json
import os
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import boto3
from datetime import datetime

def lambda_handler(event, context):
    # Retrieve Spotify API credentials from environment variables
    client_id = os.environ.get('client_id')
    client_secret = os.environ.get('client_secret')
    
    # Authenticate with Spotify API using client credentials
    client_credentials_manager = SpotifyClientCredentials(client_id=client_id, client_secret=client_secret)
    sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)

    # Fetch the list of public playlists from Spotify
    playlists = sp.user_playlists('spotify')

    # Define the playlist URL (change this to target a different playlist)
    playlist_link = "https://open.spotify.com/playlist/4VxLLwRnF6c7sY6FrKWFgK"
    
    # Extract the playlist URI from the URL
    playlist_URI = playlist_link.split('/')[-1]
    
    # Fetch the track details from the playlist
    spotify_data = sp.playlist_tracks(playlist_URI)   
    print(spotify_data)  # Log the retrieved data for debugging

    # Initialize S3 client
    s3_client = boto3.client('s3')
    
    # Generate a filename with a timestamp for uniqueness
    filename = "spotify_raw_" + str(datetime.now()) + ".json"
    
    # Upload the JSON data to the specified S3 bucket
    s3_client.put_object(
        Bucket="spotify-etl-rich",
        Key="raw-data-api/to_processed/" + filename,
        Body=json.dumps(spotify_data)  # Convert data to JSON string before uploading
    )
