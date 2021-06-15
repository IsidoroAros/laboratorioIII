USE BluePrint
GO
-- 1 Por cada colaborador listar el apellido y nombre y la cantidad de proyectos distintos en 
-- los que haya trabajado.
SELECT CB.Nombre, CB.Apellido,
(
    SELECT Count(DISTINCT Pro.ID) FROM Proyectos Pro 
    JOIN Modulos Mod ON Mod.IDProyecto = Pro.ID
    JOIN Tareas Tar ON Tar.IDModulo = Mod.ID
    JOIN Colaboraciones CC ON CC.IDTarea = Tar.ID
    WHERE CC.IDColaborador = CB.ID
) ColaboracionesProyectos
FROM Colaboradores CB

-- 2 Por cada cliente, listar la razón social y el costo estimado del módulo más costoso que haya
--  solicitado.
SELECT Cli.RazonSocial,
(
    SELECT MAX(Mod.CostoEstimado) FROM Modulos Mod
    JOIN Proyectos Pro ON Mod.IDProyecto = Pro.ID
    WHERE Pro.IDCliente = Cli.ID
) ModMasCostoso
FROM Clientes Cli

-- 3 Los nombres de los tipos de tareas que hayan registrado más de diez colaboradores distintos 
-- en el año 2020. 
SELECT TT.Nombre FROM TiposTarea TT
WHERE
(
    SELECT COUNT(*) FROM Colaboradores CB 
    JOIN Colaboraciones CC ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE Tar.IDTipo = TT.ID AND YEAR(Tar.FechaFin) = 2020
) > 10

-- 4 Por cada cliente listar la razón social y el promedio abonado en concepto de proyectos. 
-- Si no tiene proyectos asociados mostrar el cliente con promedio nulo.
SELECT DISTINCT Cli.RazonSocial,
(
    SELECT SUM(Pro.CostoEstimado) FROM Proyectos Pro
    WHERE Pro.IDCliente = Cli.ID
) PromedioProyectos
FROM Clientes Cli

-- 5 Los nombres de los tipos de tareas que hayan promediado más horas de colaboradores externos
-- que internos.

SELECT TT.Nombre FROM TiposTarea TT
WHERE
(
    SELECT AVG(CC.Tiempo) FROM Colaboraciones CC
    JOIN Colaboradores CB ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE CB.Tipo LIKE 'E' AND Tar.IDTipo = TT.ID
) > 
(
    SELECT AVG(CC.Tiempo) FROM Colaboraciones CC
    JOIN Colaboradores CB ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE CB.Tipo LIKE 'I' AND Tar.IDTipo = TT.ID
)

-- 6 El nombre de proyecto que más colaboradores distintos haya empleado.

-- 7 Por cada colaborador, listar el apellido y nombres y la cantidad de horas trabajadas 
-- en el año 2018, la cantidad de horas trabajadas en 2019 y la cantidad de horas trabajadas 
-- en 2020.

-- 8 Los apellidos y nombres de los colaboradores que hayan trabajado más horas en 2018 que 
-- en 2019 y más horas en 2019 que en 2020.

-- 9 Los apellidos y nombres de los colaboradores que nunca hayan trabajado en un proyecto 
-- contratado por un cliente extranjero.

-- 10 Por cada tipo de tarea listar el nombre, el precio de hora base y el promedio de valor 
-- hora real (obtenido de las colaboraciones). También, una columna llamada Variación con las 
-- siguientes reglas:
-- Poca → Si la diferencia entre el promedio y el precio de hora base es menor a $500.
-- Mediana → Si la diferencia entre el promedio y el precio de hora base está entre $501 y $999.
-- Alta → Si la diferencia entre el promedio y el precio de hora base es $1000 o más.
