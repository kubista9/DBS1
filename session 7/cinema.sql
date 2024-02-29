drop schema if exists simple_cinema cascade;
create schema simple_cinema;
set schema 'simple_cinema';

create table movie (
    movie_id integer primary key check ( movie_id between 0 and 1000000),
    title varchar(20),
    description varchar(500)
);

create table cinemaHall (
    letter char(1),
    city varchar(50) primary key
);

create table showing(
    letter char(1),
    city varchar(50),
    movie_id integer,
    timeDate date not null,
    primary key(letter, city, movie_id),
    foreign key(movie_id) references movie(movie_id),
    foreign key(city) references cinemaHall(city)
);

create table cinema(
  city varchar(50) primary key
);




