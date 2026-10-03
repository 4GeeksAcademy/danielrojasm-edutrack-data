# Informe de Auditoría — EduTrack `enrollments` (Q3)

**Autor:** Daniel Rojas Montañez
**Fuente:** base de datos importada desde `edutrack.sql` en Supabase
**Consultas:** ver `queries.sql`

---

# Lectura y filtrado

## 1. Inscripciones en 'Intro to Python'

Resultado: 5

| student_name | student_email | completion_percentage |
|---|---|---|
| Emily Watson | emily.watson@student.edutrack.com | 85 |
| Klaus Weber | klaus.weber@student.edutrack.com | 92 |
| Marco Rossi | marco.rossi@student.edutrack.com | 88 |
| James Miller | james.miller@test.com | 30 |
| Priya Sharma | priya.sharma@student.edutrack.com | 55 |

## 2. Posibles abandonos (completion_percentage < 10)

Resultado: 4

| id | student_id | student_name | student_email | course_id | course_title | category | enrollment_date | completion_percentage | passed | monthly_fee_paid | instructor |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 3 | Lucia Fernandes | lucia.fernandes@student.edutrack.com | 2 | Web Design Basics | Design | 2024-06-20 | 5 | false | 39.99 | Carlos Vega |
| 6 | 3 | Lucia Fernandes | lucia.fernandes@student.edutrack.com | 4 | Digital Marketing 101 | Marketing | 2024-07-01 | 3 | false | 29.99 | Lucia Prades |
| 10 | 5 | Yuki Nakamura | yuki.nakamura@student.edutrack.com | 6 | UI/UX Fundamentals | Design | 2024-10-11 | 0 | false | 44.99 | null |
| 11 | 6 | Pierre Dubois | pierre.dubois@student.edutrack.com | 6 | UI/UX Fundamentals | Design | 2024-11-05 | 0 | false | 44.99 | null |

## 3. Inscripciones sin instructor (instructor IS NULL)

Resultado: 2

| id | student_id | student_name | student_email | course_id | course_title | category | enrollment_date | completion_percentage | passed | monthly_fee_paid | instructor |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 10 | 5 | Yuki Nakamura | yuki.nakamura@student.edutrack.com | 6 | UI/UX Fundamentals | Design | 2024-10-11 | 0 | false | 44.99 | null |
| 11 | 6 | Pierre Dubois | pierre.dubois@student.edutrack.com | 6 | UI/UX Fundamentals | Design | 2024-11-05 | 0 | false | 44.99 | null |

## 4. Top 5 con mayor progreso que aún no han aprobado (passed = false)

Resultado:

| student_name | course_title | completion_percentage |
|---|---|---|
| Emily Watson | Web Design Basics | 60 |
| Priya Sharma | Intro to Python | 55 |
| Yuki Nakamura | Data Analysis with SQL | 45 |
| Emily Watson | Advanced Python | 40 |
| James Miller | Intro to Python | 30 |

## 5. Inscripciones del último año (enrollment_date DESC)

Resultado: 0

La consulta no devuelve filas. La inscripción más reciente de la tabla es del 2025-03-05, más de un año antes de la fecha de ejecución, así que no hay inscripciones registradas en los últimos 12 meses.

---

# Corrección de datos

## 6. INSERT — inscripción faltante

Resultado: 1 fila insertada (Supabase: `Success. No rows returned`)

Registro añadido:

| id | student_id | student_name | student_email | course_id | course_title | category | enrollment_date | completion_percentage | passed | monthly_fee_paid | instructor |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 18 | 3 | Lucia Fernandes | lucia.fernandes@student.edutrack.com | 5 | Advanced Python | Programming | 2025-04-01 | 0 | false | 69.99 | Carlos Vega |

## 7. UPDATE — instructor NULL → 'Pending assignment'

Resultado: 2 filas actualizadas (Supabase: `Success. No rows returned`)

Registros actualizados:

