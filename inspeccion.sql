-- --------------------------------------------------------
-- Script para Sistema de Inspección (Protección Civil)
-- --------------------------------------------------------

CREATE DATABASE IF NOT EXISTS `inspeccion` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `inspeccion`;

-- 1. Tabla Personas (Independiente)
CREATE TABLE IF NOT EXISTS `personas` (
  `cve_personas` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `paterno` varchar(50) DEFAULT NULL,
  `materno` varchar(50) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `rfc` varchar(15) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `sexo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`cve_personas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 2. Tabla Roles (Independiente)
CREATE TABLE IF NOT EXISTS `roles` (
  `cve_roles` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`cve_roles`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 3. Tabla Usuarios (Relacionada con Personas)
CREATE TABLE IF NOT EXISTS `usuarios` (
  `cve_usuarios` int(11) NOT NULL AUTO_INCREMENT,
  `cve_personas` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL UNIQUE,
  `contrasena` varchar(255) NOT NULL,
  PRIMARY KEY (`cve_usuarios`),
  CONSTRAINT `fk_usuario_persona` FOREIGN KEY (`cve_personas`) REFERENCES `personas` (`cve_personas`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 4. Tabla Trabajadores (Relacionada con Usuarios y Roles)
CREATE TABLE IF NOT EXISTS `trabajadores` (
  `cve_trabajadores` int(11) NOT NULL AUTO_INCREMENT,
  `cve_usuarios` int(11) NOT NULL,
  `cve_roles` int(11) NOT NULL,
  `num_empleado` varchar(50) DEFAULT NULL,
  `fecha_ingreso` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`cve_trabajadores`),
  CONSTRAINT `fk_trabajador_ref_rol` FOREIGN KEY (`cve_roles`) REFERENCES `roles` (`cve_roles`),
  CONSTRAINT `fk_trabajador_ref_usuario` FOREIGN KEY (`cve_usuarios`) REFERENCES `usuarios` (`cve_usuarios`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 5. Tabla Inmuebles
CREATE TABLE IF NOT EXISTS `inmuebles` (
  `cve_inmuebles` int(11) NOT NULL AUTO_INCREMENT,
  `razon_social` varchar(150) DEFAULT NULL,
  `razon_comercial` varchar(100) DEFAULT NULL,
  `nombre_comercial` varchar(100) DEFAULT NULL,
  `calle` varchar(100) DEFAULT NULL,
  `colonia` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `municipio` varchar(100) DEFAULT NULL,
  `estado` varchar(100) DEFAULT NULL,
  `latitud` varchar(20) DEFAULT NULL,
  `longitud` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`cve_inmuebles`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 6. Tabla Actas de Inspección
CREATE TABLE IF NOT EXISTS `actas_inspeccion` (
  `cve_actas_inspeccion` int(11) NOT NULL AUTO_INCREMENT,
  `cve_trabajadores` int(11) NOT NULL,
  `cve_inmuebles` int(11) NOT NULL,
  `num_acta` varchar(30) NOT NULL,
  `nombre_inspeccion` varchar(50) DEFAULT NULL,
  `giro` varchar(50) DEFAULT NULL,
  `clasificacion` varchar(50) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `observaciones` text DEFAULT NULL,
  `status` enum('aprobada','reprobada','sin_acceso') NOT NULL,
  PRIMARY KEY (`cve_actas_inspeccion`),
  UNIQUE KEY `num_acta` (`num_acta`),
  CONSTRAINT `fk_acta_ref_inmueble` FOREIGN KEY (`cve_inmuebles`) REFERENCES `inmuebles` (`cve_inmuebles`),
  CONSTRAINT `fk_acta_ref_trabajador` FOREIGN KEY (`cve_trabajadores`) REFERENCES `trabajadores` (`cve_trabajadores`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;