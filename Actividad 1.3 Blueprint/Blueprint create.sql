/*


Realizar un modelo lógico en papel en el cual se identifiquen todas las entidades y cómo se relacionan entre sí.
Realizar un script en lenguaje TSQL que genere la siguiente base de datos con sus respectivas tablas y restricciones.



Blueprint será un software dedicado a la gestión de proyectos a medida de todo tipo. En él, 
los administradores de proyectos serán capaces de poder registrar los proyectos, clientes, módulos, tareas, 
colaboradores y demás elementos necesarios para la gestión de proyectos.

En la primera etapa del desarrollo, el sistema requiere una base de datos en SQL Server Express que permita registrar 
la información de los clientes y los proyectos. 

El diseño de la base de datos debe garantizar que:
Un cliente pueda tener un código autonumérico que lo identifique.
Un cliente deba tener una razón social y un CUIT. Este último no puede repetirse.
Un cliente deba registrar un tipo de cliente y que el gestor de proyecto pueda definir los distintos tipos de clientes: "Estatal", 
	"Multinacional", "Educativo privado", "Educativo público", "Sin fines de lucro", etc.
Un cliente pueda registrar un mail, teléfono y celular de contacto.
Un proyecto registre un nombre y pueda opcionalmente registrar una descripción larga.
Un proyecto registre un ID que lo identifique.
Un proyecto debe tener un cliente.
Un cliente puede tener muchos proyectos.
Dos o más clientes no pueden tener el mismo proyecto.
Un proyecto debe contener una fecha de inicio y una fecha de fin. Aunque esta última debe poder suministrarse tiempo después de haber registrado el proyecto.
Un proyecto debe registrar un costo estimado.
Un proyecto debe contener una marca que defina si se encuentra vigente o cancelado.

A continuación se detalla un extracto de una planilla de cálculo con un ejemplo de la información que se registraría de cada elemento.

*/

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