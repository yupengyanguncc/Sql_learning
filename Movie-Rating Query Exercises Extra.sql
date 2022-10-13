-- Find the names of all reviewers who rated Gone with the Wind. 
SELECT DISTINCT name
FROM Movie
INNER JOIN Rating USING (mId)
INNER JOIN Reviewer USING (rId)
WHERE title = "Gone with the Wind";

-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars
FROM Movie
INNER JOIN Rating USING (mId)
INNER JOIN Reviewer USING (rId)
WHERE director = name;

-- Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
SELECT title FROM Movie
UNION
SELECT name FROM Reviewer
ORDER BY name, title;
Q4 Find the titles of all movies not reviewed by Chris Jackson.
SELECT DISTINCT title 
FROM Movie
WHERE mID not it (
SELECT mID
FROM Rating 
INNER JOIN Reviewer Using (rID)
WHERE name = “Chris Jackson”)

--For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
SELECT DISTINCT Re1.name, Re2.name
FROM Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
WHERE R1.mID = R2.mID
AND R1.rID = Re1.rID
AND R2.rID = Re2.rID
AND Re1.name < Re2.name
ORDER BY Re1.name, Re2.name;

--For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars
SELECT name, title, stars
FROM Movie
INNER JOIN Rating USING(mId)
INNER JOIN Reviewer USING(rId)
WHERE stars = (SELECT MIN(stars) FROM Rating);


--List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
SELECT title, AVG (stars) AS average
FROM Movie
INNER JOIN Rating USING (mId)
GROUP BY mId
ORDER BY average DESC, title;


--Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
SELECT name
FROM Reviewer
WHERE (SELECT COUNT(*) FROM Rating WHERE Rating.rId = Reviewer.rId) >= 3;

-- Extra challenge 
SELECT b.name
FROM (SELECT rID,SUM(1) Sum1
      FROM rating
      GROUP BY rID
      )a
JOIN reviewer b
  ON a.rID = b.rID
WHERE Sum1 >= 3

--Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
SELECT title, director
FROM Movie M1
WHERE (SELECT COUNT(*) FROM Movie M2 WHERE M1.director = M2.director) > 1
ORDER BY director, title;

--Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 

SELECT title, AVG(stars) AS average
FROM Movie
INNER JOIN Rating USING(mId)
GROUP BY mId
HAVING average = (
  SELECT MAX(average_stars)
  FROM (
    SELECT title, AVG(stars) AS average_stars
    FROM Movie
    INNER JOIN Rating USING(mId)
    GROUP BY mId
  )
);

--Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 

SELECT title, AVG(stars) AS average
FROM Movie
INNER JOIN Rating USING(mId)
GROUP BY mId
HAVING average = (
  SELECT MIN(average_stars)
  FROM (
    SELECT title, AVG(stars) AS average_stars
    FROM Movie
    INNER JOIN Rating USING(mId)
    GROUP BY mId
  )
);

-- For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
SELECT director, title, MAX(stars)
FROM Movie
INNER JOIN Rating USING(mId)
WHERE director IS NOT NULL
GROUP BY director;
select distinct
min(v1.name, v2.name) reviewer1,
max(v1.name, v2.name) reviewer2
from movie m
inner join rating r1 on r1.mid = m.mid
inner join rating r2 on r2.mid = m.mid
inner join reviewer v1 on v1.rid = r1.rid
inner join reviewer v2 on v2.rid = r2.rid
where v1.rid <> v2.rid
order by reviewer1, reviewe
