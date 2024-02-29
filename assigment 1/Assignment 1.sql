set schema 'goodreads_v3';

-- 1. What is the first and last name of the author with id 23?
select firstname, lastname
from authors
where id = 23;

-- 2. What book has the id 24358527?
select title
from books
where id = 24358527;

-- 3. How many profiles are there?
select count(profilename)
from profile;

-- 4. How many profiles have the first name 'Abram'?
select count(profilename)
from profile
where firstname = 'Abram';

-- 5. Create a list of book titles and their page count, order by the book with the highest page count first
select title, pagecount
from books
order by pagecount desc ;

-- 6. Create a list of book titles and their page count,
-- order by the book with the highest page count first, but remove books without a page count.
select title, pagecount
from books
where pagecount is not null
order by pagecount desc ;

-- 7. Show the books published in 2017.
select title
from books
where yearpublished = 2017;

-- 8. How many books do not have an ISBN number?
select count(*)
from books
where isbn = null;

-- 9. How many authors have a middle name?
select count(*)
from authors
where middlenames is not null;

select count(middlenames)
from authors;

-- 10. What is the most common firstname for a profile?
select firstname, count(firstname) as count
from profile
group by firstname
order by count desc limit 1;

-- 11. Show an overview of author first name and last name and how many books they have written.
--     Order by highest count at the top.
select firstname, lastname, count(title) count
from authors, books
where authors.id = books.writtenbyid
group by firstname, lastname
order by count desc ;

select firstname, lastname, count(title) count
from authors a  join books b on a.id = b.writtenbyid
group by firstname, lastname
order by count desc;

-- 12. What is the title of the book with the highest page count
select title, pagecount
from books
where pagecount = (
    select max(pagecount)
    from books
    );

select title, pagecount
from books
where pagecount is not null
order by pagecount desc limit 1;

-- 13. What is the title of the book with the fifth highest page count?
select title, pagecount
from books
where pagecount is not null
order by pagecount desc limit 1 offset 4;

select title, pagecount
from books
where pagecount in (
    select max(pagecount) max
    from books
    group by max
    order by pagecount desc             -----tried to do as previous but failed
    limit 5 offset 4
    );

-- 14. List the firstnames of the profiles that does not have an unique firstname
select distinct firstname
from profile
where firstname in (
    select firstname
    from profile
    group by firstname
    having count(*) > 1
    );

SELECT  DISTINCT p1.firstname
FROM profile p1 JOIN profile p2 ON p1.firstname=p2.firstname
WHERE p1.profilename!=p2.profilename;

-- 15. Who published 'Tricked (The Iron Druid Chronicles, #4)'
-- Hint, you may not be able to get an exact match of the name above.
select name
from publishers, books
where publishers.id = books.publishedbyid
and books.title like 'Tricked%';

select name
from publishers p inner join books b on p.id = b.publishedbyid
where b.title ilike 'Tricked%';

select name
from publishers
where id = (
    select publishedbyid
    from books
    where title = '%Tricked%'
    );                            --------why this doesnt work?

-- 16. What's the binding type of 'Fly by Night'?
select type
from books, bindings
where books.bindingid = bindings.id
and books.title = 'Fly by Night';

select type
from books b inner join bindings b2 on b.bindingid = b2.id
where b.title = 'Fly by Night';

-- 17. What is the most popular binding type?
select type, count(title) count
from bindings, books
where books.bindingid = bindings.id
group by type
order by count desc limit 1;

-- 18. How many books has the reader with the profile name 'Venom_Fate' read?
select count(datefinished)
from books_read, profile
where books_read.profilename = profile.profilename
and profile.profilename = 'Venom_Fate';

select count(datefinished)
from books_read br inner join profile p on br.profilename = p.profilename
and p.profilename = 'Venom_Fate';

SELECT count(*)
FROM books_read
WHERE profilename = 'Venom_Fate';

-- 19. How many books are written by Brandon Sanderson?
select count(title)
from books, authors
where books.writtenbyid = authors.id
and authors.firstname = 'Brandon'
and authors.lastname = 'Sanderson';

select count(title)
from books
where writtenbyid = (
    select id
    from authors
    where firstname = 'Brandon'
    and lastname = 'Sanderson'
    );

