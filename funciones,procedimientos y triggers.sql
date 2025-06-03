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





