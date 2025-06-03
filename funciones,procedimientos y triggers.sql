use escuela_cocina; 
--funciones y procedimientos 
-- registrar asistencia
DELIMITER //
CREATE PROCEDURE registrar_asistencia(
    IN p_id_estudiante INT,
    IN p_id_clase INT,
    IN p_asistio BOOLEAN
)
BEGIN
    INSERT INTO asistencias (id_estudiante, id_clase, asistio)
    VALUES (p_id_estudiante, p_id_clase, p_asistio);
END //
DELIMITER ;

-- matricular estudiantes en un curso 
DELIMITER //
CREATE PROCEDURE matricular_estudiante(
    IN p_id_estudiante INT,
    IN p_id_curso INT,
    IN p_fecha DATE
)
BEGIN
    INSERT INTO matriculas (id_estudiante, id_curso, fecha_matricula, nota_final)
    VALUES (p_id_estudiante, p_id_curso, p_fecha, NULL);
END //
DELIMITER ;


-- generar resumen de asistencia de un estudiante 
DELIMITER //
CREATE PROCEDURE resumen_asistencia_estudiante(
    IN p_id_estudiante INT
)
BEGIN
    SELECT e.nombre, c.nombre_curso, COUNT(a.id_asistencia) AS clases_totales,
           SUM(a.asistio) AS clases_asistidas
    FROM asistencias a
    JOIN clases cl ON a.id_clase = cl.id_clase
    JOIN cursos c ON cl.id_curso = c.id_curso
    JOIN estudiantes e ON a.id_estudiante = e.id_estudiante
    WHERE a.id_estudiante = p_id_estudiante
    GROUP BY c.nombre_curso;
END //
DELIMITER ;


-- calcular edad de estudiantes 
DELIMITER //
CREATE FUNCTION calcular_edad(fecha_nac DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());
END //
DELIMITER ;

 
-- verificar si un estudiante aprueba (nota >= 6)
DELIMITER //
CREATE FUNCTION estado_aprobacion(nota DECIMAL(4,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF nota >= 6.0 THEN
        RETURN 'Aprobado';
    ELSE
        RETURN 'Reprobado';
    END IF;
END //
DELIMITER ;

-- triggers 
-- evitar pagos duplicados por el mismo alumnado el mismo dia 
DELIMITER //
CREATE TRIGGER trg_prevenir_pago_duplicado
BEFORE INSERT ON Pagos
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM Pagos
    WHERE alumno_id = alumno_id AND fecha_pago = fecha_pago
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El alumno ya ha registrado un pago en esta fecha.';
  END IF;
END;
//
DELIMITER ;

-- registrar historial de cambio de profesor 
CREATE TABLE IF NOT EXISTS historial_profesores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  profesor_id INT,
  nombre_anterior VARCHAR(100),
  nombre_nuevo VARCHAR(100),
  fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //
CREATE TRIGGER trg_historial_nombre_profesor
AFTER UPDATE ON Profesores
FOR EACH ROW
BEGIN
  IF OLD.nombre <> nombre THEN
    INSERT INTO historial_profesores (profesor_id, nombre_anterior, nombre_nuevo)
    VALUES (id, nombre, nombre);
  END IF;
END;
//
DELIMITER ;

-- validar que no se creen horarios en el pasado
DELIMITER //
CREATE TRIGGER trg_prevenir_horario_pasado
BEFORE INSERT ON Horario
FOR EACH ROW
BEGIN
  IF fecha < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede asignar un horario en una fecha pasada.';
  END IF;
END;
//
DELIMITER ;

-- Auditar entregas de practicas 
CREATE TABLE IF NOT EXISTS auditoria_practicas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  practica_id INT,
  estado_anterior VARCHAR(50),
  estado_nuevo VARCHAR(50),
  fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_auditar_estado_practica
AFTER UPDATE ON Practicas
FOR EACH ROW
BEGIN
  IF estado <> estado THEN
    INSERT INTO auditoria_practicas (practica_id, estado_anterior, estado_nuevo)
    VALUES (id, estado, estado);
  END IF;
END;
//
DELIMITER ;




