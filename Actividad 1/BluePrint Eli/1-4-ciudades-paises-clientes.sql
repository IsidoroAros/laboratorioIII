use BluePrintRedesign
GO
create table Paises(
	ID int primary key not null,
	Nombre varchar(50) not null
)
GO
create table Ciudades(
	ID int primary key not null,
	Nombre varchar(60) not null,
	idPais int foreign key references Paises(ID) not null
)
GO
alter table Clientes
add idCiudad int null foreign key references Ciudades(ID)