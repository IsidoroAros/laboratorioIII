USE BluePrint
GO
--1 La cantidad de colaboradores
  SELECT count (*) as CantidadColaboradores from Colaboradores

--2 La cantidad de colaboradores nacidos entre 1990 y 2000.
  SELECT COUNT(FechaNacimiento) NacidosEntre FROM COLABORADORES
  WHERE FechaNacimiento BETWEEN '1990' AND '2000'

--3 El promedio de precio hora base de los tipos de tareas
  SELECT AVG(PrecioHoraBase) as PromedioHoraBase FROM TiposTarea

--4 El promedio de costo de los proyectos iniciados en el año 2019.
  SELECT AVG(CostoEstimado) as PromCosto2019 FROM Proyectos
  WHERE Year(FechaInicio) = '2019'

--5 El costo más alto entre los proyectos de clientes de tipo 'Unicornio'
  SELECT MAX(CostoEstimado) MaximoCostoUnicornio FROM Proyectos P
  JOIN Clientes C ON P.IDCliente = C.ID
  JOIN TiposCliente TC ON TC.ID = C.IDTipo
  WHERE TC.Nombre like 'Unicornio'
  GROUP BY CostoEstimado ORDER BY CostoEstimado desc

--6 El costo más bajo entre los proyectos de clientes del país 'Argentina'
  SELECT MIN(CostoEstimado) MinimoCostoArgentina FROM Proyectos P
  JOIN Clientes C ON P.IDCliente = C.ID
  JOIN Ciudades Ciud ON C.IDCiudad = Ciud.ID
  JOIN Paises Pais ON Ciud.IDPais = Pais.ID
  WHERE Pais.Nombre = 'Argentina'

 --SELECT Pro.CostoEstimado FROM Proyectos Pro
 --JOIN Clientes Cli ON Pro.IDCliente = Cli.ID
 --JOIN Ciudades Ciud ON Cli.IDCiudad = Ciud.ID
 --JOIN Paises Pais ON Ciud.IDPais = Pais.ID
 --WHERE Pais.Nombre like 'Argentina' ORDER BY Pro.CostoEstimado desc

--7 La suma total de los costos estimados entre todos los proyectos.
  SELECT SUM(CostoEstimado) SumaTotalProyectos from Proyectos

--8 Por cada ciudad, listar el nombre de la ciudad y la cantidad de clientes.
  SELECT Ciud.Nombre Ciudad, count(*) Clientes From Ciudades Ciud
  JOIN Clientes Cli ON Ciud.ID = Cli.IDCiudad
  GROUP BY Ciud.Nombre


--9 Por cada país, listar el nombre del país y la cantidad de clientes.
  SELECT Pais.Nombre Pais, count(*) Clientes From Paises Pais
  JOIN Ciudades Ciud ON Pais.ID = Ciud.IDPais
  JOIN Clientes Cli ON Ciud.ID = Cli.IDCiudad
  GROUP BY Pais.Nombre

--10 Por cada tipo de tarea, la cantidad de colaboraciones registradas. Indicar el tipo de tarea y la cantidad calculada.
  SELECT TT.Nombre Tarea, count(*) Colaboraciones FROM TiposTarea TT
  JOIN Tareas Ta ON ta.IDTipo = TT.ID
  JOIN Colaboraciones Col ON Col.IDTarea = Ta.ID
  Group By TT.Nombre

--11 Por cada tipo de tarea, la cantidad de colaboradores distintos que la hayan realizado. Indicar el tipo de tarea y la cantidad calculada.
  SELECT TT.Nombre Tarea, COUNT(Distinct Colab.ID) Colaboradores from TiposTarea TT 
  JOIN Tareas Ta ON ta.IDTipo = TT.ID
  JOIN Colaboraciones Col ON Col.IDTarea = ta.ID
  JOIN Colaboradores Colab ON Col.IDColaborador = Colab.ID
  GROUP BY tt.Nombre

--12 Por cada módulo, la cantidad total de horas trabajadas. Indicar el ID, nombre del módulo y la cantidad 
--totalizada. Mostrar los módulos sin horas registradas con 0.
  select Mod.ID, Mod.Nombre as Modulo, isnull(SUM(Col.Tiempo), 0) as Horas 
  from Modulos as Mod
  left join Tareas as Tar on Tar.IDModulo = Mod.ID
  left join Colaboraciones as Col on Col.IDTarea = Tar.ID
  GROUP BY Mod.ID, Mod.Nombre

--13 Por cada módulo y tipo de tarea, el promedio de horas trabajadas. 
--Indicar el ID y nombre del módulo, el nombre del tipo de tarea y el total calculado.
  Select Mod.ID idModulo, Mod.Nombre Modulo, TT.Nombre TipoTarea, AVG(Col.Tiempo) PromedioHoras 
  From Modulos Mod
  JOIN Tareas Tar ON Tar.IDModulo = Mod.ID
  JOIN TiposTarea TT ON Tar.IDTipo = TT.Id
  JOIN Colaboraciones Col ON Col.IDTarea = Tar.ID
  Group by Mod.ID, Mod.Nombre, TT.Nombre

--14 Por cada módulo, indicar su ID, apellido y nombre del colaborador 
--y total que se le debe abonar en concepto de colaboraciones realizadas en dicho módulo.
 SELECT Modulos.ID ID, Modulos.Nombre, CB.Nombre, CB.Apellido, SUM(CC.PrecioHora * CC.Tiempo) Precio 
 FROM Modulos Modulos
 JOIN Tareas Tar ON Tar.IDModulo = Modulos.ID
 JOIN Colaboraciones CC ON CC.IDTarea = Tar.ID
 JOIN Colaboradores CB ON CC.IDColaborador = CB.ID
 Group BY Modulos.iD, Modulos.Nombre, CB.Nombre, CB.Apellido

