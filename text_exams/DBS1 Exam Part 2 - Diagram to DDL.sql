create schema racetimer;
set schema 'racetimer';

create domain password as text not null check(length(value) between 8 and 64 and value similar to '[A-Za-z0-9._%+-]{8,64}@%');
create domain text as varchar(50);

create table profile(
  email text primary key,
  password password not null,
  first_name text not null,
  last_name text not null,
  phone_number char(8)
);

create table race(
  id text primary key,
  name text not null,
  date date not null,
  location text not null,
  event_owner text
);

create table ticket(
  id text unique primary key,
  profile_email text not null,
  race_id text not null,
  heat_number integer check ( heat_number between 1 and 25),
  date_bought date not null,
  wants_racetime_on_sms boolean,
  runner_number integer check ( runner_number between 0 and 99999),
  foreign key (profile_email) references profile(email)
);

create table race_result(
  race_time interval,
  profile_email text,
  race_id text,
  primary key (profile_email, race_id),
  foreign key (profile_email) references profile(email),
  foreign key (race_id) references race(id)
);

create table price(
  race_id text not null,
  date_from date check (price.date_from > date_to),
  date_to date check (price.date_to< date_from),
  price decimal check ( price between 0.00 and 10000.00),
  primary key (race_id, date_from),
  foreign key (race_id) references race(id)
);

