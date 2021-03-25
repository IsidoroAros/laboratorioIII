create database libreria
GO
use libreria
GO
create table articulos(

	codArt char(6) not null primary key,
	descripcion varchar(30) not null,
	marca varchar(12) null,
	tipoArt varchar(20) not null

)
GO
create table precios_x_art(
	codArt char(6) not null primary key foreign key references articulos(codArt),
	pCompra smallmoney not null check (pCompra > 0 ),
	pVenta smallmoney not null check (pVenta > 0 ),
	ganancia smallmoney null check (ganancia > 0 )
)
GO
create table stock_x_art(

	codArt char(6) not null primary key foreign key references articulos(codArt),
	stockAct smallInt not null check ( stockAct >= 0 ),
	stockMin smallInt not null check ( stockMin >= 0 ),
	overStock smallInt not null check ( overStock >= 0 ),
	estado bit not null
)
GO
create table vendedores(

	dni int not null primary key,
	legajo tinyint not null unique identity(1,1),
	apeNom char(50) not null,
	nacimiento smalldatetime not null,
	ingreso smalldatetime not null

)
GO
create table contacto_x_vendedor(

	dni int primary key foreign key references vendedores(dni),
	direccion varchar(30) not null,
	zipCode smallint not null,
	localidad varchar(20) not null,
	provincia varchar(20) not null,
	telefono int null

)
GO
create table facturacion_x_vendedor(
	
	dni int primary key foreign key references vendedores(dni),
	sueldo smallmoney not null,
	ventMes tinyint not null,
	factMes smallmoney not null

)
GO
create table ventas(

	factura int not null primary key identity(1,1),
	fechaV smalldatetime not null,
	cliente varchar(30) not null,
	vendedor tinyint not null foreign key references vendedores(legajo),
	formaPago char(1) not null check (formaPago = 'T' or formaPago = 'E'),
	importe smallmoney not null

)
GO
create table articulo_x_venta(
	venta int not null primary key foreign key references ventas(factura),
	codArt char(6) not null foreign key references articulos(codArt),
	/*Descripcion ya está en los articulos, no repetir*/
	/*Marca ya está en los articulos, no repetir*/
	/*Precio unitario ya está en los precios_x_art, no repetir*/
	cantidad int not null check (cantidad > 0)
)
