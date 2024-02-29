--Exercise 3 - Diagram to Data Definition Language
create schema airportsystem;
set schema 'airportsystem';

create domain text varchar(50);

create table airport(
    code char(3) primary key,
    name text not null,
    country text not null,
    city text not null
);

insert into airport(code, name, country, city)
values ('LTN', 'Lutton','U.K','London'),
('VIE','Vienna airport','Austria','Vienna');

create table airplane(
    registration_no varchar(7) primary key,
    make text not null,
    model text not null,
    manufacture_date date not null check(manufacture_date < now()),
    no_of_seats integer not null check(no_of_seats between 1 and 999),
    engine_type text not null check (engine_type in('Jet','jet','Propeller','propeller'))
);

insert into airplane(registration_no, make, model, manufacture_date, no_of_seats, engine_type)
   values ('BE563','Airbus','Big one','05-07-2016',300,'Jet' ),
          ('LE331', 'Boeing','774','10-10-2010',600, 'Propeller');

create table passenger(
  passport_no varchar(9) primary key,
  name text not null,
  contact_info varchar(200)
);

insert into passenger(passport_no, name, contact_info)
values ('BE9308577','Jakub Kuka', 'phone: +45995005'),
       ('QE6548987','Jens Jenses','jeje@viauc.dk');

create table flight(
    flight_no varchar(6),
    departure_time timestamp,
    arrival_time timestamp check ( arrival_time > flight.departure_time),
    departure_airport text not null,
    arrival_airport text not null,
    airplane_registration_number varchar(7) not null,
    primary key (flight_no, departure_time),
    foreign key (departure_airport) references airport(code),
    foreign key (arrival_airport) references  airport(code),
    foreign key (airplane_registration_number) references airplane(registration_no)
);

insert into flight(flight_no, departure_time, arrival_time, departure_airport, arrival_airport, airplane_registration_number)
values ('QWE445','2004-10-19 10:23:54', '2004-10-19 13:30:54','LTN','VIE','BE563'),
       ('PLK123','2015-10-10 12:45:00', '2015-10-10 15:45:00','VIE','LTN', 'LE331');

create table passenger_flight(
    flight_no varchar(6),
    departure_time timestamp,
    passport_no varchar(9),
    price decimal check ( price between 0.00 and 9999.99),
    primary key(flight_no, departure_time, passport_no),
    foreign key (flight_no, departure_time) references flight(flight_no, departure_time),
    foreign key (passport_no) references passenger(passport_no)
);

insert into passenger_flight(flight_no, departure_time, passport_no, price)
values ('QWE445', '2004-10-19 10:23:54','BE9308577',67.94),
       ('PLK123','2015-10-10 12:45:00','QE6548987', 32.94);

create table baggage(
    id varchar primary key,
    weight integer check ( weight between 1 and 35),
    flight_no varchar(6) not null,
    departure_time timestamp not null,
    passport_no varchar(9) not null,
    foreign key (flight_no, departure_time) references flight(flight_no, departure_time),
    foreign key (passport_no) references passenger(passport_no)
);