| id | student_id | student_name | student_email | course_id | course_title | category | enrollment_date | completion_percentage | passed | monthly_fee_paid | instructor |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 10 | 5 | Yuki Nakamura | yuki.nakamura@student.edutrack.com | 6 | UI/UX Fundamentals | Design | 2024-10-11 | 0 | false | 44.99 | Pending assignment |
| 11 | 6 | Pierre Dubois | pierre.dubois@student.edutrack.com | 6 | UI/UX Fundamentals | Design | 2024-11-05 | 0 | false | 44.99 | Pending assignment |

## 8. DELETE — cuentas de prueba `@test.com`

SELECT previo de verificación (filas a eliminar):

| id | student_id | student_name | student_email | course_id | course_title | category | enrollment_date | completion_percentage | passed | monthly_fee_paid | instructor |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 13 | 8 | James Miller | james.miller@test.com | 1 | Intro to Python | Programming | 2024-05-22 | 30 | false | 49.99 | Marta López |
| 14 | 9 | Alex Chen | alex.chen@test.com | 2 | Web Design Basics | Design | 2024-06-30 | 10 | false | 39.99 | Carlos Vega |

Resultado: 2 filas eliminadas (Supabase: `Success. No rows returned`)

---

# Agregación e informe

## 9. Inscripciones por categoría

Resultado:

| category | total_enrollments |
|---|---|
| Marketing | 2 |
| Programming | 7 |
| Design | 4 |
| Data | 3 |

Total: 16 inscripciones (17 originales + 1 insertada − 2 eliminadas).

## 10. Promedio de completado por curso (menor a mayor)

Resultado:

| course_title | average_completion |
|---|---|
| UI/UX Fundamentals | 0.00 |
| Web Design Basics | 32.50 |
| Digital Marketing 101 | 36.50 |
| Advanced Python | 45.00 |
| Data Analysis with SQL | 47.67 |
| Intro to Python | 80.00 |

## 11. Cursos con más de 3 inscripciones (HAVING)

Resultado: 1

| course_title | total_enrollments |
|---|---|
| Intro to Python | 4 |

## 12. Ingresos totales por categoría (mayor a menor)

Resultado:

| category | total_revenue |
|---|---|
| Programming | 409.93 |
| Data | 179.97 |
| Design | 169.96 |
| Marketing | 59.98 |

Total: 819.84

---

# Conclusiones

**Rendimiento por categoría** (después de la limpieza):

| Categoría | Inscripciones | Ingresos | % completado promedio | Aprobados |
|---|---|---|---|---|
| Programming | 7 | 409.93 | 65.00 | 4 de 7 |
| Data | 3 | 179.97 | 47.67 | 1 de 3 |
| Marketing | 2 | 59.98 | 36.50 | 1 de 2 |
| Design | 4 | 169.96 | 16.25 | 0 de 4 |

1. **Design es la categoría con peor rendimiento.** Tiene el promedio de completado más bajo (16.25 %) y ningún aprobado. La mitad de sus inscripciones son de UI/UX Fundamentals, un curso con 0 % de progreso y sin instructor asignado. Recomendación: asignar un instructor a UI/UX Fundamentals cuanto antes.
2. **Marketing es la segunda categoría más débil.** Tiene los ingresos más bajos (59.98) y solo 2 inscripciones, una de ellas con un 3 % de progreso.
3. **Programming es la categoría más fuerte.** Genera la mitad de los ingresos (409.93 de 819.84) y tiene el mejor promedio de completado. Intro to Python es el único curso con más de 3 inscripciones y tiene un 80 % de completado promedio.
4. **Estudiantes en riesgo de abandono.** Lucia Fernandes tiene tres inscripciones con un progreso del 5 % o menos (incluida la nueva, en Advanced Python). Yuki Nakamura y Pierre Dubois están en 0 % en UI/UX Fundamentals. Recomendación: contactarlos para hacer seguimiento.
5. **Calidad de datos.** Se encontraron 2 cuentas de prueba mezcladas con datos reales, 2 inscripciones sin instructor y 1 inscripción confirmada que nunca se registró. Recomendación: validar el email y el instructor en cada canal de alta (formulario web, equipo de ventas e integración con el partner).
6. **No hay inscripciones en los últimos 12 meses** (consulta 5). Antes de empezar el ciclo de reportes del Q3, conviene confirmar si las inscripciones recientes se están registrando en otro sistema.
