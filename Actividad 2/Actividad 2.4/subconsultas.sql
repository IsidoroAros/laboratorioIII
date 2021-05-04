USE BluePrint
GO

-- 1. Listar los nombres de proyecto y costo estimado de aquellos proyectos cuyo costo estimado sea mayor al promedio de costos.
Select Pro.Nombre, Pro.CostoEstimado 
FROM Proyectos Pro
where Pro.CostoEstimado > (Select AVG(Pro.CostoEstimado) PromedioCostos From Proyectos Pro) 


-- 2. Listar razón social, cuit y contacto (email, celular o teléfono) de aquellos clientes que no tengan proyectos 
-- que comiencen en el año 2020.
SELECT CL.RazonSocial, CL.CUIT, COALESCE(CL.EMail, CL.Celular, CL.Telefono) AS Contacto, PR.FechaInicio FechaInicio, Pr.Nombre
FROM Clientes CL
JOIN Proyectos PR ON PR.IDCliente = CL.ID
WHERE PR.FechaInicio NOT IN (SELECT PR.FechaInicio FROM Proyectos PR where YEAR(PR.FechaInicio) = '2020')

-- 3. Listado de países que no tengan clientes relacionados.
Select P.Nombre FROM Paises P where P.ID not in(
    SELECT distinct P.ID From Paises P
    JOIN Ciudades C ON C.IDPais = P.ID
    JOIN Clientes Cli ON Cli.IDCiudad = C.ID
)

-- 4. Listado de proyectos que no tengan tareas registradas. 
Select Pro.Nombre FROM Proyectos Pro WHERE Pro.ID not in (
    SELECT distinct Pro.ID FROM Proyectos Pro 
    JOIN Modulos Mod ON Mod.IDProyecto = Pro.ID
    JOIN Tareas Tar ON Tar.IDModulo = Mod.ID
)


-- 5. Listado de tipos de tareas que no registren tareas pendientes.
Select TT.Nombre FROM TiposTarea TT WHERE TT.ID not in(
    Select distinct TT.id FROM TiposTarea TT
    JOIN Tareas Tar ON TT.ID = Tar.IDTipo
    WHERE Tar.FechaInicio is null 
)

-- 6. Listado con ID, nombre y costo estimado de proyectos cuyo costo estimado sea menor al costo estimado de 
-- cualquier proyecto de clientes extranjeros (clientes que no sean de Argentina o no tengan asociado un país).
SELECT Pro.Id ID, Pro.Nombre, Pro.CostoEstimado From Proyectos Pro 
WHERE Pro.CostoEstimado < ALL(
    Select Proy.CostoEstimado EstimadoExtranjero
    From Proyectos Proy
       JOIN Clientes Cli ON Cli.ID = Proy.IDCliente
       LEFT JOIN Ciudades Ciud ON Ciud.ID = Cli.IDCiudad
       LEFT JOIN Paises Pais ON Pais.ID = Ciud.IDPais
    WHERE Pais.Nombre like 'Argentina' or Pais.Nombre is null
)
-- revisar

-- 7. Listado de apellido y nombres de colaboradores que hayan demorado más en una tarea que el colaborador de la 
-- ciudad de 'Buenos Aires' que más haya demorado.
SELECT Col.Nombre, Col.Apellido FROM Colaboradores Col
JOIN Colaboraciones Colaciones ON Colaciones.IDColaborador = Col.ID
WHERE Colaciones.Tiempo > ( SELECT MAX(Colaciones2.Tiempo) 
        From Colaboraciones Colaciones2
        JOIN Colaboradores Col2 ON Colaciones2.IDColaborador = Col2.ID
        JOIN Ciudades Ciud ON Col2.IDCiudad = Ciud.ID
        WHERE Ciud.Nombre like 'Buenos Aires'
    )

-- 8. Listado de clientes indicando razón social, nombre del país (si tiene) y cantidad de 
-- proyectos comenzados y cantidad de proyectos por comenzar.

