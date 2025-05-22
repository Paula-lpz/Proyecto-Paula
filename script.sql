-- creación de la base de datos 
drop database if exists escuela_cocina; 
create database if not exists escuela_cocina; 

use escuela_cocina; 

-- creacion de tablas 

create table Alumnos(
id_alumnos int primary key auto_increment, 
Nombre varchar(100), 
Apellidos varchar(100), 
Email varchar(100), 
Telefono varchar(100), 
Direccion varchar(100), 
Fecha_registro date
); 

create table  Profesores(
id_profesores int primary key auto_increment, 
id_curso int ,
Nombre varchar(100), 
Apellidos varchar(100), 
Email varchar(100), 
Telefono varchar(100), 
Direccion varchar(100), 
Fecha_registro date,
FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
); 


create table aulas(
id_aula int primary key auto_increment, 
nombre_cocina varchar(100), 
capacidad int, 
estado varchar(100), 
equipamiento varchar(100)
); 

create table Cursos(
id_curso int primary key auto_increment,
id_aula int,
descripcion varchar(100),
duracion time, 
precio decimal(10,2),
nivel varchar(10),
capacidad_maxima int, 
nombre_curso varchar(100),
FOREIGN KEY (id_aula) REFERENCES aulas(id_aula)
); 

create table Horario(
id_horario int primary key auto_increment,
id_profesores int,
dia_semana date,
hora_inicio time, 
hora_fin time,
cocina_asignada varchar(100),
FOREIGN KEY (id_profesores) REFERENCES Profesores(id_profesores)
); 

create table Materiales(
id_materiales int primary key auto_increment, 
nombre varchar(100),
descripcion varchar(100), 
stock varchar(10),
estado varchar(100)
); 

create table Materiales_curso(
id_materiales int, 
id_curso int, 
FOREIGN KEY (id_materiales) REFERENCES Materiales(id_materiales),
FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
); 

create table Pagos(
id_pagos int primary key auto_increment, 
id_alumnos int, 
fecha_inscripcion date, 
estado_pago varchar(100), 
monto_pagado varchar(100),
FOREIGN KEY (id_alumnos) REFERENCES Alumnos(id_alumnos)
); 

create table Practicas(
id_practicas int primary key auto_increment, 
id_alumnos int,
fecha_inicio varchar(100), 
fecha_fin varchar(100), 
estado varchar (100),
observaciones varchar (100),
FOREIGN KEY (id_alumnos) REFERENCES Alumnos(id_alumnos)
); 
 
 DROP TABLE Profesores;

 

