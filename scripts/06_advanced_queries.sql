-- --------------------------------------
-- 1-) Rankear los libros mas prestados
-- --------------------------------------
with ConteoPrestamos as (
    select 
        l.id_libro as LibroID,
        l.nombre as Libro,
        count(pe.id_ejemplar) as TotalPrestamos
    from catalogo.libro l
    inner join catalogo.ejemplar e on l.id_libro = e.id_libro
    inner join prestamos.prestamo_ejemplar pe on e.id_ejemplar = pe.id_ejemplar
    group by l.id_libro, l.nombre
)
select 
    LibroID,
    Libro,
    TotalPrestamos,
    rank() over (order by TotalPrestamos desc) as PosicionRanking
from ConteoPrestamos
order by PosicionRanking asc;

-- -----------------------------------------------
-- 2. El mes en el que mas se ha prestado libros 
-- -----------------------------------------------
with PrestamosPorMes as (
    select 
        year(p.fecha_prestamo) as Anio,
        month(p.fecha_prestamo) as MesNumero,
        datename(month, p.fecha_prestamo) as MesNombre,
        count(p.id_prestamo) as TotalPrestamos
    from prestamos.prestamo p
    group by year(p.fecha_prestamo), month(p.fecha_prestamo), datename(month, p.fecha_prestamo)
)
select top 1
    Anio,
    MesNombre as MesPico,
    TotalPrestamos
from PrestamosPorMes
where TotalPrestamos = 
(
    select max(TotalPrestamos) 
    from PrestamosPorMes
)
order by Anio desc;

-- -------------------------------------------------------------------------------
-- 3-) Identificar socios con multas que superan el promedio de multas pendientes
-- -------------------------------------------------------------------------------
select 
    s.id_socio,
    s.nombre + ' ' + s.apellido as socio,
    m.id_multa,
    m.monto,
    m.estado as estado_multa
from socios.socio s
inner join prestamos.prestamo p on s.id_socio = p.id_socio
inner join socios.multa m on p.id_prestamo = m.id_prestamo
where m.monto > (
    select avg(m2.monto)
    from socios.multa m2
    where m2.estado = 'PENDIENTE'
);

-- --------------------------------------------------------------
-- 4-) Obtener el top 3 de libros más prestados por cada genero.
-- --------------------------------------------------------------
with librosPrestados as (
    select 
        g.nombre as genero,
        l.nombre as libro,
        count(pe.id_ejemplar) as total_prestamos,
        dense_rank() over (
            partition by g.id_genero 
            order by count(pe.id_ejemplar) desc
        ) as ranking_genero
    from catalogo.libro l
    inner join catalogo.libro_genero lg on l.id_libro = lg.id_libro
    inner join catalogo.genero g on lg.id_genero = g.id_genero
    inner join catalogo.ejemplar e on l.id_libro = e.id_libro
    inner join prestamos.prestamo_ejemplar pe on e.id_ejemplar = pe.id_ejemplar
    group by g.id_genero, g.nombre, l.id_libro, l.nombre
)
select 
    genero,
    libro,
    total_prestamos,
    ranking_genero
from librosprestados
where ranking_genero <= 3;

-- ---------------------------------------------------------------------------------
-- 5-) Calcular el total mensual de préstamos, el mes anterior y el acumulado anual
-- ---------------------------------------------------------------------------------
with prestamosMensuales as (
    select 
        year(p.fecha_prestamo) as anio,
        month(p.fecha_prestamo) as mes,
        count(p.id_prestamo) as total_prestamos
    from prestamos.prestamo p
    group by year(p.fecha_prestamo), month(p.fecha_prestamo)
)
select 
    anio,
    mes,
    total_prestamos,
    lag(total_prestamos, 1, 0) over (
        order by anio, mes
    ) as prestamos_mes_anterior,
    sum(total_prestamos) over (
        partition by anio 
        order by mes 
    ) as acumuladoAnual
from prestamosMensuales;

-- ----------------------------------------------------------------------------
-- 6-) Clasificacion de los socios según su historial de préstamos.
-- ----------------------------------------------------------------------------
with Socios as (
    select 
        s.id_socio,
        s.nombre + ' ' + s.apellido as nombre_completo,
        count(p.id_prestamo) as total_historico,
        sum(case when p.estado = 'ACTIVO' then 1 else 0 end) as prestamos_activos,
        sum(case when p.estado = 'ATRASADO' then 1 else 0 end) as prestamos_atrasados
    from socios.socio s
    left join prestamos.prestamo p on s.id_socio = p.id_socio
    group by s.id_socio, s.nombre, s.apellido
)
select 
    id_socio,
    nombre_completo,
    total_historico,
    prestamos_activos,
    prestamos_atrasados,
    case 
        when prestamos_atrasados > 0 then 'En Riesgo'
        when total_historico >= 10 then 'Socio Frecuente'
        when total_historico between 1 and 9 then 'Socio Ocasional'
        else 'Inactivo'
    end as clasificacion_socio
from Socios;

-- --------------------------------------------------------------------------------
-- 7-) Resumen de la cantidad de prestamos procesados por empleado según su estado
-- --------------------------------------------------------------------------------
with PrestamosEmpleados as (
    select 
        e.nombre + ' ' + e.apellido as Empleado,
        p.id_prestamo as PrestamoID,
        p.estado as Estado
    from rrhh.empleado e 
    inner join prestamos.prestamo p on e.id_empleado = p.id_empleado
)
select 
    Empleado,
    isnull([ACTIVO], 0) as Activos,
    isnull([DEVUELTO], 0) as Devueltos,
    isnull([ATRASADO], 0) as Atrasados,
    -- Suma horizontal de los tres estados para el TotalPrestamos
    (isnull([ACTIVO], 0) + isnull([DEVUELTO], 0) + isnull([ATRASADO], 0)) as TotalPrestamos
from PrestamosEmpleados
pivot (
    count(PrestamoID)
    for Estado in ([ACTIVO], [DEVUELTO], [ATRASADO])
) as TablaPivoteada
order by TotalPrestamos desc;

-- ---------------------------------------------------------------------------------
-- 8-) Despivotar el resultado anterior para transformar columnas de estado en filas
-- ---------------------------------------------------------------------------------
with RegistrosPivotados as (
    select 
        e.nombre + ' ' + e.apellido as Empleado,
        p.id_prestamo as PrestamoID,
        p.estado as Estado
    from rrhh.empleado e 
    inner join prestamos.prestamo p on e.id_empleado = p.id_empleado
),
DatosPivoteados as (
    select 
        Empleado,
        isnull([ACTIVO], 0) as Activos,
        isnull([DEVUELTO], 0) as Devueltos,
        isnull([ATRASADO], 0) as Atrasados
    from RegistrosPivotados
    pivot (
        count(PrestamoID)
        for Estado in ([ACTIVO], [DEVUELTO], [ATRASADO])
    ) as TablaPivoteada
)
select 
    Empleado,
    TipoEstado,
    CantidadPrestamos
from DatosPivoteados
unpivot (
    CantidadPrestamos for TipoEstado in (
        Activos, 
        Devueltos, 
        Atrasados
    )
) as DatosDespivotados;