use BluePrintRedesign
GO
create table Modulos(
	ID int not null identity(1,1) primary key,
	Proyecto char(5) not null foreign key references Proyectos(ID),
	Nombre varchar(50) not null,
	Descripcion varchar(200) null,
	TiempoEstimado smallint not null,
	CostoPesos money not null,
	FechaFinEst date not null,
	FechaInicio date not null,
	FechaFin date null 
)
GO
create table Colaboradores(
	Nombre varchar(50) not null,
	Apellido varchar(50) not null,
	Mail varchar(100),
	Celular varchar(20),
	Nacimiento date not null,
	IDCiudad int null foreign key references Ciudades(ID),
	Domicilio varchar(100) null,
	FechaInicio date not null,
	FechaFin date null,
	tipoColab char not null check(tipoColab = 'E' OR tipoColab = 'I'),
	/*
		La linea de abajo se ocupa de agregar una constraint que nos obliga a que haya mail, celular o ambas
	*/
	CONSTRAINT CHK_EmailCelular CHECK(Mail IS NOT NULL OR Celular IS NOT NULL)
)

/*
--------------------------------------------
FALTAN AGREGAR CONSTRAINTS DE FECHAS
--------------------------------------------
*/