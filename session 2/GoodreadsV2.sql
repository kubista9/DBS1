create schema goodreads_v2;
set schema 'goodreads_v2';

--What is the first and last name of the author with id 23
select id, first_name, last_name
from author
where id = 23;

--What book has the id 24358527?
select title
from book
where id = '24358527';

--How many profiles are there?
select count(*)
from profile;

--How many profiles have the first name 'Jaxx'?
select count(*)
from profile
where first_name = 'Jaxx';

--Are there two authors with the same first name?
select first_name, count(first_name) count
from author
group by first_name
order by count desc;

--Create a list of book titles and their page count, order by the book with the highest page count first.
select title, page_count
from book
where page_count is not null
order by page_count desc;

--Show the books published in 2017.
select *
from book
where year_published = 2017;

--Who published "Tricked (The Iron Druid Chronicles,  #4)"
select publisher_name, id
from publisher
where id = (select publisher_id from book where title = 'Tricked (The Iron Druid Chronicles,  #4)');

--What's the binding type of 'Fly by Night'?
select type
from binding_type
where id = (select binding_id from book where title = 'Fly by Night' );

--How many books do not have an ISBN number?
select count(*)
from book
where isbn is null;

--How many authors have a middle name?
select count(*)
from author
where middle_name is not null;

--Show an overview of author id and how many books they have written. Order by highest count at the top.
select author_id, count(*) as count
from book
group by author_id
order by count desc;

--What is the highest page count?
select max(page_count)
from book;

--What is the title of the book with the highest page count?
select title
from book
where page_count = (
    select max(page_count)
        from book);

--How many books has the reader with the profile name 'Venom_Fate' read?
select count(*)
from book_read
where profile_id = (
select id
from profile
where profile_name = 'Venom_Fate');

--How many books are written by Brandon Sanderson?
select count(*)
from book
where author_id = (
select id
from author
where first_name = 'Brandon' and last_name = 'Sanderson');

--How many readers have read the book 'Gullstruck Island'?
select count(*)
from book_read
where status = 'read'
and book_id = (
select id
from book
where title = 'Gullstruck Island');

--How many books have the author Ray Porter co-authored?
select count(*)
from co_authors
where author_id = (select id from author where first_name = 'Ray' and last_name = 'Porter' );

--What type of binding does 'Dead Iron (Age of Steam,  #1)' have?
SELECT type
from binding_type,
     book
WHERE book.binding_id = binding_type.id
  AND book.title = 'Dead Iron (Age of Steam,  #1)';

--Show a list of each binding type and how many books are using that type.
select type, count(*)
from book b inner join binding_type bt on b.binding_id = bt.id
group by type;

--For each profile, show how many books they have read.
select profile_name, count(*)
from profile p inner join book_read br on p.id = br.profile_id
group by profile_name;

--Show all the genres of the book 'Hand of Mars 'Starship's Mage,  #2'
select genre
from genre g, book_genre bg, book b
where g.id = bg.genre_id and bg.book_id = b.id and b.title = 'Hand of Mars (Starship''s Mage,  #2)';

--Show a list of both author and co-authors for the book with title 'Dark One'
select first_name, last_name
from book b, author a
where b.author_id = a.id and b.title = 'Dark One'
union
select first_name, last_name
from author a, co_authors ca, book b
where b.id = ca.book_id
and a.id = ca.author_id
and b.title = 'Dark One';

--What is the title of the book which is read by most readers.
select title, book_id, count(*) as count
from book, book_read
where book.id = book_read.book_id
and book_read.status = 'read'
group by title, book_id
order by count desc limit 1;

--For the top-ten largest books (page count wise) show their title and binding type.
select title, type, page_count
from book, binding_type
where book.binding_id = binding_type.id
and page_count is not null
order by page_count desc
limit 10;

--Show a count of how many books there are in each genre
select genre, count(title) as count
from book_genre, genre, book
where book.id = book_genre.book_id and book_genre.genre_id = genre.id
group by genre
order by count desc;

--Show a list of publisher names and how many books they each have published
select publisher_name, count(title) as count
from publisher, book
where publisher.id = book.publisher_id
group by publisher_name
order by count desc;

--Which book has the highest average rating?
select title, avg(rating) as rating
from book, book_read
where book.id = book_read.book_id
group by title
order by rating desc limit 1;

--How many books have reader 'radiophobia' read in 2018?
select count(*) as count
from profile, book_read
where profile.id = book_read.profile_id
and profile_name = 'radiophobia'
and extract(year from book_read.date_finished) = 2018;

--Show a list of how many books reader 'radiophobia' have read each year.
select extract(year from book_read.date_finished) as year, count(*) as count
from profile, book_read
where profile.id = profile.id
and profile_name = 'radiophobia'
and date_finished is not null
group by year
order by year;

--Show a top 10 of highest rated books.
select title, avg(rating) as rating
from book, book_read
where book.id = book_read.book_id
and rating is not null
group by title
order by rating desc limit 10;

--What's the poorest rated book?
select title, avg(rating) as rating
from book, book_read
where book.id = book_read.book_id
group by title
order by rating asc limit 1;

--Is there any book, which hasn't been read?
select title, id
from book
where id not in (select book_id from book_read where status='read');

--Which reader has read the most books
select profile_name, count(*) as count
from profile, book_read
where profile.id = book_read.profile_id
and extract(year from book_read.date_finished) <= 2023 --or book_read.status = 'read'
group by profile_name
order by count desc limit 1;

--how how many pages each reader has read. Limit to top 10
select profile_name, sum(page_count) as total
from profile, book_read, book
where profile.id = book_read.profile_id
  and book_read.book_id = book_id
group by profile_name
order by total desc limit 10;

--What's the lowest number of days to read 'Oathbringer (The Stormlight Archive,  #3)'
select profile_name, min(date_finished - date_started) as days
from profile, book_read, book
where profile.id = book_read.profile_id
and book_read.book_id = book.id
and book.title = 'Oathbringer (The Stormlight Archive,  #3)'
and date_started is not null
and date_finished is not null
group by profile_name
order by days asc;                                                  ------------how to limit to min, because i get all

--How many pages does the book “City in the Sky” have?
select title, page_count
from book
where title = 'City in the Sky';

--How many books are published by “Faolan's Pen Publishing Inc.”? (‘ is escaped as ‘’)
select publisher_name, count(title) as publishions
from publisher, book
where publisher.id = book.publisher_id
and publisher.publisher_name = 'Faolan''s Pen Publishing Inc.'
group by publisher_name;

--Produce a list of books which shows title, avg_rating and ISBN
select title, rating, isbn
from book, book_read;

-- How many authors do not have middle names?
select count(*)
from author
where middle_name is null;

-- Produce a list of book-titles for which the title includes the word “City”
select title
from book
where title ilike '%City%';

--How many books from 2019 has an avg_rating in [3.8, 4.1]
select count(title) as count
from book, book_read
where year_published = 2019
and book_read.rating between 3.8 and 4.1;

-- Find the total number of books and the sum of their pages
select count(title) as number_of_books, sum(page_count) as total_number_of_pages
from book;

-- Find the maximum, minimum, and average page count
select max(page_count) as max, min(page_count) as min, avg(page_count) as avg
from book;
