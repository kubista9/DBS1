-- 2 A

drop schema if exists blood_bank cascade;
create schema blood_bank;
set schema 'blood_bank';

create domain blood_type as varchar(3) not null check (value in('O-','O+','B-','B+','A-','A+','AB-','AB+'));
create domain amount as integer not null check (value between 300 and 600);
create domain blood_percent as numeric not null check (value between 8.0 and 11.0);
create domain position as varchar not null check (value in('nurse','bioanalytic','intern'));
create domain cpr as varchar(10) not null;

create table staff (
  initials char(2) primary key,
  cpr cpr,
  name varchar,
  house_number integer,
  street varchar,
  city varchar,
  postal_code decimal,
  phone decimal,
  hire_date date,
  position "position"
);

create table managed_by (
  collected_by_nurse_id varchar,
  donation_id varchar primary key,
  verified_by_nurse_initials char(2),
  foreign key (collected_by_nurse_id) references staff(initials),
  foreign key (verified_by_nurse_initials) references staff(initials)
);

create table donor(
  cpr cpr primary key,
  name varchar,
  house_number decimal(2),
  street varchar(50),
  city varchar(50),
  postal_code decimal(7),
  phone decimal(11),
  blood_type blood_type,
  last_reminder date
);

create table blood_donations(
  id serial,
  date date,
  amount amount,
  blood_percent blood_percent,
  donor_id varchar(10) not null,
  foreign key (donor_id) references donor(cpr)
);

create table next_appointment(
  date date,
  time time,
  donor_cpr cpr,
  primary key (date, donor_cpr),
  foreign key (donor_cpr) references donor(cpr)
);

-- 2 B

INSERT INTO donor (cpr, name, house_number, street, city, postal_code, phone, blood_type, last_reminder)
Values (1234567890, 'August', '2', 'Wall street', 'Horsens', 8700, 123456789101,'AB-','2023-30-01'),
(0865345892, 'Alexandru', 98, 'Stefanikova', 'Bucharest', 78023, 09876578924, 'O-','2023-29-04' );

INSERT INTO blood_donations (id, "date", amount, blood_percent, donor_id)
Values (1, '2001-30-10.', 400., 9.0, 89340350),
(2, '2023-17-08', 500, 10.8, 03850835);

INSERT INTO staff (initials, cpr, name, house_number, street, city, postal_code, phone, hire_date, "position")
Values ('DM',08035, 'Denitsa', 9, 'Bondergsade','Sofia',0350, 08209382, '2018-30-12', 'nurse'),
('OK',0942092, 'Oskar', 92, 'Amaliensgade', 'Warsawa', 9842, 0820101, '2019-23-04', 'bioanalytic');

INSERT INTO managed_by (collected_by_nurse_id, donation_id, verified_by_nurse_initials)
Values ('DM',1, 'OK'),
('OK',2, 'DK');