Use BluePrint

-- 1) Por cada cliente listar razón social, cuit y nombre del tipo de cliente.

select 
RazonSocial, CUIT, TC.Nombre as TipoCliente 
from Clientes as Cli
JOIN TiposCliente as TC on Cli.ID = TC.ID


-- 2)
-- Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Sólo de aquellos
-- clientes que posean ciudad y país.

Select
Cl.RazonSocial, Cl.Cuit, Ciud.Nombre as Ciudad, Pais.Nombre as Pais -- Columnas solicitadas
From Clientes as Cl -- Al ser inner Join el FROM puede ser de cualquiera de las dos tablas
JOIN Ciudades as Ciud ON Cl.IDCiudad = Ciud.ID -- Join de Clientes con Ciudades
JOIN Paises as Pais on Ciud.ID = Pais.ID -- Join de Ciudades con Paises


-- 3)
-- Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellos 
-- clientes que no tengan ciudad relacionada.

Select
Cl.RazonSocial, Cl.Cuit, Ciud.Nombre, Ciud.ID as Ciudad, Pais.Nombre as Pais -- 
From Clientes as Cl -- 
LEFT JOIN Ciudades as Ciud ON Cl.IDCiudad = Ciud.ID -- 
LEFT JOIN Paises as Pais ON Ciud.IDPais = Pais.ID


-- 4)
-- Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del
-- país. Listar también los datos de aquellas ciudades y países que no tengan
-- clientes relacionados.

Select
Cl.RazonSocial, Cl.Cuit, Ciud.Nombre, Ciud.ID as Ciudad, Pais.Nombre as Pais -- 
From Clientes as Cl -- 
RIGHT JOIN Ciudades as Ciud ON Cl.IDCiudad = Ciud.ID -- 
RIGHT JOIN Paises as Pais ON Ciud.IDPais = Pais.ID


-- 5)
-- Listar los nombres de las ciudades que no tengan clientes asociados. Listar también el nombre del país al que 
-- pertenece la ciudad.

SELECT
Ciud.Nombre, Pais.Nombre FROM Clientes as Cli
Right JOIN Ciudades as Ciud ON Ciud.Id = Cli.IDCiudad
Right JOIN Paises as Pais ON Ciud.IDPais = Pais.ID
WHERE Cli.ID is null


-- 6)
-- Listar para cada proyecto el nombre del proyecto, el costo, la razón social del cliente, el 
--nombre del tipo de cliente y el nombre de la ciudad (si la tiene registrada) de aquellos clientes cuyo
-- tipo de cliente sea 'Extranjero' o 'Unicornio'.

SELECT
Pro.Nombre, Pro.CostoEstimado, Cli.RazonSocial, TC.Nombre as Cliente, Ciud.Nombre as Ciudad
From Proyectos as Pro
JOIN Clientes as Cli ON Cli.ID = Pro.IDCliente
JOIN TiposCliente as TC ON TC.ID = Cli.IDTipo
JOIN Ciudades as Ciud ON Ciud.ID = Cli.IDCiudad
WHERE TC.Nombre = 'Extranjero' OR TC.Nombre = 'Unicornio'


--7 Listar los nombre de los proyectos de aquellos clientes que sean de los países
--'Argentina' o 'Italia'.

SELECT Pro.Nombre, Ciud.Nombre From Proyectos as Pro -- Selecciono nombre proyecto y ciudad
JOIN Clientes as Cli ON Pro.IDCliente = Cli.ID -- Hago Join Clientes con proyectos
JOIN Ciudades as Ciud ON Ciud.ID = Cli.IDCiudad -- Hago Join de ciudades con cliente id ciudad
Join Paises as Pais ON Pais.ID = Ciud.IDPais -- Hago Join de ciudad.idPais con pais.id
WHERE Pais.Nombre = 'Argentina' OR Pais.Nombre = 'Italia'


--8 Listar para cada módulo el nombre del módulo, el costo estimado del módulo,
--el nombre del proyecto, la descripción del proyecto y el costo estimado del
--proyecto de todos aquellos proyectos que hayan finalizado.

Select Mod.Nombre as Nombre, Mod.CostoEstimado as Costo, Pro.Nombre as Proyecto, Pro.Descripcion as Descripcion
FROM Modulos as Mod
JOIN Proyectos as Pro ON Mod.IDProyecto = Pro.ID
WHERE Pro.FechaFin < GETDATE()


--9 Listar los nombres de los módulos y el nombre del proyecto de aquellos
--módulos cuyo tiempo estimado de realización sea de más de 100 horas.

Select Mod.Nombre as Modulo, Pro.Nombre as Proyecto
FROM Modulos as Mod
JOIN Proyectos as Pro ON Mod.IDProyecto = Pro.ID
WHERE Mod.TiempoEstimado > 100


--10 Listar nombres de módulos, nombre del proyecto, descripción y tiempo
--estimado de aquellos módulos cuya fecha estimada de fin sea mayor a la
--fecha real de fin y el costo estimado del proyecto sea mayor a cien mil.

