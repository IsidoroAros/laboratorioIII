-- 1) Hacer un trigger que al ingresar una colaboración obtenga el precio de la misma a partir del precio hora base del tipo de tarea. Tener en cuenta que si el colaborador es externo el costo debe ser un 20% más caro.

DISABLE TRIGGER TR_PUNTO_UNO ON Colaboraciones
AFTER INSERT
AS
BEGIN
    -- Declarar variables
    DECLARE @IDColaborador BIGINT
    DECLARE @IDTarea BIGINT
    SELECT @IDColaborador = IDColaborador FROM inserted
    SELECT @IDTarea = IDTarea FROM inserted
    
    -- Obtener el precio hora tarea
    DECLARE @PrecioHoraBase MONEY
    SELECT @PrecioHoraBase = TT.PrecioHoraBase FROM TiposTarea TT
    JOIN Tareas ON Tareas.IDTipo = TT.ID
    WHERE @IDTarea = Tareas.ID

    -- Verificar si es colaborador externo
    DECLARE @TipoColab CHAR
    SELECT @TipoColab = Colaboradores.Tipo FROM Colaboradores
    WHERE Colaboradores.ID = @IDColaborador

    -- Verificar tipo de colaborador
    IF @TipoColab = 'E'
        BEGIN
            SET @PrecioHoraBase = @PrecioHoraBase * 1.2
        END

    -- Modificar el precio de la colaboración

    UPDATE Colaboraciones SET @PrecioHoraBase = Colaboraciones.PrecioHora
    WHERE Colaboraciones.IDTarea = @IDTarea AND Colaboraciones.IDColaborador = @IDColaborador
END

SELECT * FROM Colaboraciones
SELECT * FROM Colaboradores

INSERT INTO Colaboraciones VALUES(1,9,44,4800,1)

-- 2) Hacer un trigger que no permita que un colaborador registre más de 15 tareas en un mismo mes. De lo contrario generar un error con un mensaje aclaratorio.
GO
DISABLE TRIGGER TR_PUNTO_DOS ON Colaboraciones
INSTEAD OF INSERT
AS BEGIN
    -- DECLARACION DE VARIABLES
    DECLARE @IDColaborador INT
    DECLARE @IDTarea INT
    DECLARE @FechaTarea DATE
    DECLARE @TIEMPO SMALLINT
    DECLARE @PrecioHora MONEY
    DECLARE @CantTareas TINYINT
    SELECT @IDTarea = IDTarea FROM inserted
    SELECT @IDColaborador = IDColaborador FROM inserted
    SELECT @TIEMPO = Tiempo FROM inserted
    SELECT @PrecioHora = PrecioHora FROM inserted

    -- OBTENEMOS FECHA DE TAREA
    SELECT @FechaTarea = FECHAINICIO FROM Tareas WHERE ID = @IDTarea

    -- TAREAS DEL COLABORADOR EN EL MES
    SELECT @CantTareas = COUNT(COL.IDTAREA) FROM COLABORACIONES COL
    JOIN TAREAS TAR ON TAR.ID = COL.IDTarea
    WHERE IDColaborador = @IDColaborador 
    AND MONTH(TAR.FechaInicio) = MONTH(@FechaTarea) 
    AND YEAR(TAR.FechaInicio) = YEAR(@FechaTarea)

    IF @CantTareas >= 5 
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('NO PUEDE AGREGARSE LA TAREA YA QUE SUPERA LAS 5 EN EL MISMO MES', 16, 1)
    END
    ELSE 
    BEGIN
        INSERT INTO Colaboraciones VALUES(@IDTarea, @IDColaborador, @TIEMPO, @PrecioHora, 1)
        COMMIT TRANSACTION
    END
END
GO


SELECT * FROM Tareas T
JOIN Colaboraciones C ON C.IDTarea = T.ID
WHERE C.IDColaborador = 4 AND IDTarea BETWEEN 230 AND 250

