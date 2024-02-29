drop schema if exists codelabs cascade;
create schema codelabs;
set schema 'codelabs';

create domain username varchar(30) not null;
create domain id integer;
create domain title varchar(50);
create domain url varchar(200);

create table "user"(
    username username primary key
);

create table category (
    id id primary key,
    title title,
    background_color varchar(20),
    owner username,
    foreign key (owner) references "user"(username)
);

create table guide (
    id id primary key ,
    title title,
    is_published boolean,
    description varchar(500),
    include_steps boolean,
    category_id id,
    owner username,
    foreign key (category_id) references category(id),
    foreign key (owner) references "user"(username)
);

create table slide (
    id id primary key,
    title title,
    context varchar(50),
    index integer,
    guide_id id,
    foreign key (guide_id) references guide(id)
);

create table image(
    url url primary key,
    title title,
    owner username,
    foreign key (owner) references "user"(username)
);

create table slide_image(
    slide_id id primary key,
    url url,
    foreign key (slide_id) references slide(id),
    foreign key (url) references image(url)
);

create table video_link(
    id id primary key,
    title title,
    link varchar(200),
    description varchar(500),
    category_id id,
    owner username,
    foreign key (category_id) references category(id),
    foreign key (owner) references "user"(username)
);

create table alt_user(
    alt_username username,
    username username,
    primary key (alt_username, username),
    foreign key (username) references "user"(username)
);

create table collaborates(
    guide_id id primary key,
    username username,
    foreign key (guide_id) references guide(id),
    foreign key (username) references "user"(username)
);