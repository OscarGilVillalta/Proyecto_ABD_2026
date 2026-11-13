-- ================================================================
-- SCRIPT DE MODIFICACION DE CONSULTAS PARA VISTAS EN POWER BI
-- ================================================================

-- ============================================================
-- Vista: Tendencia Mensual
-- ============================================================
CREATE OR ALTER VIEW vw_TendenciaMensual AS
WITH prestamosMensuales AS (
    SELECT 
        YEAR(p.fecha_prestamo) AS Anio,
        MONTH(p.fecha_prestamo) AS [Número de mes calendario],
        COUNT(p.id_prestamo) AS [Cantidad de Prestamos]
    FROM prestamos.prestamo p
    GROUP BY YEAR(p.fecha_prestamo), MONTH(p.fecha_prestamo)
)
SELECT 
    Anio,
    [Número de mes calendario],
    [Cantidad de Prestamos],
    SUM([Cantidad de Prestamos]) OVER (
        PARTITION BY Anio 
        ORDER BY [Número de mes calendario]
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Acumulado Anual]
FROM prestamosMensuales;
GO

-- ============================================================
-- Vista: Tendencia y Acumulado Mensual
-- ============================================================
CREATE OR ALTER VIEW vw_TendenciaYAcumuladoMensual AS
WITH prestamosMensuales AS (
    SELECT 
        YEAR(p.fecha_prestamo) AS anio,
        MONTH(p.fecha_prestamo) AS mes,
        COUNT(p.id_prestamo) AS total_prestamos
    FROM prestamos.prestamo p
    GROUP BY YEAR(p.fecha_prestamo), MONTH(p.fecha_prestamo)
)
SELECT 
    anio,
    mes,
    total_prestamos,
    LAG(total_prestamos, 1, 0) OVER (ORDER BY anio, mes) AS prestamos_mes_anterior,
    SUM(total_prestamos) OVER (PARTITION BY anio ORDER BY mes) AS acumuladoAnual
FROM prestamosMensuales;
GO

-- ============================================================
-- Vista: Top 3 de libros más prestados por género
-- ============================================================
CREATE OR ALTER VIEW vw_Top3LibrosPorGenero AS
WITH librosPrestados AS (
    SELECT 
        g.nombre AS genero,
        l.nombre AS libro,
        COUNT(pe.id_ejemplar) AS total_prestamos,
        DENSE_RANK() OVER (
            PARTITION BY g.id_genero 
            ORDER BY COUNT(pe.id_ejemplar) DESC
        ) AS ranking_genero
    FROM catalogo.libro l
    INNER JOIN catalogo.libro_genero lg ON l.id_libro = lg.id_libro
    INNER JOIN catalogo.genero g ON lg.id_genero = g.id_genero
    INNER JOIN catalogo.ejemplar e ON l.id_libro = e.id_libro
    INNER JOIN prestamos.prestamo_ejemplar pe ON e.id_ejemplar = pe.id_ejemplar
    GROUP BY g.id_genero, g.nombre, l.id_libro, l.nombre
)
SELECT 
    genero,
    libro,
    total_prestamos,
    ranking_genero
FROM librosPrestados
WHERE ranking_genero <= 3;
GO

-- ============================================================
-- Vista: Clasificación de socios según historial
-- ============================================================
CREATE OR ALTER VIEW vw_ClasificacionSocios AS
WITH Socios AS (
    SELECT 
        s.id_socio,
        s.nombre + ' ' + s.apellido AS nombre_completo,
        COUNT(p.id_prestamo) AS total_historico,
        SUM(CASE WHEN p.estado = 'ACTIVO' THEN 1 ELSE 0 END) AS prestamos_activos,
        SUM(CASE WHEN p.estado = 'ATRASADO' THEN 1 ELSE 0 END) AS prestamos_atrasados
    FROM socios.socio s
    LEFT JOIN prestamos.prestamo p ON s.id_socio = p.id_socio
    GROUP BY s.id_socio, s.nombre, s.apellido
)
SELECT 
    id_socio,
    nombre_completo,
    total_historico,
    prestamos_activos,
    prestamos_atrasados,
    CASE 
        WHEN prestamos_atrasados > 0 THEN 'En Riesgo'
        WHEN total_historico >= 10 THEN 'Socio Frecuente'
        WHEN total_historico BETWEEN 1 AND 9 THEN 'Socio Ocasional'
        ELSE 'Inactivo'
    END AS clasificacion_socio
FROM Socios;

-- ============================================================
-- Vista: Préstamos procesados por empleado (PIVOT)
-- ============================================================
CREATE OR ALTER VIEW vw_PrestamosPorEmpleadoPivot AS
WITH PrestamosEmpleados AS (
    SELECT 
        e.nombre + ' ' + e.apellido AS Empleado,
        p.id_prestamo AS PrestamoID,
        p.estado AS Estado
    FROM rrhh.empleado e 
    INNER JOIN prestamos.prestamo p ON e.id_empleado = p.id_empleado
)
SELECT 
    Empleado,
    ISNULL([ACTIVO], 0) AS Activos,
    ISNULL([DEVUELTO], 0) AS Devueltos,
    ISNULL([ATRASADO], 0) AS Atrasados,
    (ISNULL([ACTIVO], 0) + ISNULL([DEVUELTO], 0) + ISNULL([ATRASADO], 0)) AS TotalPrestamos
FROM PrestamosEmpleados
PIVOT (
    COUNT(PrestamoID)
    FOR Estado IN ([ACTIVO], [DEVUELTO], [ATRASADO])
) AS TablaPivoteada;

