Insert into carreras(id, creacion, nombre, mail, nivel) 
values('TSP', '2000/1/1', 'Tecnico superior en programación','tsp@frgp.com.ar', 'Diplomatura')
GO

Insert into materias(idCarrera, nombre, cargaHoraria)
values('TSP', 'Laboratorio 3', 5)
GO

Insert into alumnos(idCarrera, nombre, apellido, nacimiento, email, telefono)
values('TSP' ,'Isidoro', 'Arostegui', '1997/12/30', 'arostegui.isidoro@gmail.com', 1156592131)
GO
