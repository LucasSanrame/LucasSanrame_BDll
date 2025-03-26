drop database if exists imdb;
create database if not exists imdb;
use imdb;

CREATE TABLE film (
    film_id int,
    titulo varchar(10),
    descripcion varchar(50),
    anio_estreno int,
    
    constraint film_id_pk primary key (film_id)
);

CREATE TABLE actor (
    actor_id int,
    first_name varchar(10),
    last_name varchar(10),
    
    constraint actor_id_pk primary key (actor_id)
);

CREATE TABLE film_actor (
    actor_id int,
    film_id int,
    af_id int,
    
    constraint af_id_pk primary key (af_id),
    constraint actor_id_fk FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
    constraint film_id_fk FOREIGN KEY (film_id) REFERENCES film(film_id)
);

alter table film
add column last_update date;
alter table film_actor
add column last_update date;
alter table film_actor
add index FK_actor (actor_id);
alter table film_actor
add constraint FK_actor foreign key (actor_id) references actor (actor_id);
alter table film_actor
add index FK_film (film_id);
alter table film_actor
add constraint FK_film foreign key (film_id)references film (film_id);