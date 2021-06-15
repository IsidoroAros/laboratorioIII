USE parcial1
GO

-- 1) Listado con Apellido y nombres de los clientes que hayan gastado más de $60000 en
-- el año 2020 en concepto de servicios.

SELECT Cli.Apellido, Cli.Nombre FROM Clientes Cli
WHERE (
    SELECT SUM(Ser.Importe) FROM Servicios Ser
    WHERE Ser.IDCliente = Cli.ID AND YEAR(Ser.Fecha) = 2020
) > 60000

-- 2) Listado con ID, Apellido y nombres sin repeticiones de los técnicos que hayan
-- cobrado un servicio menos de $2600 y dicho servicio haya demorado más que el
-- promedio general de duración de servicios.

SELECT DISTINCT Tec.ID, Tec.Nombre, Tec.Apellido FROM Tecnicos Tec
JOIN Servicios Ser ON Ser.IDTecnico = Tec.ID
WHERE Ser.Importe < 2600 AND Ser.Duracion < ( SELECT AVG(Ser2.Duracion) FROM Servicios Ser2 )

-- 3) Listado con Apellido y nombres de los técnicos, total recaudado en concepto de
-- servicios abonados en efectivo y total recaudado en concepto de servicios abonados
-- con tarjeta.

SELECT DISTINCT Tec.Apellido, Tec.Nombre,
(
    SELECT isnull(SUM(Ser.Importe),0) FROM Servicios Ser
    WHERE Ser.IDTecnico = Tec.ID AND Ser.FormaPago = 'E'
) Efectivo,
(
    SELECT isnull(SUM(Ser.Importe),0) FROM Servicios Ser
    WHERE Ser.IDTecnico = Tec.ID AND Ser.FormaPago = 'T'
) Tarjeta
FROM Tecnicos Tec


-- 4) Listar la cantidad de tipos de servicio que registre más clientes de tipo particular que
-- clientes de tipo empresa.

SELECT COUNT(*) MasParticularQueEmpresa FROM TiposServicio TS
WHERE
(
    SELECT COUNT(*) FROM Servicios Ser
    JOIN Clientes Cli ON Ser.IDCliente = Cli.ID
    WHERE Cli.Tipo like 'P' AND Ser.IDTipo = TS.ID
) >
(
    SELECT COUNT(*) FROM Servicios Ser
    JOIN Clientes Cli ON Ser.IDCliente = Cli.ID
    WHERE Cli.Tipo like 'E' AND Ser.IDTipo = TS.ID
)

-- 5) Agregar las tablas y/o restricciones que considere necesario para permitir registrar
-- que un cliente pueda valorar el trabajo realizado en un servicio por parte de un
-- técnico. Debe poder registrar un puntaje entre 1 y 10 y un texto de hasta 500
-- caracteres con observaciones.
CREATE TABLE Valoraciones(
    IDValoracion int not null PRIMARY KEY,
    Valoracion smallint not null CHECK(Valoracion BETWEEN 1 AND 10),
    Observaciones varchar(500) not null
)

ALTER TABLE Servicios
ADD IDValoracion int NOT NULL FOREIGN KEY REFERENCES Valoraciones(IDValoracion)


