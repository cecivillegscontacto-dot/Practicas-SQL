-- ═══════════════════════════════════════════════════════════════════════════
-- RetailPro — Pre-entrega: Consultas con JOINs y UNIONs (Módulo 5)
-- Archivo: m5_consultas_joins.sql
-- Descripción: Cruzamiento de tablas para vista enriquecida de Power BI
-- Autor: Cecilia Villegas
-- Fecha: 2026-07-22
-- ═══════════════════════════════════════════════════════════════════════════

-- Aseguramos el uso de la base de datos de trabajo
-- USE Ventas_Tech_DB;


-- ───────────────────────────────────────────────────────────────────────────
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Combina la tabla de hechos (ventas) con todas sus tablas de dimensión
-- para consolidar una sola vista detallada ideal como modelo plano/Power BI.
-- ───────────────────────────────────────────────────────────────────────────

SELECT 
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    c.ciudad AS region,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    'Online' AS canal  -- Asignación de canal para el modelo de datos
FROM ventas v
INNER JOIN clientes c 
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p 
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat 
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta ASC;


-- ───────────────────────────────────────────────────────────────────────────
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Identifica aquellos clientes registrados en el sistema pero que aún no han 
-- ejecutado ninguna transacción comercial (Oportunidad de campaña de CRM).
-- ───────────────────────────────────────────────────────────────────────────

SELECT 
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v 
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- ───────────────────────────────────────────────────────────────────────────
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Identifica productos del catálogo que no registran movimiento de stock.
-- ───────────────────────────────────────────────────────────────────────────

SELECT 
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat 
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v 
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


-- ───────────────────────────────────────────────────────────────────────────
-- CONSULTA 4: Consolidado por canal (UNION ALL + GROUP BY)
-- Consolida transacciones simuladas de canal 'Online' y 'Presencial',
-- y calcula el total facturado sumergido en una subconsulta/CTE agrupada.
-- ───────────────────────────────────────────────────────────────────────────

WITH ventas_consolidadas AS (
    -- Subconsulta 1: Canal Online
    SELECT 
        id_venta,
        cantidad,
        precio_unitario,
        'Online' AS canal
    FROM ventas

    UNION ALL

    -- Subconsulta 2: Canal Presencial (Estructura espejo)
    SELECT 
        id_venta,
        cantidad,
        precio_unitario,
        'Presencial' AS canal
    FROM ventas
)
SELECT 
    canal,
    COUNT(id_venta) AS cantidad_transacciones,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas_consolidadas
GROUP BY canal;


-- ═══════════════════════════════════════════════════════════════════════════
-- BLOQUE DE CIERRE: Hallazgos Clave
-- ═══════════════════════════════════════════════════════════════════════════
/*
  HALLAZGOS DE INTEGRACIÓN DE DATOS:

  1. Cobertura del catálogo activo:
     Mediante el uso de LEFT JOIN se identificó que no todos los productos del 
     catálogo han sido comercializados, lo cual permite al área de producto decidir 
     si aplicar promociones o descontinuar ítems sin rotación.

  2. Clientes inactivos para remarketing:
     La Query 2 permite al equipo de CRM aislar exactamente la lista de usuarios
     registrados sin transacciones (WHERE v.id_venta IS NULL) para ejecutar campañas
     de reactivación con cupones de primera compra.

  3. Unificación fluida de fuentes con UNION ALL:
     El agrupamiento por canal confirma que UNION ALL preserva la totalidad de los 
     registros para consolidar la facturación global sin omitir filas duplicadas legítimas.
*/
