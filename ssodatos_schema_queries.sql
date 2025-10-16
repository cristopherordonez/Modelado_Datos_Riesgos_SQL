-- ##################################################################
-- 1. CREACIÓN DEL ESQUEMA (BASE DE DATOS)
-- ##################################################################

CREATE DATABASE IF NOT EXISTS SSO_Riesgos_DB;
USE SSO_Riesgos_DB;

-- ##################################################################
-- 2. IMPLEMENTACIÓN DEL MODELO DE DATOS NORMALIZADO (3FN)
--    Objetivo: Modelar entidades clave para el análisis de incidentes.
-- ##################################################################

-- Entidad 1: Empleados (Información de la persona, clave para análisis de riesgo)
CREATE TABLE IF NOT EXISTS Empleados (
    empleado_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    fecha_contratacion DATE,
    es_supervisor BOOLEAN DEFAULT FALSE
);

-- Entidad 2: Ubicaciones (Normalizada para evitar redundancia de datos de lugar)
CREATE TABLE IF NOT EXISTS Ubicaciones (
    ubicacion_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_ubicacion VARCHAR(100) NOT NULL UNIQUE,
    ciudad VARCHAR(100),
    pais VARCHAR(100)
);

-- Entidad 3: Tipos_Riesgo (Normalizada para clasificar los riesgos o peligros)
CREATE TABLE IF NOT EXISTS Tipos_Riesgo (
    tipo_riesgo_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_riesgo VARCHAR(100) NOT NULL UNIQUE,
    descripcion_riesgo TEXT
);

-- Entidad 4: Incidentes (Hecho central, contiene FKs a las entidades normalizadas)
CREATE TABLE IF NOT EXISTS Incidentes (
    incidente_id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT NOT NULL,
    ubicacion_id INT NOT NULL,
    fecha_incidente DATETIME NOT NULL,
    severidad ENUM('Baja', 'Media', 'Alta', 'Fatal') NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (empleado_id) REFERENCES Empleados(empleado_id),
    FOREIGN KEY (ubicacion_id) REFERENCES Ubicaciones(ubicacion_id)
);

-- Entidad 5: Incidente_Riesgo (Tabla N:M para relacionar un incidente con múltiples tipos de riesgo)
CREATE TABLE IF NOT EXISTS Incidente_Riesgo (
    incidente_riesgo_id INT PRIMARY KEY AUTO_INCREMENT,
    incidente_id INT NOT NULL,
    tipo_riesgo_id INT NOT NULL,
    FOREIGN KEY (incidente_id) REFERENCES Incidentes(incidente_id),
    FOREIGN KEY (tipo_riesgo_id) REFERENCES Tipos_Riesgo(tipo_riesgo_id),
    UNIQUE KEY unique_incidente_riesgo (incidente_id, tipo_riesgo_id)
);

-- ##################################################################
-- 3. INSERCIÓN DE DATOS DE PRUEBA (DATA DE EJEMPLO)
-- ##################################################################

-- Inserción en Empleados
INSERT INTO Empleados (nombre, cargo, departamento, fecha_contratacion, es_supervisor) VALUES
('Cristopher Ordoñez', 'Técnico de SSO', 'Logística', '2023-01-15', TRUE),
('María García', 'Operario de Bodega', 'Almacén', '2024-03-20', FALSE),
('Javier Pérez', 'Jefe de Mantenimiento', 'Mantenimiento', '2022-11-01', TRUE),
('Luisa Vaca', 'Operario de Bodega', 'Almacén', '2024-05-10', FALSE);

-- Inserción en Ubicaciones
INSERT INTO Ubicaciones (nombre_ubicacion, ciudad, pais) VALUES
('Bodega Principal', 'Guayaquil', 'Ecuador'),
('Planta de Producción', 'Guayaquil', 'Ecuador'),
('Oficinas Administrativas', 'Quito', 'Ecuador');

-- Inserción en Tipos_Riesgo
INSERT INTO Tipos_Riesgo (nombre_riesgo, descripcion_riesgo) VALUES
('Caída a distinto nivel', 'Riesgo por trabajos en altura o andamios.'),
('Golpe por objeto', 'Riesgo de ser golpeado por materiales o maquinaria.'),
('Exposición a químicos', 'Riesgo de contacto o inhalación de sustancias peligrosas.'),
('Ergonómico', 'Riesgo por levantamiento manual de cargas o posturas forzadas.');

-- Inserción en Incidentes
INSERT INTO Incidentes (empleado_id, ubicacion_id, fecha_incidente, severidad, descripcion) VALUES
(2, 1, '2025-09-01 10:30:00', 'Baja', 'Tropezón sin lesión grave al mover una caja.'),
(4, 2, '2025-09-15 14:00:00', 'Media', 'Dolor de espalda por carga excesiva.'),
(3, 2, '2025-10-05 08:00:00', 'Alta', 'Caída desde andamio (fractura de brazo).');

-- Inserción en Incidente_Riesgo (Relaciona Incidentes con Tipos de Riesgo)
INSERT INTO Incidente_Riesgo (incidente_id, tipo_riesgo_id) VALUES
(1, 4), -- Incidente 1 (tropezón) relacionado con Riesgo Ergonómico
(2, 4), -- Incidente 2 (dolor de espalda) relacionado con Riesgo Ergonómico
(3, 1), -- Incidente 3 (caída) relacionado con Caída a distinto nivel
(3, 2); -- Incidente 3 (caída) relacionado con Golpe por objeto


-- ##################################################################
-- 4. CONSULTAS CLAVE PARA ANÁLISIS DE DATOS (DATA ANALYTICS)
-- ##################################################################

-- 4.1. Conteo de Incidentes por Tipo de Riesgo (KPI de Riesgos)
-- Identifica qué tipo de peligro genera más incidentes para priorizar capacitación.
SELECT
    TR.nombre_riesgo,
    COUNT(IR.incidente_id) AS total_incidentes
FROM Tipos_Riesgo TR
JOIN Incidente_Riesgo IR ON TR.tipo_riesgo_id = IR.tipo_riesgo_id
GROUP BY 1
ORDER BY 2 DESC;

-- 4.2. Incidentes por Empleado y Severidad (Análisis de Caso)
-- Permite ver el historial completo de un incidente, uniendo la información normalizada.
SELECT
    E.nombre AS Empleado,
    U.nombre_ubicacion AS Lugar,
    I.fecha_incidente AS Fecha,
    I.severidad AS Severidad,
    I.descripcion AS Detalle
FROM Incidentes I
JOIN Empleados E ON I.empleado_id = E.empleado_id
JOIN Ubicaciones U ON I.ubicacion_id = U.ubicacion_id
ORDER BY I.fecha_incidente DESC;

-- 4.3. Riesgos asociados a incidentes de Severidad 'Alta'
-- Filtra incidentes graves para entender las causas subyacentes.
SELECT DISTINCT
    TR.nombre_riesgo,
    COUNT(I.incidente_id) AS Incidentes_Alta_Severidad
FROM Incidentes I
JOIN Incidente_Riesgo IR ON I.incidente_id = IR.incidente_id
JOIN Tipos_Riesgo TR ON IR.tipo_riesgo_id = TR.tipo_riesgo_id
WHERE I.severidad = 'Alta'
GROUP BY 1;
