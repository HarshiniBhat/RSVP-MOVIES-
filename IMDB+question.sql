USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?

-- Director_mapping table
SELECT COUNT(*) AS DM_rows
FROM director_mapping;
-- Total number of rows in director_mapping table is 3867

-- genre Table
SELECT COUNT(*) AS genre_rows
FROM  genre;
-- Total number of rows in genre table is 14662

-- Movie table
SELECT COUNT(*) AS movie_rows 
FROM movie;
-- Total number of rows in movie table is 7997.

-- names table
SELECT COUNT(*) AS names_rows
FROM names;
-- Total number of rows in names table is 25735.

-- ratings table
SELECT COUNT(*) AS ratings_rows
FROM ratings;
-- Total number of rows in ratings table is 7997

-- role_mapping table
SELECT COUNT(*) AS RM_rows
FROM role_mapping;
-- Total Number of rows i role_mapping table is 15615



-- Q2. Which columns in the movie table have null values?
Select 
 sum(case when id is null then 1 else 0 end) as null_id,
 sum(case when title is null then 1 else 0 end) as null_title,
 sum(case when year is null then 1 else 0 end) as null_year,
 sum(case when date_published is null then 1 else 0 end) as null_date_published,
 sum(case when duration is null then 1 else 0 end) as null_duration,
 sum(case when country is null then 1 else 0 end) as null_country,
 sum(case when worlwide_gross_income is null then 1 else 0 end) as null_w_g_income,
 sum(case when languages is null then 1 else 0 end) as null_languages,
 sum(case when production_company is null then 1 else 0 end) as null_production_company
from movie;
-- The columns 'country','worlwide_gross_income', 'languages', 'Production_company' have null values.

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select year , count(*) as  number_of_movies
from movie
group by year
order by year;

/*  year| number_of_movies|
   2017	  3052
   2018	  2944
   2019	  2001   */

select 
month(date_published) as month_num , count(*) as number_of_movies
from movie
group by month(date_published)
order by month(date_published); 
/* month | number_of_movies
1	        804
2	        640
3	        824
4	        680
5	        625
6	        580
7	        493
8	        678
9	        809
10	        801
11	        625
12	        438 */

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
select count(*) as USA_INDIA_movies2019
from movie
where (country like '%India%' or country like '%USA%') and year = 2019;
-- There are 1059 movies released in 2019 by USA or INDIA
 
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
select distinct genre
from genre
order by 1;
-- Action
-- Adventure
-- Comedy
-- Crime
-- Drama
-- Family
-- Fantasy
-- Horror
-- Mystery
-- Others
-- Romance
-- Sci-Fi
-- Thriller
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?

select genre,  count(*) as num_of_movies
from genre
group by genre
order by 2 desc;
-- The highest number of movies produced overall is in the drama genre.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?

with one_genre_movie as
(
select movie_id , count(genre) as genres
from genre
group by movie_id
having genres = 1
)
select count(movie_id) as no_of_single_genremovies
from one_genre_movie;
-- There are 3289 movies that belong to only one genre.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

select g.genre, round(avg(m.duration),2) as avg_duration
from movie m
inner join genre g 
on m.id = g.movie_id
group by g.genre
order by 1 desc;

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- genre avg_duration 
-- Thriller	101.58
-- Sci-Fi	97.94
-- Romance	109.53
-- Others	100.16
-- Mystery	101.80
-- Horror	92.72
-- Fantasy	105.14
-- Family	100.97
-- Drama	106.77
-- Crime	107.05
-- Comedy	102.62
-- Adventure 101.87
-- Action	112.88

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
select genre , count(*) as no_of_movies,
rank() over (order by count(*) desc) as genre_rank
from genre
group by genre;

-- genre, no_of_movies, genre_rank
-- Drama	4285	1
-- Comedy	2412	2
-- Thriller	1484	3
-- Action	1289	4
-- Horror	1208	5
-- Romance	906	    6
-- Crime	813	    7
-- Adventure 591    8
-- Mystery	555	    9
-- Sci-Fi	375	    10
-- Fantasy	342	    11
-- Family	302	    12
-- Others	100	    13


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select 
min(avg_rating) as min_avg_rating,
max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_votes,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating
from ratings;
-- min_avg_rating, max_avg_rating, min_total_votes, max_total_votes, min_median_rating, max_median_rating
--   1.0	        10.0	        100	             725138	          1	                 10


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select m.title, r.avg_rating,
dense_rank() over(order by avg_rating desc) as movie_rank
from movie m
inner join ratings r 
on m.id = r.movie_id
limit 10;
-- Top 10 movies based on rating are
-- Title                     avg_rating  movie_Rank
-- Kirket	                 10.0	     1
-- Love in Kilnerry  	     10.0	     1
-- Gini Helida Kathe	     9.8	     2
-- Runam	                 9.7	     3
-- Fan	                     9.6	     4
-- Android Kunjappan Version 5.25	     4
-- Yeh Suhaagraat Impossible 9.5	     5
-- Safe	                     9.5	     5
-- The Brighton Miracle	     9.5	     5
-- Shibu	                 9.4	     6



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

