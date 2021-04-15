create database turnosMedicos
GO
use turnosMedicos
GO
create table especialidades(
	id tinyint primary key not null identity(1,1),
	descripcion varchar(35) not null unique,
	estado bit not null
)
GO
create table pacientes(
	id int primary key not null,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	nacimiento smalldatetime not null check(nacimiento < getdate())
)
GO
create table direcciones(
	zipCode smallint not null primary key,
	localidad varchar(40)
)
GO
create table sedes(
	id tinyint not null primary key identity(1,1),
	nombreHospital varchar(40) not null,
	zipCode smallint not null foreign key references direcciones(zipCode)
)
GO
create table turnos(
	id int primary key not null,
	idPaciente int foreign key references pacientes(id) not null,
	idEspecialidad tinyint foreign key references especialidades(id),
	fecha smalldatetime not null check(fecha > getdate()),
	idSede tinyint not null foreign key references sedes(id)
)