-- ===============================================================
-- SCRIPT DE ESTRATEGIA DE INDICES PARA OPTIMIZACION DE CONSULTAS
-- ===============================================================

-- =============================================================
-- CONSULTA 1: Ranking de libros más prestados
-- =============================================================
CREATE INDEX IX_EjemplarLibro
    ON catalogo.ejemplar (id_libro);

CREATE INDEX IX_PrestamoEjemplar
    ON prestamos.prestamo_ejemplar (id_ejemplar);

-- =============================================================
-- CONSULTA 2: Mes con más préstamos
-- =============================================================
CREATE INDEX IX_PrestamoFecha
    ON prestamos.prestamo (fecha_prestamo);

-- =============================================================
-- CONSULTA 3: Socios con multas sobre el promedio de pendientes
-- =============================================================
CREATE INDEX IX_PrestamoSocio
    ON prestamos.prestamo (id_socio)
    INCLUDE (estado);                  

CREATE INDEX IX_MultaPrestamo
    ON socios.multa (id_prestamo)
    INCLUDE (monto, estado);

CREATE INDEX IX_MultaEstado
    ON socios.multa (estado)
    INCLUDE (monto);

-- ============================================================
-- CONSULTA 4: Top 3 de libros más prestados por género
-- (Reutiliza IX_EjemplarLibro e IX_PrestamoEjemplar de consulta 1)
-- ============================================================

-- Acceso partiendo del género: encuentra los libros de cada género
CREATE INDEX IX_LibroGeneroPorGenero
    ON catalogo.libro_genero (id_genero, id_libro);

-- Acceso partiendo del libro: encuentra los géneros de cada libro
CREATE INDEX IX_LibroGeneroPorLibro
    ON catalogo.libro_genero (id_libro, id_genero);

-- ============================================================
-- CONSULTA 5: Total mensual, mes anterior y acumulado anual
-- (reutiliza IX_prestamo_fecha de la consulta 2)
-- ============================================================

-- ============================================================
-- CONSULTA 6: Clasificación de socios
-- (reutiliza IX_prestamo_socio de la consulta 3)
-- ============================================================

-- ============================================================
-- CONSULTA 7: Préstamos por empleado y estado (PIVOT)
-- ============================================================
CREATE INDEX IX_PrestamoEmpleado
    ON prestamos.prestamo (id_empleado)
    INCLUDE (estado);

-- ============================================================
-- CONSULTA 8: Despivotar el resultado anterior
-- (reutiliza IX_prestamo_empleado de la consulta 7)
-- ============================================================
