drop schema if exists company cascade;
create schema company;
set schema 'company';

create domain gender as char(1) not null check (value in('M','F','O'));
create domain dob as date not null check (value >= '1920-01-01');
create domain salary as decimal(10,2) not null check (value >= 4000.00 and value < 99999999.99);
create domain relatioships as varchar(10) not null check (value in('daughter','son','spouse'));
create domain ssn as varchar(10) not null;
create domain hours_worked as integer check (value < 1000);


create table department(
  d_name varchar(20) unique,
  d_no integer primary key ,
  mgr_ssn ssn,
  mgr_start_date date,
  foreign key (d_no) references department(d_no)
);

create table project(
    p_name varchar(20),
    p_no integer primary key,
    d_no integer,
    foreign key (d_no) references department(d_no)
);

create table employee(
    f_name varchar(30),
    m_init char(1),
    l_name varchar(30),
    ssn ssn primary key,
    dob date,
    gender gender,
    address varchar(50),
    salary bigint check (salary between 4000.00 and 99999999.99),
    superssn ssn,
    d_no integer,
    foreign key (d_no) references department(d_no)
);

create table dependent(
    name         varchar(50),
    gender       gender,
    dob          dob,
    relationship relatioships,
    e_ssn ssn primary key,
    foreign key (e_ssn) references employee(ssn) on delete cascade
);

create table works_on(
  hours hours_worked,
  ssn ssn,
  number integer,
  fine numeric(2, 0) CHECK (fine >= 10 AND fine <= 99),
  finePaid boolean
);