select title, pagecount, isbn, email, website
from books b join authors a on a.id = b.writtenbyid
group by pagecount,title, isbn, email, website;

-- 20. How many readers have read the book 'Gullstruck Island'?
select count(datefinished)
from books_read, books
where books_read.bookid = books.id
and books.title = 'Gullstruck Island';

-- 21. How many books have the author Ray Porter co-authored?
select firstname, lastname, count(title) count
from coauthors ca inner join books b on ca.book_id = b.id
inner join authors a on a.id = ca.author_id
and a.firstname = 'Ray'
and a.lastname = 'Porter'
group by firstname, lastname;

SELECT count(*)
FROM coauthors
WHERE author_id =(
    SELECT id
    FROM authors
    WHERE firstname='Ray' AND lastname='Porter'
    );


-- 22. What type of binding does 'Dead Iron (Age of Steam,  #1)' have?
select type
from bindings, books
where bindings.id = books.bindingid
and books.title = 'Dead Iron (Age of Steam,  #1)';

-- 23. What are the names of the author and co-authors of the book which contains 'Wild Cards' in its title?
select firstname, lastname
from authors a inner join books b on a.id = b.writtenbyid
inner join coauthors ca on ca.book_id = b.id
and b.title = '%Wild Cards%';

SELECT firstname, middlenames, lastname
FROM authors
WHERE id IN (
    SELECT writtenbyid
    FROM books
    WHERE title LIKE '%Wild Cards%'
    )
OR id IN (
    SELECT author_id
    FROM coauthors
    WHERE book_id IN (
        SELECT id
        FROM books
        WHERE title LIKE '%Wild Cards%'
        )
    );

-- 24. What is the most popular binding type of Brandon Sanderson books?
select type, count(type) count
from bindings b inner join books on b.id = books.bindingid
where writtenbyid = (
    select id
    from authors
    where firstname = 'Brandon'
    and lastname = 'Sanderson'
    )
group by type
order by count desc limit 1;

-- 25. For each profile, show how many books they have read.
select profilename, count(datefinished) count
from books_read
group by profilename
order by count desc ;

-- 26. Show all the genres of the book 'Hand of Mars (Starship's Mage,  #2)'.
select genrename
from genres g, books b, book_genre bg
where b.id = bg.book_id
and bg.genre_id = g.id
and b.title = 'Hand of Mars (Starship''s Mage,  #2)';

-- 27. Show a list of both author and co-authors for the book with title 'Dark One'.
SELECT firstname, middlenames, lastname
FROM authors
WHERE id IN (
    SELECT writtenbyid
    FROM books
    WHERE title = 'Dark One'
    )
OR id IN (
    SELECT author_id
    FROM coauthors
    WHERE book_id IN (
        SELECT id
        FROM books
        WHERE title = 'Dark One'
        )
    );

-- 28. Which author has made the most announcements?
select firstname, lastname, count(announcements.id) count
from announcements, authors
where writtenbyid = authors.id
group by firstname, lastname
order by count desc limit 1;

-- 29. Which author has the highest total of announcement likes?
select firstname, lastname, count(announcementlikes) count
from announcementlikes, announcements, authors
where announcementid = announcements.id
and announcements.writtenbyid = authors.id
group by firstname, lastname
order by count desc limit 1;

SELECT au.id, firstname, middlenames, lastname, count(*) AS likescount
FROM authors au JOIN announcements a on au.id = a.writtenbyid JOIN announcementlikes a2 on a.id = a2.announcementid
GROUP BY au.id, firstname, middlenames, lastname
ORDER BY likescount DESC;

-- 30. A profiles favourite author is the author they have read most books of. Ignore co-authors. Use only "has read" books.
-- Pick a profile, and find that profiles favourite author's name
select firstname, lastname, count(writtenbyid) count
from authors a inner join books b on a.id = b.writtenbyid
inner join books_read br on br.bookid = b.id
where profilename = 'music_viking'
group by firstname, lastname
order by count desc limit 1;


-- 31. Which author is read the most?
select count(writtenbyid) count, firstname, lastname
from authors a inner join books b on a.id = b.writtenbyid
inner join books_read br on b.id = br.bookid
group by firstname, lastname
order by count desc limit 1;

