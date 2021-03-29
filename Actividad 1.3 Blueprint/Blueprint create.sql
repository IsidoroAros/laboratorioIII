Create database Blueprint
GO
use Blueprint
GO
Create table Clientes(
	ID int primary key not null identity(1,1),
	Cuit char(13) not null unique
)
GO
Create table Clientes_contacto(
	ID int primary key foreign key references Clientes(ID) not null,
	mail varchar(30) not null,
	telefono varchar(20) null,
	celular varchar(25) null
)
GO
Create table Clientes_tipos(
	ID int primary key foreign key references Clientes_contacto(ID) not null,
	tipo varchar(50) not null
)
GO 
Create table Proyectos(
	ID char(4) primary key not null,
	Cliente int foreign key references Clientes(ID) not null 
)
GO
Create table Proyectos_main_info(
	ID char(4) primary key foreign key references Proyectos(ID),
	Nombre varchar(30) not null,
	Descripcion text not null
)
GO
Create table Proyectos_datos(
	ID char(4) primary key foreign key references Proyectos_main_info(ID),
	Inicio smalldatetime not null,
	Fin smalldatetime null,
	Costo_estimado money not null check(Costo_estimado > 0),
	Estado bit not null
)