INSERT INTO Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado) VALUES (240, 4, 90, 70000, 1)
INSERT INTO Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado) VALUES (241, 4, 90, 70000, 1)
INSERT INTO Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado) VALUES (242, 4, 90, 70000, 1)
INSERT INTO Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado) VALUES (243, 4, 90, 70000, 1)
INSERT INTO Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado) VALUES (244, 4, 90, 70000, 1)
INSERT INTO Colaboraciones(IDTarea, IDColaborador, Tiempo, PrecioHora, Estado) VALUES (245, 4, 90, 70000, 1)

SELECT * FROM Colaboraciones WHERE IDColaborador = 4

-- 3) Hacer un trigger que al ingresar una tarea cuyo tipo contenga el nombre 'Programación' se agreguen automáticamente dos tareas de tipo 'Testing unitario' y 'Testing de integración' de 4 horas cada una. La fecha de inicio y fin de las mismas debe ser NULL. Calcular el costo estimado de la tarea.

-- INGRESA UNA TAREA
GO
DISABLE TRIGGER TR_PUNTO_TRES ON TAREAS
AFTER INSERT
AS BEGIN
-- VARIABLES
DECLARE @TiposTarea VARCHAR(20)
DECLARE @Modulo INT
DECLARE @IdTarea INT

SELECT @IdTarea = MAX(ID) FROM Tareas
SELECT @Modulo = IDModulo FROM inserted
SELECT @TiposTarea = TT.Nombre FROM TiposTarea TT
    JOIN inserted INS ON INS.IDTipo = TT.ID
    WHERE TT.ID = INS.IDTipo
-- SE REVISA QUE EL TIPO DE TAREA CONTENGA "PROGRAMACION"
IF(@TiposTarea LIKE '%Programación%')
-- SE INSERTAN DOS TAREAS DE TESTING UNITARIO Y DE INTEGRACION CON FECHA NULL
    BEGIN
        INSERT INTO Tareas(IDModulo,IDTipo,FechaInicio,FechaFin,Estado) VALUES(@Modulo, 10, NULL, NULL, 1)
        INSERT INTO Tareas(IDModulo,IDTipo,FechaInicio,FechaFin,Estado) VALUES(@Modulo, 11, NULL, NULL, 1)
    END
END
GO

SELECT * FROM TiposTarea WHERE Nombre LIKE '%Testing unitario%'
SELECT * FROM TiposTarea WHERE Nombre LIKE '%Testing de integración%'
SELECT * FROM Tareas
SELECT * FROM Colaboraciones


-- 4) Hacer un trigger que al borrar una tarea realice una baja lógica de la misma en lugar de una baja
-- física.

-- OPCIÓN QUE MODIFICA UN ÚNICO REGISTRO
GO
DROP TRIGGER TR_PUNTO_CUATRO ON TAREAS
INSTEAD OF DELETE
AS BEGIN
        DECLARE @ID INT
        SELECT @ID = ID FROM deleted
        UPDATE Tareas SET ESTADO = 0
        WHERE ID = @ID
END
GO

-- VERSIÓN QUE EMULA UN CICLO (O CURSOR) PARA RECORRER VARIOS REGISTROS
GO
DROP TRIGGER TR_PUNTO_CUATRO_ANGEL ON TAREAS
INSTEAD OF DELETE
AS BEGIN
    UPDATE TAREAS SET ESTADO = 0 WHERE ID IN (SELECT ID FROM DELETED)
END
GO

SELECT * FROM TAREAS WHERE ID IN(SELECT ID FROM Tareas WHERE ID = 90)
DELETE FROM Tareas WHERE TAREAS.ID = 90

DISABLE TRIGGER TR_PUNTO_CUATRO ON TAREAS


-- 5) Hacer un trigger que al borrar un módulo realice una baja lógica del mismo en lugar de una baja física.
-- Además, debe borrar todas las tareas asociadas al módulo.
GO
DROP TRIGGER TR_PUNTO_CINCO ON MODULOS
INSTEAD OF DELETE
AS BEGIN
    DECLARE @IdModulo INT
    SELECT @IdModulo = ID FROM deleted
    UPDATE MODULOS SET ESTADO = 0
    WHERE MODULOS.ID = @IdModulo
    UPDATE Tareas SET Estado = 0 WHERE TAREAS.IDModulo = @IdModulo -- SE ACTUALIZA EL ESTADO A 0 YA QUE POR SER FK NO SE PUEDE ELIMINAR
