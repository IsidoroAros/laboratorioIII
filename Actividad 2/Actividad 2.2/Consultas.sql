Use BluePrintActividad22
-- Reanudar en 1_31_07


-- 2)
-- Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Sólo de aquellos
-- clientes que posean ciudad y país.

Select
Cl.RazonSocial, Cl.Cuit, Ciud.Nombre as Ciudad, Pais.Nombre as Pais -- Columnas solicitadas
From Clientes as Cl -- Al ser inner Join el FROM puede ser de cualquiera de las dos tablas
JOIN Ciudades as Ciud ON Cl.IDCiudad = Ciud.ID -- Join de Clientes con Ciudades
JOIN Paises as Pais on Ciud.ID = Pais.ID -- Join de Ciudades con Paises


-- 3)
-- Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellos clientes que no tengan ciudad relacionada.


-- 4)
-- Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellas ciudades y países que no tengan clientes relacionados.


-- 5)
-- Listar los nombres de las ciudades que no tengan clientes asociados. Listar también el nombre del país al que pertenece la ciudad.


-- 6)
-- Listar para cada proyecto el nombre del proyecto, el costo, la razón social del cliente, el nombre del tipo de cliente y el nombre de la ciudad (si la tiene registrada) de aquellos clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.


/*------------------- Práctica extra -------------------*/

/*------------------- Inner Join -------------------*/
-- Nos sirve cuando queremos consultar dos tablas en simultáneo y hacer un cruce de los datos que encontramos a partir de una columna en comun que hace una
-- intersección. Allí se produce el inner Join
-- El inner Join debe tener un elemento coincidente entre dos o mas tablas que se utilicen para hacer un "matcheo"
-- En este caso estaremos usando el ID
Select
Nombre, Apellido, IDTarea, Tipo, Tiempo -- Selecciono las columnas de ambas tablas que quiero en mi tabla grande del Join
From Colaboradores as Dores 
JOIN Colaboraciones as Ciones 
ON Dores.ID = Ciones.IDColaborador -- Punto donde ambas tablas hacen el inner Join
order by Apellido asc -- Clausula de orden con criterio definido: apellido de A - Z, puede ser de Z - A con desc
