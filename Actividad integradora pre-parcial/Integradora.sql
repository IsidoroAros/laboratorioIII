USE  BluePrint

Select Col.Nombre From Colaboradores Col

-- 1. Por cada colaborador listar el apellido y nombre y la cantidad de proyectos distintos en los que haya trabajado.
SELECT CB.Nombre, CB.Apellido, 
(
    SELECT COUNT(distinct Pro.Id) FROM Proyectos Pro
    JOIN Modulos Mod ON Mod.IDProyecto = Pro.ID
    JOIN Tareas Tar ON Tar.IDModulo = Mod.ID
    JOIN Colaboraciones CC ON CC.IDTarea = Tar.ID
    WHERE CC.IDColaborador = CB.ID

) CantidadProyectos
FROM Colaboradores CB 


-- 2. Por cada cliente, listar la razón social y el costo estimado del módulo más costoso que haya solicitado.
SELECT Cli.RazonSocial,
(
    SELECT MAX(Mod.CostoEstimado) FROM Modulos Mod
    JOIN Proyectos Pro ON Mod.IDProyecto = Pro.ID
    WHERE Pro.IDCliente = Cli.ID
) ModuloMasCostoso
FROM Clientes Cli

-- 3. Los nombres de los tipos de tareas que hayan registrado más de diez colaboradores distintos en el año 2020. 
SELECT TT.Nombre FROM TiposTarea TT
WHERE (
    SELECT COUNT( DISTINCT CB.ID) FROM Colaboradores CB
    JOIN Colaboraciones CC ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE TAR.IDTipo = TT.ID
) > 10

-- 4. Por cada cliente listar la razón social y el promedio abonado en concepto de proyectos. Si no tiene proyectos asociados mostrar el cliente con promedio nulo.
-- Doro
SELECT Cli.RazonSocial,
(
    SELECT AVG(Pro.CostoEstimado) FROM Proyectos Pro
    WHERE Pro.IDCliente = Cli.ID
) PromedioAbonado
FROM Clientes Cli

-- Alternativa Eli
SELECT CL.RazonSocial, AVG(PR.CostoEstimado) PromedioAbonado 
FROM Clientes CL
JOIN Proyectos PR ON PR.IDCliente=CL.ID 
GROUP BY CL.RazonSocial


-- 5. Los nombres de los tipos de tareas que hayan promediado más horas de colaboradores externos que internos.
SELECT TT.Nombre FROM TiposTarea TT
WHERE 
(
    SELECT AVG(CC.Tiempo) FROM Colaboraciones CC
    JOIN Colaboradores CB ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE Tar.IDTipo = TT.ID AND CB.Tipo = 'E'
)  > 
(
    SELECT AVG(CC.Tiempo) FROM Colaboraciones CC
    JOIN Colaboradores CB ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE Tar.IDTipo = TT.ID AND CB.Tipo = 'I'
)

-- 6. El nombre de proyecto que más colaboradores distintos haya empleado.
SELECT DISTINCT Pro.Nombre, 
(
    SELECT COUNT(Distinct CB.ID) FROM Colaboradores CB
    JOIN Colaboraciones CC ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    JOIN Modulos Mod ON TAr.IDModulo = Mod.ID
    WHERE Mod.IDProyecto = Pro.ID
) ColaboracionesProyecto
FROM Proyectos Pro ORDER BY ColaboracionesProyecto DESC
-- Falta mostrar el máximo


-- 7. Por cada colaborador, listar el apellido y nombres y la cantidad de horas trabajadas en el año 2018, la cantidad de horas trabajadas en 2019 y la cantidad de horas trabajadas en 2020.
SELECT CB.Nombre, CB.Apellido,
(
    SELECT SUM(CC.Tiempo) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE (YEAR(Tar.FechaInicio) = 2018 OR YEAR(Tar.FechaFin) = 2018) AND CC.IDColaborador = CB.ID
) Col2018,
(
    SELECT SUM(CC.Tiempo) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE (YEAR(Tar.FechaInicio) = 2019 OR YEAR(Tar.FechaFin) = 2019) AND CC.IDColaborador = CB.ID
) Col2019,
(
    SELECT SUM(CC.Tiempo) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE (YEAR(Tar.FechaInicio) = 2020 OR YEAR(Tar.FechaFin) = 2020) AND CC.IDColaborador = CB.ID
) Col2020
FROM Colaboradores CB