select median_rating, count(*) as movie_count
from ratings
group by median_rating
order by 2 desc;
/* 
median_rating | movie_count
7	2257
6	1975
8	1030
5	985
4	479
9	429
10	346
3	283
2	119
1	94

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, count(*) as movie_cnt,
dense_rank() over( order by count(*) desc) as prod_company_rank
from ratings r
inner join movie m
on r.movie_id = m.id
where r.avg_rating > 8 
group by m.production_company;
-- Dream Warrior Pictures and  National Theatre are among the top performing production_companies based on number of hit movies.







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

select g.genre , count(id) as movie_count
from movie m
join genre g
on m.id = g.movie_id 
join ratings r 
on m.id = r.movie_id
where total_votes > 1000 and country like '%USA%'  and  month(date_published) = 3 and year = '2017'
group by genre
order by 2 desc;

-- genre | movie_count|
-- Comedy	9
-- Thriller	8
-- Sci-Fi	7
-- Crime	6
-- Horror	6
-- Mystery	4
-- Romance	4
-- Fantasy	3
-- Adventure 3
-- Family	1




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
select title, avg_rating, genre
from movie m
join ratings r
on m.id = r.movie_id
join genre g 
on m.id = g.movie_id
where avg_rating > 8 and m.title like 'The%'
order by 2 desc;

-- Title | avg_rating| genre
-- The Brighton Miracle	9.5	Drama
-- The Colour of Darkness	9.1	Drama
-- The Blue Elephant 2	8.8	Drama
-- The Blue Elephant 2	8.8	Horror
-- The Blue Elephant 2	8.8	Mystery
-- The Irishman	8.7	Crime
-- The Irishman	8.7	Drama
-- The Mystery of Godliness: The Sequel	8.5	Drama
-- The Gambinos	8.4	Crime
-- The Gambinos	8.4	Drama
-- Theeran Adhigaaram Ondru	8.3	Action
-- Theeran Adhigaaram Ondru	8.3	Crime
-- Theeran Adhigaaram Ondru	8.3	Thriller
-- The King and I	8.2	Drama
-- The King and I	8.2	Romance

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

select count(m.id) as mr_8
from movie m 
inner join ratings as r
on m.id = r.movie_id
where date_published between '2018-04-01' and '2019-04-01' and median_rating = 8;

-- The number of movies released between 1 April 2018 and 1 April 2019, having a median rating of 8 is 361.alter


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
select sum(r.total_votes) as total_no_ofvotes
from movie m
inner join ratings r 
on m.id = r.movie_id
where country like'%Germany%';
-- Total number of votes for german movies is 2026223


select sum(r.total_votes) as total_no_ofvotes
from movie m
inner join ratings r 
on m.id = r.movie_id
where country like'%Italy%';

-- Total number of votes for Italian movies is 703024


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/

select 
 sum(case when name is null then 1 else 0 end) as name_nulls,
 sum(case when height is null then 1 else 0 end) as height_nulls,
 sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
 sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
 from names ;
 
-- name_nulls	|	height_nulls	|  date_of_birth_nulls  |  known_for_movies_nulls|
--    0		    |		17335	    |	       13431	    |	   15226    	     |




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
with top_genre as (
select genre, count(g.movie_id) as movie_count 
from genre g
inner join ratings r
on g.movie_id = r.movie_id
where avg_rating > 8
group by genre
order by movie_count desc
limit 3
),
top_director as
(
select n.name as director_name,  count(g.movie_id) as movie_count,
row_number() over (order by count(g.movie_id) desc) as director_row_rank 
from names n
inner join director_mapping dm 
on n.id = dm.name_id
inner join genre  g
on g.movie_id = dm.movie_id
inner join ratings r 
on r.movie_id = g.movie_id, top_genre
where g.genre in (top_genre.genre) and avg_rating >8
group by director_name
order by movie_count desc
)

select director_name, movie_count
from top_director
where director_row_rank <=3
limit 3;
/* director_name | movie_count|
   James Mangold	4
   Soubin Shahir	3
    Joe Russo	    3
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select n.name, count(r.movie_id) movie_count, rank() over(order by count(r.movie_id) desc) actor_rank
from ratings r
join role_mapping r_m 
on r.movie_id = r_m.movie_id
join names n 
on  n.id = r_m.name_id
where median_rating >=8
group by n.name
order by 3
limit 2;

-- |Name         | movie_count | actor_rank| 
-- |Mammootty    |	8	        |  1        |
-- |Mohanlal     |	5	        |  2        |
-- |Amrinder Gill|	4	        |  3        |

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
select production_company, sum(total_votes) Total_Votes, rank() over(order by sum(total_votes) desc) vote_rank
from movie m
join ratings r 
on m.id = r.movie_id
group by production_company
order by 3
limit 3;
-- |production_company      | Total_Votes     | vote_rank  |
-- |Marvel Studios	        | 2656967	      |   1        |
-- |Twentieth Century Fox	| 2411163	      |   2        |
-- |Warner Bros.	        | 2396057	      |   3        |

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name as actor_name, total_votes, count(m.id) as movie_count,  
round(sum( total_votes * avg_rating)/sum(total_votes),2) as actor_avg_rating,
rank() over(order by avg_rating desc) as actor_rank
from movie as m
inner join ratings r 
on r.movie_id = m.id
inner join role_mapping rm
on m.id = rm.movie_id
inner join names n
on n.id = rm.name_id
where category = 'Actor' and country = 'India'
group by actor_name
having count(m.id) >= 5
limit 1;
/*
actor_name        | total_votes | movie count | actor_avg_rating | actor_rank
Vijay Sethupathi	20364	        5	           8.42	             1
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name as actress_name, total_votes, count(m.id) as movie_count,
round(sum( total_votes * avg_rating)/sum(total_votes),2) as actress_avg_rating,
rank() over(order by avg_rating desc ) as actress_rank
from movie m
inner join ratings r 
on r.movie_id = m.id
inner join role_mapping rm 
on m.id =  rm.movie_id
inner join names  n
on n.id = rm.name_id
where category = 'actress' and languages = 'hindi' and country = 'india'
group by name
having count(m.id) >= 3
limit 5;
/*
actress_name | total_votes  | movie_count  | actress_avg_rating | actress_rank
Taapsee Pannu	2269	        3	           7.74	                1
Divya Dutta	     345	        3	            6.88	            2
Kriti Kharbanda	1280	        3	            4.80	            3
Sonakshi Sinha	1367	        4	            4.18	            4
*/







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select title, avg_rating,
       CASE
			when avg_rating > 8 then 'Superhit Movie'
			when avg_rating between 7 and 8 then 'Hit Movie'
	        when avg_rating between 5 and 7 then 'One-time-watch Movie'
            else 'Floop Movie'
       end as movie_type