select count(datefinished) count, firstname, lastname
from authors a inner join books b on a.id = b.writtenbyid
inner join books_read br on br.bookid = b.id
group by firstname, lastname
order by count desc limit 1;

SELECT firstname, lastname, count(*) AS booksreadCount
FROM books_read JOIN books b on b.id = books_read.bookid JOIN authors a on b.writtenbyid = a.id
GROUP BY firstname, lastname
ORDER BY booksreadCount DESC
LIMIT 1;

-- 32. Which profile has liked the most comments?
select profilename, count(announcementid) count
from announcementlikes
group by profilename
order by count desc limit 1;

-- 33. What is the title of the book which is read by most readers
select title, count(bookid) count
from books b inner join currently_reading cr on b.id = cr.bookid
group by title
order by count desc limit 1;

SELECT profilename, count(*) AS countlikes
FROM announcementlikes
GROUP BY profilename
ORDER BY countlikes DESC
LIMIT 1;

-- 34. For the top-ten largest books (page count wise) show their title and binding type
select title, type, pagecount
from books b inner join bindings b2 on b.bindingid = b2.id
where pagecount is not null
group by title, type, pagecount
order by pagecount desc limit 10;

SELECT title, type
FROM books b JOIN bindings b2 on b.bindingid = b2.id
WHERE title IN (
    SELECT title
    FROM books
    WHERE pagecount IS NOT NULL
    ORDER BY pagecount DESC
    LIMIT 10
    );

-- 35. Show a count of how many books there are in each genre
select genrename, count(book_id) count
from genres, book_genre, books
where genres.id = book_genre.genre_id
and book_genre.book_id = books.id
group by genrename
order by count desc;

SELECT genrename, count(*) AS cnt
FROM genres g JOIN book_genre bg on g.id = bg.genre_id
GROUP BY genrename;

-- 36. Show a list of publisher names and how many books they each have published
select name, count(title) count
from publishers, books
where publishedbyid = publishers.id
group by name
order by count desc;

SELECT p.name, count(*)
FROM publishers p JOIN books b on p.id = b.publishedbyid
GROUP BY p.name;

-- 37. Which book has the highest average rating?
select title, avg(rating) avg  --ROUND(AVG(br.rating)::numeric, 2) avg
from books, books_read
where books.id = books_read.bookid
group by title
order by avg desc limit 1;

SELECT title, AVG(rating) AS averageRating
FROM books b JOIN books_read br on b.id = br.bookid
GROUP BY title
ORDER BY averageRating DESC
LIMIT 1;

-- 38. What's the lowest rated book?
select title, avg(rating) avg
from books, books_read
where books.id = books_read.bookid
group by title
order by avg limit 1;

SELECT title, AVG(rating) AS averageRating
FROM books b JOIN books_read br on b.id = br.bookid
GROUP BY title
ORDER BY averageRating ASC
LIMIT 1;

-- 39. How many books have reader 'radiophobia' read in 2018?
select count(datefinished)
from books_read
where profilename = 'radiophobia'
and extract(year from datefinished) = 2018;

SELECT count(*)
FROM books_read
WHERE profilename='radiophobia'
AND datefinished BETWEEN '01-01-2018' AND '31-12-2018';

-- 40. Show a list of how many books reader 'radiophobia' have read each year.
select extract(year from datefinished) as year, count(datefinished) count
from books_read
where profilename = 'radiophobia'
group by year;

-- 41. Show all authors (ignore coauthors) and the average rating of their books. Order by highest to lowest
select firstname, lastname, avg(rating) avg
from authors a inner join books b on a.id = b.writtenbyid
inner join books_read br on b.id = br.bookid
group by firstname, lastname
order by avg desc ;

-- 42. Is there any book, which hasn't been read?
select title
from books
where id not in (
    select id
    from books b inner join books_read br on b.id = br.bookid
    );

-- 43. Which book has been read the most times?
select title, count(datefinished) count
from books b inner join books_read br on b.id = br.bookid
group by title
order by count desc limit 1;

-- 44. Which reader has read the most books
select profilename, count(datefinished) count
from books_read
group by profilename
order by count desc limit 1;

-- 45. Show how many pages in total each reader has read. Limit to top 10.
select profilename, sum(pagecount) totalPageCount
from books_read br inner join books b on b.id = br.bookid
group by profilename
order by totalPageCount desc limit 10;

