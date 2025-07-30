# Materialized Views (Vistas Materializadas)

## Descripción

Una **Materialized View** es una vista cuya consulta se almacena físicamente en disco, es decir, los resultados de la consulta están guardados como una tabla real y no se calculan en tiempo real cuando se accede a ella.

- A diferencia de las vistas normales, que son consultas virtuales y se ejecutan al vuelo, las materialized views guardan datos.
- Esto permite acceder rápido a resultados precomputados, especialmente útil para consultas complejas o que involucran agregaciones grandes.

## ¿Por qué se usan?

- Mejora de rendimiento: Consultas complejas con agregaciones, joins costosos, o grandes volúmenes de datos pueden demorarse mucho si se ejecutan en tiempo real.
- Consultas frecuentes: Cuando la misma consulta se hace muchas veces, conviene almacenar el resultado para acelerar el acceso.
- Optimización para reporting y análisis: En sistemas OLAP o de BI, donde los datos no necesitan estar 100% actualizados al instante, sino que importa la rapidez en lectura.

## Mantenimiento y Actualización

- La materialized view puede ser refrescada (actualizada) de distintas formas:
  - Complete Refresh: Se elimina todo y se recalcula desde la consulta base.
  - Incremental o Fast Refresh: Solo se actualizan los cambios (insert, update, delete) ocurridos en las tablas base, si el DBMS lo soporta.
- El refresco puede ser:
  - Automático: Programado o en intervalos.
  - Manual: El usuario decide cuándo refrescar.

## Alternativas a Materialized Views

- Vistas normales: Se ejecutan cada vez que se consultan, no almacenan datos, pero siempre reflejan datos actualizados.
- Tablas de resumen/denormalizadas: Crear tablas específicas con datos agregados que se actualizan mediante procesos ETL o triggers.
- Índices: Para acelerar búsquedas, aunque no almacenan resultados de consultas complejas.
- Caches a nivel aplicación: Guardar resultados en la capa de aplicación o en un sistema de cache externo (Redis, Memcached).

## En qué DBMS existen

- Oracle: Pionero en materialized views con soporte para refresco rápido, completo, automático y manual.
- PostgreSQL: Soporta materialized views desde la versión 9.3, pero solo refresco completo manual (desde la versión 12 hay opciones para refresco concurrente).
- SQL Server: No tiene materialized views con ese nombre, pero tiene Indexed Views (vistas con índices únicos clusterizados que almacenan resultados).
- MySQL: No soporta materialized views nativas. Se suelen simular con tablas y triggers o eventos.
- MariaDB: Implementa materialized views a través de plugins y con ciertas limitaciones.
- SQLite: No tiene materialized views.

## Contexto en la base de datos Sakila

- La base **Sakila** (de ejemplo para MySQL, PostgreSQL, etc.) no trae materialized views por defecto.
- Si quieres acelerar consultas complejas, en MySQL o MariaDB tendrías que crear tablas manualmente que almacenen los resultados agregados (ejemplo: total de alquileres por cliente) y actualizar esa tabla mediante scripts o triggers.
- En PostgreSQL con Sakila podrías crear una **materialized view** para un reporte, por ejemplo, total alquileres por película y refrescarla manualmente.
- En Oracle sería más sencillo porque tiene soporte completo para materialized views.

