/* Delete the tables if they already exist */
drop table if exists Highschooler;
drop table if exists Friend;
drop table if exists Likes;

/* Create the schema for our tables */
create table Highschooler
(ID int, 
 name text, 
 grade int,
 primary key(ID)
 );
 
create table Friend
(ID1 int, 
 ID2 int);
 
create table Likes
(ID1 int, 
 ID2 int);
 
 /* Populate the tables with our data */
insert into Highschooler values (1510, 'Jordan', 9);
insert into Highschooler values (1689, 'Gabriel', 9);
insert into Highschooler values (1381, 'Tiffany', 9);
insert into Highschooler values (1709, 'Cassandra', 9);
insert into Highschooler values (1101, 'Haley', 10);
insert into Highschooler values (1782, 'Andrew', 10);
insert into Highschooler values (1468, 'Kris', 10);
insert into Highschooler values (1641, 'Brittany', 10);
insert into Highschooler values (1247, 'Alexis', 11);
insert into Highschooler values (1316, 'Austin', 11);
insert into Highschooler values (1911, 'Gabriel', 11);
insert into Highschooler values (1501, 'Jessica', 11);
insert into Highschooler values (1304, 'Jordan', 12);
insert into Highschooler values (1025, 'John', 12);
insert into Highschooler values (1934, 'Kyle', 12);
insert into Highschooler values (1661, 'Logan', 12);

insert into Friend values (1510, 1381);
insert into Friend values (1510, 1689);
insert into Friend values (1689, 1709);
insert into Friend values (1381, 1247);
insert into Friend values (1709, 1247);
insert into Friend values (1689, 1782);
insert into Friend values (1782, 1468);
insert into Friend values (1782, 1316);
insert into Friend values (1782, 1304);
insert into Friend values (1468, 1101);
insert into Friend values (1468, 1641);
insert into Friend values (1101, 1641);
insert into Friend values (1247, 1911);
insert into Friend values (1247, 1501);
insert into Friend values (1911, 1501);
insert into Friend values (1501, 1934);
insert into Friend values (1316, 1934);
insert into Friend values (1934, 1304);
insert into Friend values (1304, 1661);
insert into Friend values (1661, 1025);
insert into Friend select ID2, ID1 from Friend;

insert into Likes values(1689, 1709);
insert into Likes values(1709, 1689);
insert into Likes values(1782, 1709);
insert into Likes values(1911, 1247);
insert into Likes values(1247, 1468);
insert into Likes values(1641, 1468);
insert into Likes values(1316, 1304);
insert into Likes values(1501, 1934);
insert into Likes values(1934, 1501);
insert into Likes values(1025, 1101);

-- Question 1
-- For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.
select h1.name as n1, h1.grade as g1, h2.name as n2, h2.grade as g2, h2.name as n3, h3.grade as g3
from Highschooler h1, Highschooler h2, Highschooler h3,
(select l1.ID1 as A, l1.ID2 as B, l2.ID2 as C from Likes l1, Likes l2
where l1.ID2 = l2.ID1 and l2.ID2 <> l1.ID1)t
where t.A = h1.ID and t.B = h2.ID and t.C = h3.ID;

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Likes L1, Likes L2, Highschooler H1, Highschooler H2, Highschooler H3
where L1.ID2 = L2.ID1
and L2.ID2 <> L1.ID1
and L1.ID1 = H1.ID and L1.ID2 = H2.ID and L2.ID2 = H3.ID
;

select ID1, h.name from Friend f, Highschooler h
where f.ID2 = h.ID and h.name = "Cassandra" or h.name = "Cassandra"

