/* ======================================================================
   More Exploratory Data Analysis (EDA) on Spotify And Youtube Dataset
   ====================================================================== */


/* EDA: Count unique artists and albums */
SELECT
    COUNT(DISTINCT artist) AS total_artists,
    COUNT(DISTINCT album) AS total_albums
FROM
    spotify;


/* EDA: Find the max and min duration in milliseconds */
SELECT
    MAX(duration_ms) AS max_duration_in_ms,
    MIN(duration_ms) AS min_duration_in_ms
FROM
    spotify;


/* EDA: Find the top five musical keys */
SELECT
    key,
    COUNT(key) AS count_of_keys
FROM spotify
GROUP BY key
ORDER BY 2 DESC
LIMIT 5;


/* EDA: Count non-licensed tracks */
SELECT
    licensed,
    COUNT(*) AS count_of_not_licensed
FROM spotify
GROUP BY licensed
HAVING icensed = FALSE;


/* EDA: Average energy, danceability, liveness */
SELECT
    ROUND(AVG(energy)::NUMERIC, 3) AS avg_energy,
    ROUND(AVG(danceability)::NUMERIC, 3) AS avg_danceability,
    ROUND(AVG(liveness)::NUMERIC, 3) AS avg_liveness
FROM
    spotify;


/* EDA: Top five tracks by likes */
SELECT artist, track, likes
FROM spotify
ORDER BY likes DESC
LIMIT 5;


/* =======================================================
   Business Problem 1:
   Retrieve all tracks with more than 1 billion streams
   ======================================================= */
SELECT 
    track,
    stream
FROM spotify
WHERE stream > 1000000000
ORDER BY stream
LIMIT 5;


/* =======================================================
   Business Problem 2:
   List all albums along with their respective artists
   ======================================================= */
SELECT
    DISTINCT album,
    artist
FROM spotify;


/* =================================================================
   Business Problem 3:
   Get the total number of comments for tracks where licensed = TRUE
   ================================================================= */
SELECT
    SUM(comments) AS total_comments
FROM spotify
GROUP BY licensed
HAVING licensed = TRUE;


/* =======================================================
   Business Problem 4:
   Find all tracks that belong to the album type single
   ======================================================= */
SELECT track
FROM spotify
WHERE album_type LIKE 'single';


/* =======================================================
   Business Problem 5:
   Count the total number of tracks by each artist
   ======================================================= */
SELECT
    artist,
    COUNT(track) AS total_tracks
FROM spotify
GROUP BY artist
ORDER BY COUNT(track) DESC
LIMIT 5;


/* ===========================================================
   Business Problem 6:
   Calculate the average danceability of tracks in each album
   =========================================================== */
SELECT
    album,
    ROUND(AVG(danceability)::NUMERIC, 2) AS avg_danceability_album
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;


/* ===========================================================
   Business Problem 7:
   Find the top 5 tracks with the highest energy values
   =========================================================== */
SELECT 
    track,
    MAX(energy) AS max_energy
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


/* ============================================================================
   Business Problem 8:
   List all tracks along with their views and likes where official_video = TRUE
   ============================================================================ */
SELECT
    track,
    SUM(views) AS total_views,
    SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* ============================================================================
   Business Problem 9:
   For each album, calculate the total views of all associated tracks
   ============================================================================ */
SELECT
    album,
    track,
    -- COUNT(track) AS total_tracks_in_album,
    SUM(views) AS total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;


/* ============================================================================
   Business Problem 10:
   Find the top 3 most-viewed tracks for each artist using window functions
   ============================================================================ */
WITH cte1 AS (
SELECT
    artist,
    track,
    SUM(views) AS total_views,
    DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS views_rank
FROM spotify
GROUP BY 1, 2
)
SELECT * FROM cte1 WHERE views_rank <= 3
LIMIT 6;

/* ============================================================================
   Business Problem 11:
   Write a query to find tracks where the liveness score is above the average
   ============================================================================ */
SELECT track 
FROM spotify
WHERE liveness > (SELECT AVG(liveness) AS avg_liveness FROM spotify);


/* ============================================================================
   Business Problem 12:
   Use a WITH clause to calculate the difference between the highest and lowest 
   energy values for tracks in each album
   ============================================================================ */

WITH cte2 AS(
SELECT
    album,
    MAX(energy) AS max_energy,
    MIN(energy) AS min_energy
FROM 
    spotify
GROUP BY 
    album
)
SELECT
    album,
    ROUND((max_energy - min_energy)::NUMERIC, 2) AS difference_energy
FROM
    cte2
ORDER BY 2 DESC
LIMIT 5;