SELECT Cli.RazonSocial,
    Coalesce((SELECT P.Nombre 
        FROM Paises P 
        JOIN Ciudades C ON C.IDPais = P.ID 
        JOIN Clientes Cli2 ON Cli2.IdCiudad = C.ID
        WHERE Cli.ID = Cli2.ID)
    , 'Null') Pais,
    ( SELECT COUNT( DISTINCT Pro.ID ) FROM Proyectos Pro WHERE GETDATE() > Pro.FechaInicio AND Pro.IDCliente = Cli.ID ) Comenzados, -- El proyecto debe cumplir con las fechas y con los ID's buscados en la consulta padre
    ( SELECT COUNT( DISTINCT Pro.ID ) FROM Proyectos Pro WHERE Pro.FechaInicio > GETDATE() AND Pro.IDCliente = Cli.ID ) PorComenzar
From Clientes Cli

-- 9. Listado de tareas indicando nombre del módulo, nombre del tipo de tarea, 
-- cantidad de colaboradores externos que 
-- la realizaron y cantidad de colaboradores internos que la realizaron.
SELECT 
(SELECT Mod.Nombre FROM Modulos Mod WHERE Mod.ID = Tar.IDModulo) Modulo,
(SELECT TT.Nombre FROM TiposTarea TT WHERE Tar.IDTipo = TT.ID) Tarea,
(SELECT COUNT(Col.ID) 
    FROM Colaboradores Col 
    JOIN Colaboraciones Colaciones ON Colaciones.IDColaborador = Col.ID
    JOIN Tareas Tar2 ON Colaciones.IDTarea = Tar2.ID
    WHERE Tar.ID = Tar2.ID AND Col.Tipo like 'I') Internos,
(SELECT COUNT(Col.ID) 
    FROM Colaboradores Col 
    JOIN Colaboraciones Colaciones ON Colaciones.IDColaborador = Col.ID
    JOIN Tareas Tar2 ON Colaciones.IDTarea = Tar2.ID
    WHERE Tar.ID = Tar2.ID AND Col.Tipo like 'E') Externo
FROM Tareas Tar

-- 10. Listado de proyectos indicando nombre del proyecto, costo estimado, cantidad de 
-- módulos cuya estimación de fin haya sido exacta, cantidad de módulos con estimación 
-- adelantada y cantidad de módulos con estimación demorada.
-- Adelantada →  estimación de fin haya sido inferior a la real.
-- Demorada   →  estimación de fin haya sido superior a la real.
SELECT Pro.Nombre Nombre, Pro.CostoEstimado Costo,
    (SELECT COUNT(distinct Mod.ID) FROM Modulos Mod WHERE Mod.FechaEstimadaFin = Mod.FechaFin and Pro.ID = Mod.IDProyecto) Exacto,
    (SELECT COUNT(distinct Mod.ID) FROM Modulos Mod WHERE Mod.FechaEstimadaFin < Mod.FechaFin and Pro.ID = Mod.IDProyecto) Adelantado,
    (SELECT COUNT(distinct Mod.ID) FROM Modulos Mod WHERE Mod.FechaEstimadaFin > Mod.FechaFin and Pro.ID = Mod.IDProyecto) Demorado
FROM Proyectos Pro


-- 11. Listado con nombre del tipo de tarea y total abonado en concepto de honorarios 
-- para colaboradores internos y total abonado en concepto de honorarios para 
-- colaboradores externos.
SELECT TT.Nombre,
    (SELECT SUM(Colc.PrecioHora * Colc.Tiempo) 
        FROM Colaboraciones Colc
        JOIN Tareas Tar ON Colc.IDTarea = Tar.ID
        JOIN Colaboradores Col ON Colc.IDColaborador = Col.ID
        WHERE Tar.IDTipo = TT.ID AND Col.Tipo like 'I') Internos,
    (SELECT SUM(Colc.PrecioHora * Colc.Tiempo) 
        FROM Colaboraciones Colc
        JOIN Tareas Tar ON Colc.IDTarea = Tar.ID
        JOIN Colaboradores Col ON Colc.IDColaborador = Col.ID
        WHERE Tar.IDTipo = TT.ID AND Col.Tipo like 'E') Externos
FROM TiposTarea TT


