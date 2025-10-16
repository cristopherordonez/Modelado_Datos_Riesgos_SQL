# 📊 Proyecto: Modelado de Datos para Análisis de Riesgos en SSO (ESPOL/MINTEL)

## 📌 Objetivo del Proyecto
Este trabajo, realizado como parte del programa **Data-Driven Decision Specialist de ESPOL/MINTEL**, tiene como objetivo principal:
* Diseñar e implementar un modelo de datos relacional (Tercera Forma Normal - 3FN) para estructurar datos dispersos de incidentes de Seguridad y Salud Ocupacional (SSO).
* Facilitar el análisis de causalidad y tendencias de riesgo para la toma de decisiones basada en datos.

## 🛠 Habilidades Demostradas
* **SQL:** Creación de esquemas, tablas, vistas, y consultas de análisis utilizando `JOIN` y `GROUP BY`.
* **Modelado de Datos:** Aplicación de conceptos de normalización para asegurar la integridad de los datos.
* **Conocimiento de Dominio:** Integración de la experiencia en SSO/Logística para definir las métricas de análisis.

## 📁 Contenido del Repositorio
- `ssodatos_schema_queries.sql`: Contiene el script completo para crear la base de datos, poblar las tablas de ejemplo y ejecutar las consultas de análisis.

## 📈 Resultados Clave del Análisis (Consulta de Riesgos)
La ejecución del script en MySQL Workbench arrojó los siguientes resultados para incidentes de severidad 'Alta' (Consulta 4.3):
| Riesgo | Incidentes |
| :--- | :--- |
| Caída a distinto nivel | 1 |
| Golpe por objeto | 1 |

**Conclusión del Análisis:** Estos resultados son críticos para la gestión de riesgos, permitiendo enfocar las inspecciones y programas de capacitación en los riesgos de mayor severidad.