Select Mod.Nombre as NomMod, Pro.Nombre as ProNom, Pro.Descripcion as Descr, Mod.TiempoEstimado as TiempoEst
From Modulos as Mod 
JOIN Proyectos as Pro ON Mod.IDProyecto = Pro.ID
Where Mod.FechaEstimadaFin > Mod.FechaFin and Pro.CostoEstimado > 100000


--11 Listar nombre de proyectos, sin repetir, que registren módulos que hayan
--finalizado antes que el tiempo estimado.

SELECT Distinct Pro.Nombre FROM Proyectos as Pro 
JOIN Modulos as Mod ON Mod.IDProyecto = Pro.ID
WHERE Mod.FechaFin < Mod.FechaEstimadaFin 


--12 Listar nombre de ciudades, sin repetir, que no registren clientes pero sí
--colaboradores.

SELECT Distinct Ciud.Nombre from Ciudades as Ciud -- Selecciono sin repetir de ciudades
JOIN Clientes as Cli ON Cli.IDCiudad is null -- Donde los colaboradores tienen null
JOIN Colaboradores as Colab ON Colab.IDCiudad = Ciud.ID -- Que coincidan el id ciudad con el de idCiud de Colab


--13 Listar el nombre del proyecto y nombre de módulos de aquellos módulos que
--contengan la palabra 'login' en su nombre o descripción.

SELECT Pro.Nombre as Proyecto, Mod.Nombre as Modulo, Mod.Descripcion as Descripcion 
FROM Proyectos as Pro 
JOIN Modulos as Mod ON Mod.IDProyecto = Pro.ID
WHERE Mod.Nombre like '%login%' OR Mod.Descripcion like '%login%' 


--14 Listar el nombre del proyecto y el nombre y apellido de todos los
--colaboradores que hayan realizado algún tipo de tarea cuyo nombre contenga
--'Programación' o 'Testing'. Ordenarlo por nombre de proyecto de manera
--ascendente.

SELECT Pro.Nombre as Proyecto, Colab.Nombre as Nombre, Colab.Apellido as Apellido
FROM Proyectos as PRO
JOIN Modulos as Mod ON Mod.IDProyecto = Pro.ID
JOIN Tareas as TA ON TA.IDModulo = Mod.ID
JOIN TiposTarea as TT ON TA.IDTipo = TT.ID
JOIN Colaboraciones as Ciones ON TA.ID = Ciones.IDTarea
JOIN Colaboradores as Colab ON Ciones.IDColaborador = Colab.ID
WHERE TT.Nombre like '%Programacion%' OR TT.Nombre like '%Testing%'
ORDER BY Pro.Nombre ASC


--15 Listar nombre y apellido del colaborador, nombre del módulo, nombre del tipo
--de tarea, precio hora de la colaboración y precio hora base de aquellos
--colaboradores que hayan cobrado su valor hora de colaboración más del 50%
--del valor hora base.

SELECT 
Colab.Apellido as ColabApe, 
Colab.Nombre as ColabNombre, 
Mod.Nombre as ModNombre, 
TT.Nombre as TipoTareaNombre, 
TT.PrecioHoraBase as HoraBase, 
Colaciones.PrecioHora as PrecioHora
From Colaboradores as Colab
JOIN Colaboraciones as Colaciones ON Colab.ID = Colaciones.IDColaborador
JOIN Tareas as Tar ON Colaciones.IDTarea = Tar.ID
JOIN TiposTarea as TT ON Tar.IDTipo = TT.ID
JOIN Modulos as Mod ON Tar.IDModulo = Mod.ID
WHERE Colaciones.PrecioHora > (TT.PrecioHoraBase * 1.5)


--16 Listar nombres y apellidos de las tres colaboraciones de colaboradores
--externos que más hayan demorado en realizar alguna tarea cuyo nombre de
--tipo de tarea contenga 'Testing'.
SELECT TOP 3 Colab.Nombre as Nombre, Colab.Apellido as Apellido, Colaciones.Tiempo as Tiempo
FROM Colaboradores as Colab
JOIN Colaboraciones as Colaciones ON Colab.ID = Colaciones.IDColaborador
JOIN Tareas as Tar ON Colaciones.IDTarea = Tar.ID
JOIN TiposTarea as TT ON Tar.IDTipo = TT.ID
WHERE TT.Nombre like '%Testing%'
ORDER BY Tiempo DESC
-- Revisar, no da el data set correcto

--17 Listar apellido, nombre y mail de los colaboradores argentinos que sean
--internos y cuyo mail no contenga '.com'.
SELECT Colab.Apellido as Apellido, Colab.Nombre as Nombre, Colab.EMail as Mail
FROM Colaboradores as Colab
JOIN Ciudades as Ciud ON Colab.IDCiudad = Ciud.ID
JOIN Paises as Pais ON Ciud.IDPais = Pais.ID
WHERE Pais.Nombre = 'Argentina' AND Colab.Tipo = 'I'
-- Revisar


--18 Listar nombre del proyecto, nombre del módulo y tipo de tarea de aquellas
--tareas realizadas por colaboradores externos.

--19 Listar nombre de proyectos que no hayan registrado tareas.

--20 Listar apellidos y nombres, sin repeticiones, de aquellos colaboradores que
--hayan trabajado en algún proyecto que aún no haya finalizado