-- 12. Listado con nombre del proyecto, razón social del cliente y saldo final del proyecto. 
-- El saldo final surge de la siguiente fórmula: 
-- Costo estimado - Σ(HCE) - Σ(HCI) * 0.1, siendo:
-- HCE → Honorarios de colaboradores externos 
-- HCI → Honorarios de colaboradores internos.
SELECT Pro.Nombre, Cli.RazonSocial,
Pro.CostoEstimado - (
    SELECT Coalesce(SUM(Col.Tiempo * Col.PrecioHora), 0 ) 
    FROM Colaboraciones Col
    JOIN Colaboradores CB ON CB.ID = Col.IDColaborador
    JOIN Tareas Tar ON Col.IDTarea = Tar.ID
    JOIN Modulos Mod ON Tar.IDModulo = Mod.ID
    WHERE Pro.ID = Mod.IDProyecto AND CB.Tipo = 'E'
) - 
(
    SELECT Coalesce(SUM(Col.Tiempo * Col.PrecioHora), 0 ) 
    FROM Colaboraciones Col
    JOIN Colaboradores CB ON CB.ID = Col.IDColaborador
    JOIN Tareas Tar ON Col.IDTarea = Tar.ID
    JOIN Modulos Mod ON Tar.IDModulo = Mod.ID
    WHERE Pro.ID = Mod.IDProyecto AND CB.Tipo = 'I'
)*0.1 SaldoFinal
FROM Proyectos Pro
JOIN Clientes Cli ON Pro.IDCliente = Cli.ID


-- 13. Para cada módulo listar el nombre del proyecto, el nombre del módulo, 
-- el total en tiempo que demoraron las tareas 
-- de ese módulo y qué porcentaje de tiempo representaron las tareas 
-- de ese módulo en relación al tiempo total de tareas del proyecto.
SELECT Pro.Nombre Proyecto, Mod.Nombre Modulo,
(
    SELECT isnull(SUM(CB.Tiempo),0) FROM Colaboraciones CB
    JOIN Tareas Tar ON CB.IDTarea = Tar.ID
    JOIN Modulos Mod2 ON Tar.IDModulo = Mod2.ID
    WHERE Mod.ID = Tar.IDModulo
) TotalTareasHoras,
(
    SELECT isnull(SUM(CB.Tiempo),0) FROM Colaboraciones CB
    JOIN Tareas Tar ON CB.IDTarea = Tar.ID
    JOIN Modulos Mod2 ON Tar.IDModulo = Mod2.ID
    WHERE Mod.ID = Tar.IDModulo
) /
(
    SELECT isnull(SUM(CB.Tiempo),1) FROM Colaboraciones CB
    JOIN Tareas Tar ON CB.IDTarea = Tar.ID
    JOIN Modulos Mod2 ON Tar.IDModulo = Mod2.ID
    WHERE Mod2.IDProyecto = Pro.ID
) * 100 as Porcentaje
FROM Modulos Mod
JOIN Proyectos Pro ON Mod.IDProyecto = Pro.ID
-- Revisar

-- 14. Por cada colaborador indicar el apellido, el nombre, 'Interno' o 
-- 'Externo' según su tipo y la cantidad de tareas de tipo 'Testing' 
-- que haya realizado y la cantidad de tareas de tipo 'Programación' 
-- que haya realizado.
-- NOTA: Se consideran tareas de tipo 'Testing' a las tareas que contengan 
-- la palabra 'Testing' en su nombre. Ídem para Programación.
SELECT CB.Nombre, CB.Apellido, CB.Tipo,
(
    SELECT COUNT(CC.IDColaborador) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    JOIN TiposTarea TT ON Tar.IDTipo = TT.ID
    WHERE CC.IDColaborador = CB.ID AND TT.Nombre like '%testing%'
) Testing,
(
    SELECT COUNT(CC.IDColaborador) FROM Colaboraciones CC
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    JOIN TiposTarea TT ON Tar.IDTipo = TT.ID
    WHERE CC.IDColaborador = CB.ID AND TT.Nombre like '%programación%'
) Programacion
FROM Colaboradores CB

SELECT TT.Nombre From TiposTarea TT WHERE TT.Nombre like '%programación%'

-- 15. Listado apellido y nombres de los colaboradores que no hayan 
-- realizado tareas de 'Diseño de base de datos'.
SELECT CB.Nombre, CB.Apellido, TT.Nombre
FROM Colaboradores CB
JOIN Colaboraciones CC ON CC.IDColaborador = CB.ID
JOIN Tareas Tar ON CC.IDTarea = Tar.ID
JOIN TiposTarea TT ON Tar.IDTipo = TT.ID
WHERE TT.Nombre NOT LIKE 'Diseño de base de datos' ORDER BY TT.Nombre ASC

SELECT TT.Nombre FROM TiposTarea TT WHERE TT.Nombre NOT LIKE 'Diseño de base de datos'

