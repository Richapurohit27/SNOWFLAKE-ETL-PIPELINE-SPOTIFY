-- Create a new database for the Spotify ETL project
CREATE OR REPLACE DATABASE SPOTIFY_ETL_PROJECT_SNOW;

-- Create a storage integration for accessing S3 bucket
CREATE OR REPLACE STORAGE INTEGRATION spotify_s3_int
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::376129840843:role/spotify-etl'
    STORAGE_ALLOWED_LOCATIONS = ('s3://spotify-etl-rich')
    COMMENT = 'creating connection to s3';

-- Describe the storage integration to verify its creation
DESC INTEGRATION spotify_s3_int;

-- Create a file format for CSV files
CREATE OR REPLACE FILE FORMAT csv_file_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- Create table to store album details
CREATE OR REPLACE TABLE SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.TBLALBUM (
	ALBUM_ID VARCHAR,
	ALBUM_NAME VARCHAR,
	ALBUM_ARTISTS VARCHAR,
	ALBUM_RELEASE_DATE DATE,
	ALBUM_POPULARITY VARCHAR,
	ALBUM_TOTAL_TRACKS VARCHAR,
	ALBUM_URL VARCHAR,
	ALBUM_URI VARCHAR
);

-- Create table to store artist details
CREATE OR REPLACE TABLE tblArtist(
  artist_id VARCHAR,
  artist_name VARCHAR,
  external_url VARCHAR
);

-- Create table to store song details
CREATE OR REPLACE TABLE tblSongs(
  track_id VARCHAR,
  track_name VARCHAR,
  track_popularity INT,
  track_uri VARCHAR,
  track_duration INT,
  track_url VARCHAR
);

-- Create an external stage pointing to the transformed data folder in S3
CREATE OR REPLACE STAGE spotify_s3_int_stage
  URL='s3://spotify-etl-rich/transformed-data/'  
  STORAGE_INTEGRATION = spotify_s3_int
  FILE_FORMAT = csv_file_format;

-- Describe the stage to verify its creation
DESC STAGE spotify_s3_int_stage;

-- List the files in the stage to confirm availability
LIST @spotify_s3_int_stage;

-- Load album data from S3 stage into the table
COPY INTO tblAlbum FROM 
  @spotify_s3_int_stage/album_data/;

-- Verify album data load
SELECT * FROM tblalbum;

-- Load artist data from S3 stage into the table
COPY INTO tblArtist FROM 
  @spotify_s3_int_stage/artist_data/;

-- Verify artist data load
SELECT * FROM tblArtist;

-- Load song data from S3 stage into the table
COPY INTO tblSongs FROM 
  @spotify_s3_int_stage/songs_data/;

-- Verify song data load
SELECT * FROM tblSongs;

-- Create a schema for Snowpipe configurations
CREATE OR REPLACE SCHEMA SPOTIFY_ETL_PROJECT_SNOW.pipes;

-- Create a Snowpipe for automatic ingestion of album data
CREATE OR REPLACE PIPE SPOTIFY_ETL_PROJECT_SNOW.pipes.album_pipe
  AUTO_INGEST = TRUE
  AS
  COPY INTO SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.TBLALBUM
  FROM @SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.spotify_s3_int_stage/album_data/;

-- Describe the album Snowpipe
DESC PIPE SPOTIFY_ETL_PROJECT_SNOW.pipes.album_pipe;

-- Create a Snowpipe for automatic ingestion of artist data
CREATE OR REPLACE PIPE SPOTIFY_ETL_PROJECT_SNOW.pipes.artist_pipe
  AUTO_INGEST = TRUE
  AS
  COPY INTO SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.tblArtist
  FROM @SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.spotify_s3_int_stage/artist_data/;

-- Describe the artist Snowpipe
DESC PIPE SPOTIFY_ETL_PROJECT_SNOW.pipes.artist_pipe;

-- Create a Snowpipe for automatic ingestion of song data
CREATE OR REPLACE PIPE SPOTIFY_ETL_PROJECT_SNOW.pipes.songs_pipe
  AUTO_INGEST = TRUE
  AS
  COPY INTO SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.tblSongs
  FROM @SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.spotify_s3_int_stage/songs_data/;

-- Describe the songs Snowpipe
DESC PIPE SPOTIFY_ETL_PROJECT_SNOW.pipes.songs_pipe;

-- Show all existing Snowpipes
SHOW PIPES;

-- Verify the final data in tables
SELECT * FROM SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.tblalbum;  
SELECT * FROM SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.tblArtist; 
SELECT * FROM SPOTIFY_ETL_PROJECT_SNOW.PUBLIC.tblSongs;
