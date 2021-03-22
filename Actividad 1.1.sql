create database facultad
GO
use facultad
GO
create table carreras(
	id char(4) not null primary key,
	creacion datetime not null check (creacion <= GETDATE()),
	nombre varchar(40) not null,
	mail varchar(30) not null unique,
	nivel varchar(30) not null check (nivel = 'Diplomatura' OR nivel = 'Pregrado' OR nivel = 'Grado' or nivel = 'Postgrado')
)
GO
create table materias(
	id smallint not null identity(1,1),
	idCarrera char(4) not null foreign key references carreras(id),
	nombre varchar(30) not null,
	cargaHoraria tinyint not null
)
GO
create table alumnos(
	legajo int not null primary key identity(1000,1),
	idCarrera char(4) not null foreign key references carreras(id),
	nombre varchar(20) not null,
	apellido varchar(20) not null,
	nacimiento datetime not null check (nacimiento <= GETDATE()),
	email varchar(30) not null unique,
	telefono int null
)