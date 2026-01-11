-- Easy
-- Q1. Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify
where streams > 1000000000

-- Q2. List all albums along with their respective artists.
select distinct album, artist
from spotify

-- Q3. Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments
from spotify
where licensed = 'TRUE'

-- Q4. Find all tracks that belong to the album type single.
select track
from spotify
where album_type = 'single'

-- Q5. Count the total number of tracks by each artist.
select artist, count( distinct track) as total_tracks
from spotify
group by artist

-- Moderate
-- Q1. Calculate the average danceability of tracks in each album.
select album, avg(danceability) as avg_danceability
from spotify
group by album
order by 2 desc

-- Q2. Find the top 5 tracks with the highest energy values.
select track, energy
from spotify
order by energy desc
limit 5

-- Q3. List all tracks along with their views and likes where official_video = TRUE.
select track, sum(views) as total_views, sum(likes) as total_likes
from spotify
where official_video = 'TRUE'
group by track
order by 2 desc

-- Q4. For each album, calculate the total views of all associated tracks.
select album, track, sum(views)
from spotify
group by album, track
order by 3 desc

-- Advanced
-- Q1. Find the top 3 most-viewed tracks for each artist using window functions.
select s.* from (select artist, track, views, row_number() over(partition by artist order by views desc) as rn
from spotify) s
where s.rn <= 3

-- Q2. Write a query to find tracks where the liveness score is above the average.
select track, liveness
from spotify 
where liveness > (select avg(liveness) from public.spotify)
order by liveness

-- Q3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with highest_energy as (
select album, max(energy) as max_en, 
min(energy) as min_en
from spotify
group by album
)

select album, max_en - min_en as en_diff
from  highest_energy
order by 2 desc

-- Q4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
select track from spotify
where energy/liveness > 1.2

-- Q5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
select track, views, likes, sum(likes) over(order by views) 
from spotify