from movie m 
inner join ratings r 
 on m.id = r.movie_id
 inner join genre g
 on g.movie_id = m.id
 where genre = 'thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
with genre_duration as 
(
select genre, round(avg(m.duration),2)  as avg_duration
from movie m
inner join genre g 
on g.movie_id = m.id
group by genre
)
select *, sum(avg_duration) over w1 as running_total_duration,
avg(avg_duration) over w2 as moving_avg_duration
from genre_duration
window w1 as (order by avg_duration rows unbounded preceding),
       w2 as (order by avg_duration rows 3 preceding);

-- genre  |avg_duration | running_total_duration | moving_avg_duration
-- Horror	 92.72	        92.72	                92.720000
-- Sci-Fi	 97.94	        190.66	                95.330000
-- Others	 100.16	        290.82	                96.940000
-- Family	 100.97	        391.79	                97.947500
-- Thriller  101.58	        493.37	                100.162500
-- Mystery	 101.80	        595.17	                101.127500
-- Adventure 101.87	        697.04	                101.555000
-- Comedy	 102.62	        799.66	                101.967500
-- Fantasy	 105.14	        904.80	                102.857500
-- Drama	 106.77	        1011.57	                104.100000
-- Crime	 107.05	        1118.62	                105.395000
-- Romance	 109.53	        1228.15	                107.122500
-- Action	 112.88	        1341.03	                109.057500

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

