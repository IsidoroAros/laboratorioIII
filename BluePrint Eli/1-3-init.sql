create database BluePrintRedesign
GO
Use BluePrintRedesign
GO
create table tiposClientes(
	ID int primary key identity(1,1),
	tipo varchar(50) unique
)
GO
create table Clientes(
	ID int primary key identity(1,1) not null,
	RazonSocial varchar(50) not null,
	Cuit varchar(20) not null,
	tipoCliente int foreign key references tiposClientes(ID) not null check(tipoCliente > 0),
	telefono varchar(16) null,
	mail varchar(50) not null,
	celular varchar(20) null
)
GO
create table Proyectos(
	ID char(5) primary key not null,
	descripcion varchar(200) null,
	cliente int foreign key references Clientes(ID) not null,
	inicio date not null,
	fin date null,
	costoAprox money not null check(costoAprox > 0),
	estado bit not null
)