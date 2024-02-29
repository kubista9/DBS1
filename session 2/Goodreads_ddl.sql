DROP SCHEMA IF EXISTS goodreads CASCADE;
CREATE SCHEMA goodreads;

SET SCHEMA 'goodreads';

create table profile(
    id varchar(50) primary key,
    first_name varchar(50),
    last_name varchar(50),
    profile_name varchar(50)
);

create table book_read(

);

CREATE TABLE binding_type (
    type VARCHAR(50) PRIMARY KEY
);

CREATE TABLE book_shelf (
    shelf_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE publisher (
    publisher_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE author (
    author_id SMALLINT PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(250),
    last_name VARCHAR(50)
);

CREATE TABLE genre (
    i
    genre VARCHAR(50) PRIMARY KEY
);

CREATE TABLE book (
    book_id VARCHAR(25) PRIMARY KEY,
    isbn VARCHAR(15),
    title VARCHAR(200),
    my_rating SMALLINT,
    avg_rating DECIMAL(3,2),
    page_count SMALLINT,
    year_published SMALLINT,
    date_finished date,
    binding_type VARCHAR(50) REFERENCES binding_type(type),
    publisher VARCHAR(50) REFERENCES publisher(publisher_name),
    shelf VARCHAR(50) REFERENCES book_shelf(shelf_name),
    author_id SMALLINT REFERENCES author(author_id)
);

CREATE TABLE book_genre (
    genre VARCHAR(50),
    book_id VARCHAR(25),
    PRIMARY KEY (genre, book_id),
    FOREIGN KEY (genre) REFERENCES genre(genre),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

CREATE TABLE co_authors(
    book_id VARCHAR(25) REFERENCES book(book_id),
    author_id SMALLINt REFERENCES author(author_id),
    PRIMARY KEY (book_id, author_id)
);