END
GO


CREATE TRIGGER TR_PUNTO_CINCO_BIS ON MODULOS
INSTEAD OF DELETE
AS BEGIN
    UPDATE MODULOS SET ESTADO = 0 WHERE MODULOS.ID = (SELECT ID FROM deleted)
    DELETE FROM Tareas WHERE TAREAS.IDModulo IN (SELECT ID FROM Modulos)
END

SELECT * FROM Modulos WHERE ID = 20
SELECT * FROM TAREAS WHERE IDModulo = 20
DELETE FROM Modulos WHERE ID = 20


-- 6) Hacer un trigger que al borrar un proyecto realice una baja lógica del mismo en lugar de una baja 
-- física. Además, debe borrar todas los módulos asociados al proyecto.
GO
DISABLE TRIGGER TR_PUNTO_SEIS ON PROYECTOS
INSTEAD OF DELETE
AS BEGIN
	DECLARE @ID VARCHAR(5)
	SELECT @ID = ID FROM DELETED
	UPDATE Proyectos SET ESTADO = 0 WHERE PROYECTOS.ID = @ID
	DELETE FROM MODULOS WHERE MODULOS.IDProyecto = @ID
	-- DELETE FROM MODULOS WHERE MODULOS.IDProyecto IN (SELECT ID FROM PROYECTOS WHERE PROYECTOS.ID = @ID)
END
GO

SELECT * FROM PROYECTOS WHERE ID = 'Z111'
SELECT * FROM MODULOS WHERE IDProyecto = 'Z111'

DELETE FROM PROYECTOS WHERE ID = 'Z111'

-- 7) Hacer un trigger que si se agrega una tarea cuya fecha de fin es mayor a la fecha estimada de fin del 
-- módulo asociado a la tarea entonces se modifique la fecha estimada de fin en el módulo.
GO
DISABLE TRIGGER TR_PUNTO_SIETE ON TAREAS
AFTER INSERT
AS BEGIN
	DECLARE @FECHATAREA DATE
	DECLARE @IDMODULO INT
	DECLARE @FECHAESTIMADAMOD DATE

	SELECT @FECHATAREA = FECHAFIN FROM INSERTED
	SELECT @IDMODULO = IDModulo FROM INSERTED
	SELECT @FECHAESTIMADAMOD = (SELECT FechaEstimadaFin FROM MODULOS WHERE MODULOS.ID = @IDMODULO)

	IF(@FECHATAREA > @FECHAESTIMADAMOD)
	BEGIN
		--UPDATE Tareas SET FechaFin = @FECHAESTIMADAMOD WHERE TAREAS.ID = (SELECT ID FROM INSERTED)
		UPDATE MODULOS SET FechaEstimadaFin = @FECHATAREA WHERE MODULOS.ID = (SELECT IDMODULO FROM INSERTED)
	END
END
GO

SELECT * FROM TAREAS
SELECT * FROM MODULOS WHERE ID = 16


-- 8) Hacer un trigger que al borrar una tarea que previamente se ha dado de baja lógica realice la baja 
-- física de la misma.
GO
CREATE TRIGGER TR_PUNTO_OCHO
AFTER DELETE
BEGIN AS
END
GO


-- 9) Hacer un trigger que al ingresar una colaboración no permita que el colaborador/a superponga las fechas con las de otras colaboraciones que se les hayan asignado anteriormente. En caso contrario, registrar la colaboración sino generar un error con un mensaje aclaratorio.

-- 10) Hacer un trigger que al modificar el precio hora base de un tipo de tarea registre en una tabla llamada HistorialPreciosTiposTarea el ID, el precio antes de modificarse y la fecha de modificación.
-- NOTA: La tabla debe estar creada previamente. NO crearla dentro del trigger.