-- 8. Los apellidos y nombres de los colaboradores que hayan trabajado más horas en 2018 que en 2019 y más horas en 2019 que en 2020.
SELECT CB.Nombre, CB.Apellido FROM Colaboradores CB
WHERE 
(
    SELECT SUM(distinct isnull(CC.Tiempo,0)) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE (YEAR(Tar.FechaInicio) = 2018 OR YEAR(Tar.FechaFin) = 2018) AND CC.IDColaborador = CB.ID
) >
(
    SELECT SUM(distinct isnull(CC.Tiempo,0)) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE (YEAR(Tar.FechaInicio) = 2019 OR YEAR(Tar.FechaFin) = 2019) AND CC.IDColaborador = CB.ID
) AND 
(
    SELECT SUM(distinct isnull(CC.Tiempo,0)) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE (YEAR(Tar.FechaInicio) = 2019 OR YEAR(Tar.FechaFin) = 2019) AND CC.IDColaborador = CB.ID
) >
(
    SELECT SUM(distinct isnull(CC.Tiempo,0)) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE (YEAR(Tar.FechaInicio) = 2020 OR YEAR(Tar.FechaFin) = 2020) AND CC.IDColaborador = CB.ID
)

-- SELECT CB.Nombre, CB.Apellido,
-- (
--     SELECT SUM(distinct isnull(CC.Tiempo,0)) FROM Colaboraciones CC
--     JOIN Tareas Tar ON CC.IDTarea = Tar.ID
--     WHERE (YEAR(Tar.FechaInicio) = 2020 OR YEAR(Tar.FechaFin) = 2020) AND CC.IDColaborador = CB.ID
-- ) Col2018
-- FROM Colaboradores CB

-- SELECT * FROM Tareas Tar
-- WHERE YEAR(Tar.FechaFin) = 2019


-- 9. Los apellidos y nombres de los colaboradores que nunca hayan trabajado en un proyecto contratado por un cliente extranjero.

-- 9.1 Alternativa de suma de tiempos en proyectos not like extranjero
SELECT CB.Nombre, CB.Apellido FROM Colaboradores CB
WHERE 
(
    SELECT SUM(CC.Tiempo) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    JOIN Modulos Mod ON Tar.IDModulo = Mod.ID
    JOIN Proyectos Pro ON Mod.IDProyecto = Pro.ID
    JOIN Clientes Cli ON Pro.IDCliente = Cli.ID
    JOIN TiposCliente TC ON Cli.IDTipo = TC.ID
    WHERE TC.Nombre like '%Extranjero%' AND CC.IDColaborador = CB.ID
) = 0

-- Obtener proyectos de no extranjeros
SELECT Pro.Nombre,
(
    SELECT COUNT(CB.ID) FROM Colaboradores CB 
    JOIN Colaboraciones CC ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    JOIN Modulos Mod ON Tar.IDModulo = Mod.ID
    WHERE Mod.IDProyecto = Pro.ID
) ProyectosNoExtranjeros
FROM Proyectos Pro
JOIN Clientes Cli ON Pro.IDCliente = Cli.ID
JOIN TiposCliente TC ON Cli.IDTipo = TC.ID
WHERE TC.Nombre not like '%Extranjero%'
-- Falta terminar


-- 10. Por cada tipo de tarea listar el nombre, el precio de hora base y el promedio de valor hora real (obtenido de las colaboraciones).
-- También, una columna llamada Variación con las siguientes reglas:
-- Poca → Si la diferencia entre el promedio y el precio de hora base es menor a $500.
-- Mediana → Si la diferencia entre el promedio y el precio de hora base está entre $501 y $999.
-- Alta → Si la diferencia entre el promedio y el precio de hora base es $1000 o más.
SELECT TT.Nombre, TT.PrecioHoraBase, AVG(Col.PrecioHora) Promedio,
(
    SELECT CASE  
        WHEN AVG(Col.PrecioHora) - TT.PrecioHoraBase <= 500 THEN 'Baja'
        WHEN AVG(Col.PrecioHora) - TT.PrecioHoraBase  > 500 AND AVG(Col.PrecioHora) - TT.PrecioHoraBase <= 1000 THEN 'Media'
        WHEN AVG(Col.PrecioHora) - TT.PrecioHoraBase  > 1000 THEN 'Alta'
    END
) Variacion
FROM TiposTarea TT
JOIN Tareas Tar ON Tar.IDTipo = TT.ID
JOIN Colaboraciones Col ON Col.IDTarea = Tar.ID
WHERE Col.IDTarea = Tar.ID
GROUP BY TT.Nombre, TT.PrecioHoraBase