select genre, count(movie_id) as movie_count
from genre
group by genre
order by movie_count desc
limit 3;
-- The top 3 genres are 
-- Drama	4285
-- Comedy	2412
-- Thriller	1484

with top_movie as 
( select m.year,m.title, m.worlwide_gross_income, g.genre,
dense_rank () over(partition by year order by worlwide_gross_income desc) as movie_rank
from movie m  
inner join genre g
on g.movie_id = m.id
where genre in ('Drama', 'Comedy', 'Thriller') and worlwide_gross_income is not null)

select *
from top_movie
where movie_rank <= 5
group by (title);




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

with multilingual_movie as
( select m. production_company, count(m.id) as movie_count
from movie m 
inner join ratings r
on r.movie_id = m.id
where languages like '%,%' and median_rating >= 8
group by production_company)

select *, dense_rank() over (order by movie_count desc) as prod_comp_rank
from multilingual_movie
where production_company is not null
limit 3;
-- Top Three production companies
-- Preoduction_company | movie_count| prod_comp_rank|
--  Star Cinema	            7	           1
--  Twentieth Century Fox	4	           2
--  Columbia Pictures	    3	           3



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with top_actress as
( select n.name as actress_name, sum(total_votes) as total_votes, count( m.id) as movie_count, r. avg_rating
from names n 
inner join role_mapping rm
on n.id = rm.name_id
inner join ratings r 
on rm.movie_id = r.movie_id
inner join movie m
on m.id = r.movie_id
inner join genre g
on m.id = g.movie_id
where category = 'Actress' and avg_rating > 8 and genre = 'Drama'
group by actress_name)

select *, rank() over ( order by movie_count desc) as actress_rank
from top_actress
limit 3;

-- The top  ranked actress are 
-- actress_name        |  total_votes | movie_count |avg_rating  | actress_rank
-- Parvathy Thiruvothu	4974	        2	           8.3	         1
-- Susan Brown	        656	            2	           8.9	         1
-- Amanda Lawrence	    656	            2	           8.9	         1






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
with date_info as 
( 
select d.name_id, name, d.movie_id, m.date_published, 
lead(date_published,1) over (partition by d.name_id order by date_published, d.movie_id) as new_movie_date
from director_mapping d
inner join names n
on d.name_id = n.id
inner join movie m
on m.id = d.movie_id
),

date_diff as
( 
select *, datediff(new_movie_date, date_published) as diff_days
from date_info
),

avg_inter_days as 
( 
select name_id , avg(diff_days) as avg_inter_movie_days
from date_diff
group by name_id
),

required_data as 
( 
select d.name_id as director_id, name as director_name,
count(d.movie_id) as number_of_movies, round(avg_inter_movie_days) as avg_inter_movie_days,
round(avg(avg_rating),2) as avg_rating,
sum(total_votes) as total_votes,
min(avg_rating) as min_rating,
max(avg_rating) as max_rating,
sum(duration) as total_duration,
row_number() over (order by count(d.movie_id)desc ) as director_rank
from names n 
inner join director_mapping d
on n.id = d.name_id
inner join movie m
on m.id = d.movie_id
inner join ratings r 
on r.movie_id = m.id
inner join avg_inter_days a 
on a.name_id = d.name_id
group by director_id
)

select *
from required_data
limit 9;
/*
director_id | director_name     | nuber_of_movies | avg_inter_movie_days | avg_rating| total_votes | min_rating | max_rating | total_duration | director_rank
nm2096009	Andrew Jones	       5	              191	                 3.02	      1989	         2.7	    3.2	           432	             1
nm1777967	A.L. Vijay             5	              177	                 5.42	      1754	         3.7	    6.9	           613	             2
nm6356309	Özgür Bakar	           4	              112	                 3.75	      1092	         3.1	    4.9	           374	             3
nm2691863	Justin Price	       4	              315	                 4.50	      5343	         3.0	    5.8	           346	             4
nm0814469	Sion Sono	           4	              331	                 6.03	      2972	         5.4	    6.4	           502	             5
nm0831321	Chris Stokes	       4	              198	                 4.33	      3664	         4.0	     4.6	        352	             6
nm0425364	Jesse V. Johnson	   4	              299	                 5.45	      14778	         4.2	     6.5	        383	             7
nm0001752	Steven Soderbergh	   4	              254	                 6.48	      171684	     6.2	     7.0	        401	             8
nm0515005	Sam Liu                4	              260	                 6.23	      28557	         5.8	     6.7	        312            	 9