-- 16. Por cada país listar el nombre, la cantidad de clientes y la 
-- cantidad de colaboradores.
SELECT P.Nombre, 
(
    SELECT COUNT(Cli.ID) FROM Clientes Cli
    JOIN Ciudades Ciud ON Cli.IDCiudad = Ciud.ID
    WHERE Ciud.IDPais = P.ID
) Clientes,
(
    SELECT COUNT(CB.ID) FROM Colaboradores CB
    JOIN Ciudades Ciud ON CB.IDCiudad = Ciud.ID
    WHERE Ciud.IDPais = P.ID
) Colaboradores
FROM Paises P

-- 17. Listar por cada país el nombre, la cantidad de clientes y la 
-- cantidad de colaboradores de aquellos países que no tengan clientes 
-- pero sí colaboradores.
SELECT P.Nombre,
(
    SELECT COUNT(*) FROM Colaboradores Col
    JOIN Ciudades Ciud ON Col.IDCiudad = Ciud.ID
    WHERE Col.IDCiudad = Ciud.ID AND Ciud.IDPais = P.ID 
    AND (
        SELECT COUNT(*) FROM Clientes Cli
        JOIN Ciudades Ciud ON Cli.IDCiudad = Ciud.ID
        WHERE Cli.IDCiudad = Ciud.ID AND Ciud.IDPais = P.ID
    ) = 0
) Colaboradores
FROM Paises P


-- 18. Listar apellidos y nombres de los colaboradores internos que hayan 
-- realizado más tareas 
-- de tipo 'Testing' que tareas de tipo 'Programación'.
SELECT CB.Nombre, CB.Apellido FROM Colaboradores CB
WHERE
(
    SELECT COUNT(*) FROM Colaboradores CB2
    JOIN Colaboraciones CC ON CC.IDColaborador = CB2.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    JOIN TiposTarea TT ON Tar.IDTipo = TT.ID
    WHERE TT.Nombre like '%testing%' AND CB2.Tipo = 'I' AND CB2.ID = CB.ID
) >
(
    SELECT COUNT(*) FROM Colaboradores CB3
    JOIN Colaboraciones CC ON CC.IDColaborador = CB3.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    JOIN TiposTarea TT ON Tar.IDTipo = TT.ID
    WHERE TT.Nombre like '%programación%' AND CB3.Tipo = 'I' AND CB3.ID = CB.ID
)

-- 19. Listar los nombres de los tipos de tareas que hayan abonado más 
-- del cuádruple en colaboradores internos que externos
SELECT TT.Nombre FROM TiposTarea TT
WHERE
(
    SELECT SUM(CC.PrecioHora * CC.Tiempo) FROM Colaboraciones CC
    JOIN Colaboradores CB ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE CB.Tipo = 'I' AND TT.ID = Tar.ID
) >
(
    SELECT SUM(CC.PrecioHora * CC.Tiempo) FROM Colaboraciones CC
    JOIN Colaboradores CB ON CC.IDColaborador = CB.ID
    JOIN Tareas Tar ON CC.IDTarea = Tar.ID
    WHERE CB.Tipo = 'E' AND TT.ID = Tar.ID
) *4

-- 20. Listar los proyectos que hayan registrado igual cantidad de 
-- modulos con estimaciones demoradas 
-- que adelantadas y que al menos hayan registrado alguna estimación 
-- adelantada y que no hayan registrado ninguna estimación exacta.
-- Adelantada →  estimación de fin haya sido inferior a la real.
-- Demorada   →  estimación de fin haya sido superior a la real.
SELECT Pro.Nombre 
FROM Proyectos Pro
WHERE
(
    SELECT COUNT(*) FROM Modulos Mod
    WHERE Mod.FechaEstimadaFin > Mod.FechaFin AND Mod.IDProyecto = Pro.ID
) =
(
    SELECT COUNT(*) FROM Modulos Mod
    WHERE Mod.FechaEstimadaFin < Mod.FechaFin AND Mod.IDProyecto = Pro.ID
) AND
(
    SELECT COUNT(*) FROM Modulos Mod
    WHERE Mod.FechaEstimadaFin < Mod.FechaFin AND Mod.IDProyecto = Pro.ID 
) >= 1 AND
(
    SELECT COUNT(*) FROM Modulos Mod
    WHERE Mod.FechaEstimadaFin = Mod.FechaFin AND Mod.IDProyecto = Pro.ID 
) = 0
