/*  sql project1:
start a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. There's not much data yet, but you can still try out some interesting queries. Here's the schema: 

Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. */

/* Delete the tables if they already exist */
drop table if exists Movie;
drop table if exists Reviewer;
drop table if exists Rating;

/* Create the schema for our tables */
create table Movie
(mID int, 
 title text, 
 year int, 
 director text,
 primary key(mID));

create table Reviewer
(rID int,
 name text,
 primary key(rID));

create table Rating
(rID int,
 mID int,
 stars int,
 ratingDate date,
 constraint foreign key (rID) references Reviewer (rID),
 constraint foreign key (mID) references Movie (mID)
);

/* Populate the tables with our data */
insert into Movie values(101, 'Gone with the Wind', 1939, 'Victor Fleming');
insert into Movie values(102, 'Star Wars', 1977, 'George Lucas');
insert into Movie values(103, 'The Sound of Music', 1965, 'Robert Wise');
insert into Movie values(104, 'E.T.', 1982, 'Steven Spielberg');
insert into Movie values(105, 'Titanic', 1997, 'James Cameron');
insert into Movie values(106, 'Snow White', 1937, null);
insert into Movie values(107, 'Avatar', 2009, 'James Cameron');
insert into Movie values(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

insert into Reviewer values(201, 'Sarah Martinez');
insert into Reviewer values(202, 'Daniel Lewis');
insert into Reviewer values(203, 'Brittany Harris');
insert into Reviewer values(204, 'Mike Anderson');
insert into Reviewer values(205, 'Chris Jackson');
insert into Reviewer values(206, 'Elizabeth Thomas');
insert into Reviewer values(207, 'James Cameron');
insert into Reviewer values(208, 'Ashley White');

insert into Rating values(201, 101, 2, '2011-01-22');
insert into Rating values(201, 101, 4, '2011-01-27');
insert into Rating values(202, 106, 4, null);
insert into Rating values(203, 103, 2, '2011-01-20');
insert into Rating values(203, 108, 4, '2011-01-12');
insert into Rating values(203, 108, 2, '2011-01-30');
insert into Rating values(204, 101, 3, '2011-01-09');
insert into Rating values(205, 103, 3, '2011-01-27');
insert into Rating values(205, 104, 2, '2011-01-22');
insert into Rating values(205, 108, 4, null);
insert into Rating values(206, 107, 3, '2011-01-15');
insert into Rating values(206, 106, 5, '2011-01-19');
insert into Rating values(207, 107, 5, '2011-01-20');
insert into Rating values(208, 104, 3, '2011-01-02');


/*---------- 1. SQL Movie-Rating Query Exercises ----------*/
-- Q1 Find the titles of all movies directed by Steven Spielberg. 

select 
   title 
from Movie
where director = "Steven Spielberg";

-- Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
select distinct year from Movie, Rating
where Movie.mID = Rating.mID
and stars >= 4
order by year;

-- Q3 Find the titles of all movies that have no ratings. 
select title from Movie
left join Rating
on Movie.mID = Rating.mID
where Rating.mID is NULL;

select title from Movie 
where mID not in
(select distinct mID from Rating);

-- Q4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

select name from Reviewer
inner join Rating
on Reviewer.rID = Rating.rID
where ratingDate is NULL;

select r.name from Reviewer r
where r.rID in 
(select rID from Rating where ratingDate is NULL);

-- Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

select name, title, stars, ratingDate 
from Movie, Rating, Reviewer
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
order by name, title, stars;

-- Q6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 

select r.name, m.title from Reviewer r, Movie m, Rating rt1, Rating rt2
where m.mID = rt1.mID and m.mID = rt2.mID
and r.rID = rt1.rID and r.rID = rt2.rID 
and rt1.ratingDate < rt2.ratingDate and rt1.stars < rt2.stars;

-- Q7 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

select title, max(stars) from Rating rt, Movie m
where rt.mID = m.mID and stars >= 1
group by rt.mID
order by title;

-- Q8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

select m.title, max(rt.stars) - min(rt.stars) as rating_spread
from Movie m, Rating rt
where m.mID = rt.mID
group by m.mID
order by rating_spread DESC, m.title;

-- Q9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980.
select before1980.avg_befor1980 - after1980.avg_after1980 
from
(select 
     avg(form1.avgst) as avg_befor1980 
     from 
     ((select 
          m.title, 
          avg(r.stars) as avgst 
       from Movie m, Rating r where m.year < 1980 and m.mID = r.mID 
       group by m.title))form1) as before1980,
(select 
     avg(form2.avgst2) as avg_after1980 
     from 
     ((select 
          m.title, 
          avg(r.stars) as avgst2 
       from Movie m, Rating r where m.year > 1980 and m.mID = r.mID 
       group by m.title))form2) as after1980;
       
-- Q10 Find the names of all reviewers who rated Gone with the Wind. 
select distinct name from Reviewer, Rating, Movie
where Reviewer.rID =Rating.rID and Movie.mID = Rating.mID
and title = "Gone with the Wind"
order by name;

-- Q11 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
select r.name, m.title, rt.stars from Reviewer r, Rating rt, Movie m
where r.rID = rt.rID and rt.mID = m.mID
and m.director = r.name;


-- Q12 Return all reviewer names and movie names together in a single list, alphabetized.
select name
from Reviewer
union
select title
from Movie
order by name, title;

-- Q13 Find the titles of all movies not reviewed by Chris Jackson. 
select title from Movie
where mID not in
(select mID from Rating
inner join 
Reviewer 
on Rating.rID=Reviewer.rID 
where name = "Chris Jackson"
)
order by title;

select title from Movie 
where mID not in 
(select mID from Rating where rID in 
(select rID from Reviewer where name = "Chris Jackson"));

-- Q14 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
select distinct name1, name2 from
(select r1.name as name1, r2.name as name2 from Reviewer r1, Reviewer r2, 
(select distinct rt1.rID as rID1, rt2.rID as rID2 from Rating rt1, Rating rt2
where rt1.mID = rt2.mID and rt1.rID <> rt2.rID) IDForm
where r1.rID = IDForm.rID1 and r2.rID = IDForm.rID2
order by name1)nameForm
where name1 < name2;


-- Q15 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
select r.name, m.title, rt.stars from Movie m, Reviewer r, Rating rt
where m.mID = rt.mID and r.rID = rt.rID
and rt.stars in
(select min(stars) from Rating);

-- Q16 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
select m.title, avg(rt.stars) as avgRating from Movie m
inner join Rating rt
on m.mID = rt.mID
group by m.title
order by avgRating DESC, m.title; 

-- Q17 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name from Reviewer r
inner join Rating rt
on r.rID = rt.rID
group by r.rID
having count(r.rID) >= 3;

-- Q18 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. 
select title, director from Movie
where director in
(select director from movie
group by director
having count(*) > 1)
order by director, title;


-- Q19 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.



select title, avgst from
(select title, avg(stars) as avgst from Movie m, Rating rt
where m.mID = rt.mID
group by title)avgform
where avgst in
(select max(avgst) from
(select avg(stars) avgst from Movie m 
inner join Rating rt
on m.mID = rt.mID
group by m.mID) avgform
); 

select m.title, t.avgst from Movie m,
(select mId, avgst from 
(select mId, avg(stars) avgst from Rating group by mID) avg_form
where avgst in 
(select max(avg_form.avgst) from 
(select mId, avg(stars) avgst from Rating group by mID) avg_form)) t
where m.mID = t.mID;

-- Q20 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating
select m.title, t.avgst from Movie m,
(select mId, avgst from 
(select mId, avg(stars) avgst from Rating group by mID) avg_form
where avgst in 
(select min(avg_form.avgst) from 
(select mId, avg(stars) avgst from Rating group by mID) avg_form)) t
where m.mID = t.mID;

-- Q21 For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
select  distinct t1.director, t1.title, t1.stars from
(select director, title, stars from Movie m, Rating rt 
where m.mID = rt.mID and director is not NULL) t1,
(select director,max(stars) as maxstars from Movie m, Rating rt 
where m.mID = rt.mID and director is not NULL
group by director) t2
where t1.director = t2.director and t1.stars = t2.maxstars;


select t1.director, title, star2 from
(select distinct director, title, max(stars)as star1 from Movie inner join Rating on Movie.mID = Rating.mID
group by director, title 
having director is not NULL
order by director, stars DESC) t1
inner join 
(select distinct  director, max(stars) as star2 from Movie inner join Rating on Movie.mID = Rating.mID
group by director
having director is not NULL) t2
on t1.director = t2.director and t1.star1 = t2.star2;
