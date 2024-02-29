drop schema if exists library cascade;
create schema library;
set schema 'library';

create domain cpr as char(10) not null;
create domain email as varchar(100) check (value in('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'));
create domain name as varchar(100) not null;
create domain isbn as char(13) not null;

create table loaner (
    cpr cpr primary key ,
    name name,
    email email,
    address varchar(50)
    );

create table genre(
    name name primary key
);

create table publisher(
    publisher_id integer unique primary key,
    name name
);

create table bookDescription (
    isbn isbn primary key,
    title varchar(100),
    yearOfPublishing date,
    publisher_id integer unique,
    foreign key (publisher_id) references publisher(publisher_id)
);


create table bookDescription_Genre(
  isbn isbn,
  name name,
  primary key (isbn, name),
  foreign key (isbn) references bookDescription(isbn),
  foreign key (name) references genre(name)
);

create table book (
    rfidCode integer primary key,
    isbn isbn,
    foreign key (isbn) references bookDescription(isbn)
);

create table hasBorrowed(
    cpr cpr,
    rfidCode integer,
    dateFrom date,
    dateDue date,
    fine numeric(2, 0) CHECK (fine >= 10 AND fine <= 99),
    primary key (rfidCode, dateFrom),
    foreign key (cpr) references loaner(cpr),
    foreign key (rfidCode) references book(rfidCode)
);

create table bookDescription (
    isbn isbn primary key,
    title varchar(100),
    yearOfPublishing date,
    publisher_id integer unique,
    foreign key (publisher_id) references publisher(publisher_id)
);

create table book (
    rfidCode integer primary key,
    isbn isbn,
    foreign key (isbn) references bookDescription(isbn)
);

create table author (
    author_id integer primary key not null,
    name name,
    bio varchar(500)
);

create table bookDescription_Author(
    isbn isbn primary key,
    author_id integer not null,
    foreign key (isbn) references bookDescription(isbn),
    foreign key (author_id) references author(author_id)
);

