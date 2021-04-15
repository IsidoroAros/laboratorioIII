Use BlueprintParaConsultas

select * from Proyectos
select * from Clientes

--  1) Listado de todos los clientes.
-- Select * from Clientes

--  2) Listado de todos los proyectos.
-- Select * from Proyectos

--  3) Listado con nombre, descripción, costo, fecha de inicio y de fin de todos los proyectos.
-- Select Nombre, Descripcion, Costo, FechaInicio, FechaFin From Proyectos

--  4) Listado con nombre, descripción, costo y fecha de inicio de todos los proyectos con costo mayor a cien mil pesos.
-- Select Nombre, Descripcion, Costo, FechaInicio, FechaFin from Proyectos where (costo > 100000)

--  5) Listado con nombre, descripción, costo y fecha de inicio de todos los proyectos con costo menor a cincuenta mil pesos .
-- select Nombre, Descripcion, Costo, FechaInicio from Proyectos where(costo <= 50000)

--  6) Listado con todos los datos de todos los proyectos que comiencen en el año 2020.
-- select * from Proyectos where year(FechaInicio) = 2020

--  7) Listado con nombre, descripción y costo de los proyectos que comiencen en el año 2020 y cuesten más de cien mil pesos.
-- Select Nombre, Descripcion, Costo, FechaInicio From Proyectos Where (Year(FechaInicio) = 2020 AND Costo > 100000)

--  8) Listado con nombre del proyecto, costo y año de inicio del proyecto.
-- Select Nombre, Costo, year(FechaInicio) as anio from Proyectos

--  9) Listado con nombre del proyecto, costo, fecha de inicio, fecha de fin y días de duración de los proyectos.
-- Select Nombre, Costo, FechaInicio, FechaFin, DateDiff(day, FechaInicio, FechaFin) as duracion from Proyectos

-- 10) Listado con razón social, cuit y teléfono de todos los clientes cuyo IDTipo sea 1, 3, 5 o 6
-- select razonSocial, cuit, telefonoFijo, telefonoMovil from Clientes where ID in (1,3,5,6)
 /*ID = 1 or id = 3 or id = 5 or id = 6*/

-- 11) Listado con nombre del proyecto, costo, fecha de inicio y fin de todos los proyectos que no pertenezcan a los clientes 1, 5 ni 10.
-- select idCliente, nombre, costo, fechaInicio, fechaFin from Proyectos where IDCliente not in(1,5,10)

-- 12) Listado con nombre del proyecto, costo y descripción de aquellos proyectos que hayan comenzado entre el 1/1/2018 y el 24/6/2018.
-- select nombre, costo, FechaInicio, fechaFin, descripcion from Proyectos where fechaInicio between '1/1/2018' and '6/24/2018'

-- 13) Listado con nombre del proyecto, costo y descripción de aquellos proyectos que hayan finalizado entre el 1/1/2019 y el 12/12/2019.
-- select nombre, costo, descripcion, fechainicio, fechafin from Proyectos where fechaFin between '1/1/2019' and '12/12/2019'

-- 14) Listado con nombre de proyecto y descripción de aquellos proyectos que aún no hayan finalizado.
-- select nombre, descripcion, fechaFin from proyectos where (fechaFin > getDate() or fechaFin is null)

-- 15) Listado con nombre de proyecto y descripción de aquellos proyectos que aún no hayan comenzado.
--select nombre, descripcion, fechaInicio from proyectos where fechaInicio > getDate()

-- 16) Listado de clientes cuya razón social comience con letra vocal.
-- select * from Clientes where razonSocial like '[aeiou]%'

-- 17) Listado de clientes cuya razón social finalice con vocal.
-- select * from Clientes where razonSocial like '%[aeiou]'

-- 18) Listado de clientes cuya razón social finalice con la palabra 'Inc'
-- select * from Clientes where razonSocial like '%inc'

-- 19) Listado de clientes cuya razón social no finalice con vocal.
-- select * from Clientes where razonSocial not like '%[aeiou]'

-- 20) Listado de clientes cuya razón social no contenga espacios.
-- select * from Clientes where razonSocial not like '% %'

-- 21) Listado de clientes cuya razón social contenga más de un espacio.
-- select * from Clientes where razonSocial like '% % %'

-- 22) Listado de razón social, cuit, email y celular de aquellos clientes que tengan mail pero no teléfono.
-- select razonSocial, cuit, email, telefonoMovil, telefonoFijo from Clientes where (email is not null and TelefonoFijo is null and telefonoMovil is null)

-- 23) Listado de razón social, cuit, email y celular de aquellos clientes que no tengan mail pero sí teléfono.
-- select razonSocial, cuit, email, telefonoMovil, telefonoFijo from Clientes where (email is null and (TelefonoFijo is not null or telefonoMovil is not null))

-- 24) Listado de razón social, cuit, email, teléfono o celular de aquellos clientes que tengan mail o teléfono o celular.
--select razonSocial, cuit, email, telefonoMovil, telefonoFijo from Clientes where (email is not null or TelefonoFijo is not null or telefonoMovil is not null)

-- 25) Listado de razón social, cuit y mail. Si no dispone de mail debe aparecer el texto "Sin mail".
	/*
	---------- CASE 1 DE RESOLUCION ----------
	select razonSocial, cuit, email,
	case
	when email is not null then email -> cuando si hay mail usar el mail original
	when email is null then 'Sin mail'  -> cuando no hay mail agregar sin mail a la columna
	end as Email
	from Clientes 
	*/

-- 26) Listado de razón social, cuit y una columna llamada Contacto con el mail, si no posee mail, con el número de celular y si no posee número de celular con un texto que diga "Incontactable".
/*
select RazonSocial, Cuit, 
case
when email is null and telefonoMovil is null and telefonoMovil is null then 'Incontactable'
when email is not null then email
when telefonoMovil is not null then telefonoMovil
when telefonoFijo is not null then telefonoFijo
else 'Incontactable'
end as 'Contacto'
from clientes
*/
-- select RazonSocial, Cuit, isnull(email, isnull(telefonoMovil, isnull(telefonoFijo, 'Incontatable'))) as Contacto from Clientes

-- Atajo sintáctico para manejo de nulos con coalesce.
-- todas las columnas a evaluar deben ser del mismo tipo de dato
select RazonSocial, Cuit, Coalesce(email, telefonoMovil, telefonoFijo, 'Incontactable') as Contacto
From Clientes