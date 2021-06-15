USE modeloparcial1
GO
-- 1. Apellido y nombres de los pacientes cuya cantidad de turnos de 'Proctologia' sea mayor a 2.
SELECT Pac.NOMBRE, Pac.APELLIDO FROM Pacientes Pac
WHERE ( 
    SELECT COUNT(*) FROM TURNOS Tur
    JOIN Medicos Med ON Tur.IDMEDICO = Med.IDMEDICO
    JOIN ESPECIALIDADES Esp on Med.IDESPECIALIDAD = esp.IDESPECIALIDAD
    WHERE Tur.IDPACIENTE = Pac.IDPACIENTE AND Esp.NOMBRE like '%Proctologia%'
) > 2

-- 2. Los apellidos y nombres de los médicos (sin repetir) que hayan demorado en alguno de sus 
-- turnos menos de la duración promedio de turnos.
SELECT DISTINCT Med.NOMBRE, Med.APELLIDO FROM MEDICOS Med
JOIN TURNOS Tur on Tur.IDMEDICO = Med.IDMEDICO
WHERE Tur.DURACION < ( SELECT AVG(TURNOS.DURACION * 1.0) FROM TURNOS )


-- 3. Por cada paciente, el apellido y nombre y la cantidad de turnos realizados en el primer semestre
-- y la cantidad de turnos realizados en el segundo semestre. Indistintamente del año.
SELECT PAC.NOMBRE, PAC.APELLIDO,
(
    SELECT COUNT(*) FROM TURNOS Tur
    WHERE MONTH(Tur.FECHAHORA) <= 6 AND Tur.IDPACIENTE = PAC.IDPACIENTE
) PrimerSemestre,
(
    SELECT COUNT(*) FROM TURNOS Tur
    WHERE MONTH(Tur.FECHAHORA) > 6 AND Tur.IDPACIENTE = PAC.IDPACIENTE
) SegundoSemestre
FROM PACIENTES PAC

-- 4. Los pacientes que se hayan atendido más veces en el año 2000 que en el año 2001 y a su 
-- vez más veces en el año 2001 que en año 2002.
SELECT PAC.NOMBRE, PAC.APELLIDO FROM PACIENTES PAC
WHERE 
(
    SELECT COUNT(*) FROM TURNOS TUR
    WHERE YEAR(TUR.FECHAHORA) = 2000 AND TUR.IDPACIENTE = PAC.IDPACIENTE
) >
(
    SELECT COUNT(*) FROM TURNOS TUR
    WHERE YEAR(TUR.FECHAHORA) = 2001 AND TUR.IDPACIENTE = PAC.IDPACIENTE
) AND
(
    SELECT COUNT(*) FROM TURNOS TUR
    WHERE YEAR(TUR.FECHAHORA) = 2001 AND TUR.IDPACIENTE = PAC.IDPACIENTE
) >
(
    SELECT COUNT(*) FROM TURNOS TUR
    WHERE YEAR(TUR.FECHAHORA) = 2002 AND TUR.IDPACIENTE = PAC.IDPACIENTE
)