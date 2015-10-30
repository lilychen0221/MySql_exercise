/* Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.  */

select m.title, t.avgst from Movie m,
(select mId, avgst from 
(select mId, avg(stars) avgst from Rating group by mID) avg_form
where avgst in 
(select max(avg_form.avgst) from 
(select mId, avg(stars) avgst from Rating group by mID) avg_form)) t
where m.mID = t.mID;

/* Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.  */

select m.title, t.avgst from Movie m,
(select mId, avgst from 
(select mId, avg(stars) avgst from Rating group by mID) avg_form
where avgst in 
(select min(avg_form.avgst) from 
(select mId, avg(stars) avgst from Rating group by mID) avg_form)) t
where m.mID = t.mID;

/* For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves,
 and include each pair only once. For each pair,
 return the names in the pair in alphabetical order.
 */
select distinct r1.name as name1, r2.name as name2 from reviewer r1, reviewer r2,
(select r1.rID as rID1, r2.rID as rID2
from Rating r1, Rating r2
where r1.mID = r2.mID and r1.rID <> r2.rID) as IDForm
where r1.rID = IDForm.rID1 and r2.rID = IDForm.rID2
order by name1;

select distinct name1, name2 from   
(select r1.name as name1, r2.name as name2
from
(select rt1.rID as rID1, rt2.rID as rID2
from Rating rt1, Rating rt2
where rt1.mID = rt2.mID and rt1.rID <> rt2.rID) IDForm
inner join Reviewer r1
on r1.rID = IDForm.rID1
inner join Reviewer r2
on r2.rID = IDForm.rID2
order by name1) nameForm
where name1 < name2;

-- using distinct to remove the duplicate rows and using name1< name2 to remove the same pairs which only in reversed order.


/* For each director, return the director's name together with the title(s) 
of the movie(s) they directed that received the highest rating among all of their movies, 
and the value of that rating. Ignore movies whose director is NULL.  */

select distinct director, title, stars
from (select *
from Rating join Movie using(mID) ) BestMovies
where not exists (select * from Rating join Movie using(mID) where BestMovies.director = director and BestMovies.stars < stars) and director is not null;


 -- firstly, find the director title and the highest stars for (director, title), 
select distinct director, title, max(stars)as star1 from Movie inner join Rating on Movie.mID = Rating.mID
group by director, title 
having director is not NULL
order by director, stars DESC;

-- secondly, find the highest star for every director;
select distinct  director, max(stars) as star2 from Movie inner join Rating on Movie.mID = Rating.mID
group by director
having director is not NULL;

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

