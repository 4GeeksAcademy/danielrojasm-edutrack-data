-- ============================================================
-- EduTrack — Auditoría de la tabla enrollments
-- ============================================================

-- ------------------------------------------------------------
-- LECTURA Y FILTRADO
-- ------------------------------------------------------------

-- Q1. Inscripciones en 'Intro to Python' (nombre, email, % completado)
SELECT student_name, student_email, completion_percentage
FROM enrollments
WHERE course_title = 'Intro to Python';


-- Q2. Inscripciones con completion_percentage < 10 (posibles abandonos)
SELECT *
FROM enrollments
WHERE completion_percentage < 10;


-- Q3. Inscripciones con instructor NULL
SELECT *
FROM enrollments
WHERE instructor IS NULL;


-- Q4. Top 5 estudiantes con mayor completion_percentage que NO han aprobado
SELECT
    student_name,
    course_title,
    completion_percentage
FROM enrollments
WHERE passed = FALSE
ORDER BY completion_percentage DESC
LIMIT 5;


-- Q5. Inscripciones del último año, ordenadas por enrollment_date DESC
SELECT *
FROM enrollments
WHERE enrollment_date >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY enrollment_date DESC;


-- ------------------------------------------------------------
-- CORRECCIÓN DE DATOS
-- ------------------------------------------------------------

-- Q6. INSERT del registro faltante (Lucia Fernandes, id = 18)
INSERT INTO enrollments (
    id,
    student_id,
    student_name,
    student_email,
    course_id,
    course_title,
    category,
    enrollment_date,
    completion_percentage,
    passed,
    monthly_fee_paid,
    instructor
)
VALUES (
    18,
    3,
    'Lucia Fernandes',
    'lucia.fernandes@student.edutrack.com',
    5,
    'Advanced Python',
    'Programming',
    '2025-04-01',
    0,
    FALSE,
    69.99,
    'Carlos Vega'
);


-- Q7. UPDATE: instructor NULL -> 'Pending assignment'
--     SELECT previo de verificación
SELECT *
FROM enrollments
WHERE instructor IS NULL;

UPDATE enrollments
SET instructor = 'Pending assignment'
WHERE instructor IS NULL;


-- Q8. DELETE de inscripciones con email @test.com
--     SELECT previo de verificación
SELECT *
FROM enrollments
WHERE student_email LIKE '%@test.com';

DELETE FROM enrollments
WHERE student_email LIKE '%@test.com';


-- ------------------------------------------------------------
-- AGREGACIÓN E INFORME
-- ------------------------------------------------------------

-- Q9. Número de inscripciones por category
SELECT
    category,
    COUNT(*) AS total_enrollments
FROM enrollments
GROUP BY category;


-- Q10. Promedio de completion_percentage por course_title (menor a mayor)
SELECT
    course_title,
    ROUND(AVG(completion_percentage), 2) AS average_completion
FROM enrollments
GROUP BY course_title
ORDER BY average_completion ASC;


-- Q11. Cursos con más de 3 inscripciones (HAVING)
SELECT
    course_title,
    COUNT(*) AS total_enrollments
FROM enrollments
GROUP BY course_title
HAVING COUNT(*) > 3;


-- Q12. Ingresos totales (SUM monthly_fee_paid) por category (mayor a menor)
SELECT
    category,
    SUM(monthly_fee_paid) AS total_revenue
FROM enrollments
GROUP BY category
ORDER BY total_revenue DESC;
