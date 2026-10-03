-- ============================================================
-- EduTrack v2 — Auditoría con tablas relacionadas
-- ============================================================

-- ------------------------------------------------------------
-- INNER JOIN
-- ------------------------------------------------------------

-- Q1. Todas las inscripciones: nombre del estudiante, título del curso y % completado
SELECT
    s.name AS student_name,
    c.title AS course_title,
    e.completion_percentage
FROM enrollments e
INNER JOIN students s
    ON e.student_id = s.id
INNER JOIN courses c
    ON e.course_id = c.id;


-- Q2. Estudiantes que han aprobado al menos un curso: nombre, email y curso aprobado
SELECT
    s.name,
    s.email,
    c.title AS passed_course
FROM enrollments e
INNER JOIN students s
    ON e.student_id = s.id
INNER JOIN courses c
    ON e.course_id = c.id
WHERE e.passed = TRUE;


-- Q3. % de completado medio por instructor (mayor a menor)
SELECT
    c.instructor_name,
    ROUND(AVG(e.completion_percentage), 2) AS average_completion
FROM enrollments e
INNER JOIN courses c
    ON e.course_id = c.id
GROUP BY c.instructor_name
ORDER BY average_completion DESC;


-- ------------------------------------------------------------
-- LEFT JOIN (detección de datos faltantes)
-- ------------------------------------------------------------

-- Q4. Estudiantes sin ninguna inscripción
SELECT
    s.id,
    s.name,
    s.email
FROM students s
LEFT JOIN enrollments e
    ON s.id = e.student_id
WHERE e.id IS NULL;


-- Q5. Cursos sin ninguna inscripción
SELECT
    c.id,
    c.title
FROM courses c
LEFT JOIN enrollments e
    ON c.id = e.course_id
WHERE e.id IS NULL;


-- ------------------------------------------------------------
-- AGREGACIÓN ENTRE TABLAS
-- ------------------------------------------------------------

-- Q6. Estudiantes inscritos en más de un curso (con número de cursos)
SELECT
    s.name,
    COUNT(e.id) AS total_courses
FROM students s
INNER JOIN enrollments e
    ON s.id = e.student_id
GROUP BY s.id, s.name
HAVING COUNT(e.id) > 1
ORDER BY total_courses DESC, s.name;


-- Q7. Ingresos totales por categoría usando courses.monthly_fee
SELECT
    c.category,
    SUM(c.monthly_fee) AS total_income
FROM enrollments e
INNER JOIN courses c
    ON e.course_id = c.id
GROUP BY c.category
ORDER BY total_income DESC;


-- Q8. Cada instructor con el número de estudiantes inscritos en sus cursos
SELECT
    c.instructor_name,
    COUNT(DISTINCT e.student_id) AS total_students
FROM courses c
INNER JOIN enrollments e
    ON c.id = e.course_id
GROUP BY c.instructor_name
ORDER BY total_students DESC, c.instructor_name;


-- ------------------------------------------------------------
-- INTEGRIDAD DE DATOS
-- ------------------------------------------------------------

-- Q9. Inscripciones con student_id huérfano (sin estudiante existente)
SELECT
    e.id,
    e.student_id
FROM enrollments e
LEFT JOIN students s
    ON e.student_id = s.id
WHERE s.id IS NULL;


-- Q10. Inscripciones con course_id huérfano (sin curso existente)
SELECT
    e.id,
    e.course_id
FROM enrollments e
LEFT JOIN courses c
    ON e.course_id = c.id
WHERE c.id IS NULL;