--15 Por cada proyecto indicar el nombre del proyecto y la cantidad de horas registradas 
--en concepto de colaboraciones y el total que debe abonar en concepto de colaboraciones.
  SELECT Pro.Nombre Proyecto, SUM(Col.Tiempo) Horas, SUM(Col.Tiempo * Col.PrecioHora) Honorarios
  FROM Proyectos Pro
  JOIN Modulos Modu ON Modu.IDProyecto = Pro.ID
  JOIN Tareas Tar ON Tar.IDModulo = Modu.ID
  JOIN Colaboraciones Col ON Col.IDTarea = Tar.ID
  Group BY Pro.Nombre

--16 Listar los nombres de los proyectos que hayan registrado menos de cinco colaboradores 
--distintos y más de 100 horas total de trabajo.
  SELECT Pro.Nombre Nombre FROM Proyectos Pro
  JOIN Modulos Modu ON Modu.IDProyecto = Pro.ID
  JOIN Tareas Tar ON Tar.IDModulo = Modu.ID
  JOIN Colaboraciones Col ON Col.IDTarea = Tar.ID 
  Group By Pro.Nombre
  Having Count(Col.IDColaborador) < 5 and SUM(Col.Tiempo) > 100

--17 Listar los nombres de los proyectos que hayan comenzado en el año 2020 que hayan registrado 
--más de tres módulos.
  SELECT Pro.Nombre Nombre FROM Proyectos Pro
  JOIN Modulos Modu ON Modu.IDProyecto = Pro.ID
  Where YEAR(Modu.FechaInicio) = '2020'
  Group By Pro.Nombre
  Having Count(Modu.ID) > 3

--18 Listar para cada colaborador externo, el apellido y nombres y el tiempo máximo 
--de horas que ha trabajo en una colaboración. 
 SELECT Col.Nombre Nombre, Col.Apellido Apellido, MAX(Cb.Tiempo) Tiempo 
 ROM Colaboradores Col
 JOIN Colaboraciones CB ON CB.IDColaborador = Col.ID
 Where Col.Tipo like 'E'
 GROUP BY Col.Nombre, Col.Apellido
 Order By Col.Nombre asc

--19 Listar para cada colaborador interno, el apellido y nombres y el 
--promedio percibido en concepto de colaboraciones.
  SELECT Col.Nombre Nombre, Col.Apellido Apellido, AVG(CB.PrecioHora * CB.Tiempo) HonorarioPromedio 
  FROM Colaboradores Col
  JOIN Colaboraciones CB ON CB.IDColaborador = Col.ID
  Where Col.Tipo like 'I'
  GROUP BY Col.Nombre, Col.Apellido
  Order By Col.Nombre

--20 Listar el promedio percibido en concepto de colaboraciones para colaboradores 
--internos y el promedio percibido en concepto de colaboraciones para colaboradores 
--externos.
  Select CB.Tipo Tipo, AVG(CC.PrecioHora * CC.Tiempo) HonorarioPromedio 
  from Colaboradores CB
  JOIN Colaboraciones CC on CC.IDColaborador = CB.ID
  Group By CB.Tipo

--21 Listar el nombre del proyecto y el total neto estimado. Este último valor surge del costo estimado menos los pagos 
--que requiera hacer en concepto de colaboraciones.
 SELECT Pro.Nombre Nombre, SUM(Pro.CostoEstimado - (Col.PrecioHora * Col.Tiempo)) TotalNeto FROM Proyectos Pro
 JOIN Modulos Modu ON Modu.IDProyecto = Pro.Id
 JOIN Tareas Tar ON Tar.IDModulo = Modu.ID
 JOIN Colaboraciones Col ON Col.IDTarea = Tar.ID
 GROUP BY Pro.Nombre
 Order BY Nombre

--22 Listar la cantidad de colaboradores distintos que hayan colaborado en alguna tarea que correspondan a proyectos de clientes de tipo 'Unicornio'.
 SELECT Count(Col.ID) Cantidad FROM Colaboradores Col
 JOIN Colaboraciones CB ON CB.IDColaborador = Col.ID
 JOIN Tareas Tar ON CB.IDTarea = Tar.ID
 JOIN Modulos Modu ON Tar.IDModulo = Modu.ID
 JOIN Proyectos Pro ON Modu.IDProyecto = Pro.ID 
 JOIN Clientes Cli ON Pro.IDCliente = Cli.ID
 JOIN TiposCliente TC ON Cli.IDTipo = TC.ID
 WHERE TC.Nombre in('Unicornio') 


--23 La cantidad de tareas realizadas por colaboradores del país 'Argentina'.
 SELECT Count(Tar.ID) CantidadArgentina FROM Tareas Tar
 JOIN Colaboraciones CC on CC.IDTarea = Tar.ID 
 JOIN Colaboradores CB on CC.IDColaborador = CB.ID
 JOIN Ciudades Ciud ON CB.IDCiudad = Ciud.ID
 JOIN Paises Pais ON Ciud.IDPais = Pais.ID 
 Where Pais.Nombre = 'Argentina'

--24 Por cada proyecto, la cantidad de módulos que se haya estimado mal la fecha de fin. Es decir, que se haya finalizado antes o después que la fecha estimada. 
--Indicar el nombre del proyecto y la cantidad calculada.
 SELECT Pro.Nombre Nombre,Count(Modu.ID) Cantidad From Proyectos Pro
 JOIN Modulos Modu ON Modu.IDProyecto = Pro.ID
 Where Modu.FechaFin <> Modu.FechaEstimadaFin 
 GROUP BY Pro.Nombre