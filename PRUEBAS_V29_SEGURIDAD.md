# Cartera 24 — entorno de pruebas V29

Este directorio de trabajo corresponde exclusivamente a la rama `pruebas-v29`.

- Supabase de pruebas: `oyipvcscjriyfkwozqfp` (proyecto independiente, inicialmente sin tablas ni datos).
- Supabase de producción: **no conectar ni modificar desde esta rama**.
- No desplegar esta rama como sitio de producción.
- No introducir claves secretas, datos reales de clientes, pagos ni credenciales en GitHub.
- La V29 candidata todavía **no está instalada ni validada** en este repositorio.
- Antes de ejecutar migraciones: revisar dependencias, funciones, permisos RLS y datos ficticios.
- No ejecutar regularización de créditos ni cambios de estado en producción sin aprobación expresa.

Estado al 6 de noviembre de 2026: rama creada; entorno de base de datos vacío; pruebas de integración reales pendientes.