-- 46. What's the lowest number of days to read 'Oathbringer (The Stormlight Archive,  #3)', and who did that?
select profilename, (books_read.datefinished - books_read.datestarted) as difference
from books_read, books
where books_read.bookid = books.id
and books.title = 'Oathbringer (The Stormlight Archive,  #3)'
order by difference limit 1;

SELECT profilename, datefinished-datestarted as readtime
FROM books_read
WHERE bookid = (
    SELECT id
    FROM books
    WHERE title = 'Oathbringer (The Stormlight Archive,  #3)'
    )
ORDER BY readtime ASC
LIMIT 1;

-- 47. Which Genre describes the most books?
select genrename, count(book_id) count
from genres g inner join book_genre bg on g.id = bg.genre_id
inner join books b on bg.book_id = b.id
group by genrename
order by count desc limit 1;

-- 48. Show how many pages each author has written (include co-authors)
select firstname, lastname, sum(pagecount) sum
from authors a inner join books b on a.id = b.writtenbyid
group by firstname, lastname;         ---did only authors, how to include coauthors?

-- 49. How many different first names are there in the profiles?
select count(distinct firstname) as count
from profile;

-- 50. For each first name, show a list of number of people with that first name.
select firstname, count(firstname) count
from profile
group by firstname;

-- 51. Which profile has liked the most announcements?
select profilename, count(announcementid) count
from announcementlikes
group by profilename
order by count desc limit 1;

-- 52. Which profile has the longest list of "want to read"?
select profilename, count(bookid) count
from wants_to_read
group by profilename
order by count desc limit 1;

-- 53. Which profile has written the most reviews?
select profilename, count(review) count
from books_read
group by profilename
order by count desc limit 1;

-- 54. Which profile has given the overall lowest average rating?
select profilename, avg(rating) avg
from books_read
group by profilename
order by avg limit 1;

-- 55. Who has been stuck on reading their current book the longest?
select profilename, bookid, (current_date - currently_reading.datestarted) as readingFor
from currently_reading
order by readingFor desc limit 1;

SELECT profilename, datestarted
FROM currently_reading
WHERE datestarted = (
    SELECT MIN(datestarted)
    FROM currently_reading
    );

-- 56. Produce a result of publishers with their adresses.
select name, cityname, citypostcode, street, housenumber
from publishers, address
where address.publisherid = publishers.id;

SELECT *
FROM publishers p JOIN address a on p.id = a.publisherid;

-- 57. Display the title, binding type, and author first and last name for all books.
select title, type, firstname, lastname
from books b inner join bindings b2 on b.bindingid = b2.id
inner join authors a on b.writtenbyid = a.id; ---it is good? because handin is different

-- 58. Explain what the following SQL statement does.
SELECT profilename
FROM announcementlikes
WHERE announcementid IN (
    SELECT id
    FROM announcements
    WHERE writtenbyid = (
        SELECT id
        FROM authors WHERE firstname = 'Glynn' AND lastname = 'Stewart'
        )
    )
EXCEPT
SELECT p.profilename
FROM profile p join books_read br on p.profilename = br.profilename
join books b on br.bookid = b.id
WHERE writtenbyid = (
        SELECT id
        FROM authors WHERE firstname = 'Glynn' AND lastname = 'Stewart'
        );

-- 59. For each profile, show the name of the author, whose announcements they have liked most.
select profilename, firstname authorFirstName, lastname authorLastName
from announcementlikes a inner join announcements a2 on a.announcementid = a2.id
inner join authors a3 on a2.writtenbyid = a3.id
group by profilename, authorFirstName, authorLastName
order by count(announcementid) desc;

-- 60. Display the favourite author (The author whom they have read the most of) of all profiles.
select firstname, lastname, count(datestarted) count
from authors a inner join books b on a.id = b.writtenbyid
inner join books_read br on b.id = br.bookid
group by firstname, lastname
order by count desc limit 1;

-- 61. What is each reader's most read genre?
select profilename, genrename, count(genrename) as count
from books_read br inner join books b on br.bookid = b.id
inner join book_genre bg on b.id = bg.book_id
inner join genres g on bg.genre_id = g.id
group by profilename, genrename;
