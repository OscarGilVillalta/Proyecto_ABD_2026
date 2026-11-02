-- ==========================================================
-- TRIGGERS DE LA BIBLIOTECA
-- ==========================================================

CREATE TRIGGER prestamos.tg_generar_multa_por_retraso
ON prestamos.prestamo
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO socios.multa
    (
        fecha_multa,
        estado,
        monto,
        id_prestamo
    )
    SELECT
        CAST(GETDATE() AS DATE),
        'PENDIENTE',
        DATEDIFF(DAY, d.fecha_limite, i.fecha_devolucion) * 2.50,
        i.id_prestamo
    FROM inserted i
    INNER JOIN deleted d
        ON i.id_prestamo = d.id_prestamo
    WHERE i.fecha_devolucion IS NOT NULL
        AND CAST(i.fecha_devolucion AS DATE) > d.fecha_limite
        AND d.fecha_devolucion IS NULL;
END;
GO

-- ==========================================================
-- PROCEDIMIENTOS DE LA BIBLIOTECA
-- ==========================================================

CREATE OR ALTER PROCEDURE operaciones.sp_procesar_prestamo
    @p_id_socio INT,
    @p_id_empleado INT,
    @p_id_ejemplar INT,
    @p_fecha_limite DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_estado_ejemplar VARCHAR(20);
    DECLARE @v_multas_pendientes INT;
    DECLARE @v_prestamos_activos INT;
    DECLARE @v_id_prestamo INT;

    -- 1. Verificar estado del ejemplar
    SELECT @v_estado_ejemplar = estado
    FROM catalogo.ejemplar
    WHERE id_ejemplar = @p_id_ejemplar;

    IF @v_estado_ejemplar IS NULL
    BEGIN;
        THROW 50001, 'El ejemplar no existe', 1;
    END;

    IF @v_estado_ejemplar <> 'LIBRE'
    BEGIN;
        THROW 50002, 'El ejemplar no esta disponible', 1;
    END;

    -- 2. Verificar multas pendientes
    SELECT @v_multas_pendientes = COUNT(*)
    FROM socios.multa m
    INNER JOIN prestamos.prestamo p
        ON m.id_prestamo = p.id_prestamo
    WHERE p.id_socio = @p_id_socio
        AND m.estado = 'PENDIENTE';

    IF @v_multas_pendientes > 0
    BEGIN;
        THROW 50003, 'El socio tiene multas pendientes, prestamo negado', 1;
    END;

    -- 3. Verificar prestamos activos
    SELECT @v_prestamos_activos = COUNT(*)
    FROM prestamos.prestamo
    WHERE id_socio = @p_id_socio
      AND estado = 'ACTIVO';

    IF @v_prestamos_activos >= 3
    BEGIN;
        THROW 50004, 'El socio tiene 3 prestamos activos', 1;
    END;

    -- 4. Registrar prestamo
    INSERT INTO prestamos.prestamo
    (
        fecha_limite,
        estado,
        id_empleado,
        id_socio
    )
    VALUES
    (
        @p_fecha_limite,
        'ACTIVO',
        @p_id_empleado,
        @p_id_socio
    );

    SET @v_id_prestamo = SCOPE_IDENTITY();

    -- 5. Relacionar prestamo con ejemplar
    INSERT INTO prestamos.prestamo_ejemplar
    (
        id_prestamo,
        id_ejemplar
    )
    VALUES
    (
        @v_id_prestamo,
        @p_id_ejemplar
    );

    -- 6. Cambiar estado del ejemplar
    UPDATE catalogo.ejemplar
    SET estado = 'PRESTADO'
    WHERE id_ejemplar = @p_id_ejemplar;

END;
GO