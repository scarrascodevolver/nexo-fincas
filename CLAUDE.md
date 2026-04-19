# Nexo Fincas — ERP/PMS

## Contexto del Proyecto
- **Cliente:** Grupo Nexo (Nexo Fincas / Nexo Legal)
- **Sedes:** A Coruña (base), Madrid, Miami (activa), Chile (próxima)
- **Objetivo:** ERP/PMS de administración de fincas internacional
- **Stack:** Laravel 11 + React + Inertia.js, multi-tenant (datos aislados por delegación/país)
- **Diferenciador:** Integración de "Empresas de Insumos" propias de cada delegación que facturan mensualmente a las comunidades
- **Alcance real:** Parece ser el ERP completo, aunque inicialmente el cliente planteó enfocarse en el Portal Cliente

## Jerarquía Organizacional
Central Nexo → Sedes → Delegaciones/Franquicias → Comunidades de Propietarios → Propietarios

Cada franquicia tiene su propia Empresa de Insumos que factura a las comunidades.

## Diagramas (Excalidraw)
Link: https://excalidraw.com/#room=b829834133ea71f6848d,AwszSlZj4vChebejR-pUDQ

### Diagrama 1 — Jerarquía Organizacional
Estado: listo, con preguntas abiertas pendientes de respuesta del cliente

**CENTRAL NEXO-FINCAS**
1. ¿Qué métricas necesita ver central? (morosidad, facturación, KPIs por sede)
2. ¿Nexo Legal es empresa separada o departamento de central?
3. ¿Central opera comunidades directamente o solo supervisa?

**SEDES**
4. ¿Cuántas delegaciones puede tener una sede?
5. ¿La sede tiene contabilidad propia separada de sus delegaciones?
6. ¿Cada sede opera con su propia moneda e idioma? (ej: España=EUR/ES, Chile=CLP/ES, Miami=USD/EN)

**DELEGACION/FRANQUICIA**
7. ¿Cuántos administradores trabajan en una franquicia típica?
8. ¿Qué servicios factura la Empresa de Insumos de cada franquicia? (limpieza, mantenimiento, fontanería, etc.)
9. ¿La Empresa de Insumos factura directo a la comunidad de propietarios o a la franquicia?
10. ¿La facturación de la Empresa de Insumos es mensual fija o varía según consumo/servicios?
11. ¿La Empresa de Insumos estará dentro del sistema o es una empresa externa?
12. ¿Los proveedores son compartidos entre franquicias o cada una tiene los suyos?
13. ¿Una franquicia/delegación administra varias comunidades de propietarios?
14. ¿O una franquicia/delegación ES una sola comunidad de propietarios?
15. ¿Cada comunidad tiene sus propios propietarios, contabilidad y cuenta bancaria separada?
16. ¿Una comunidad puede tener subcomunidades o bloques internos?
17. ¿Una comunidad puede cambiar de franquicia administradora?
18. ¿Cuántos propietarios tiene una comunidad típica?

### Diagrama 2 — Mapa de Contexto
Estado: listo (imagen mapa-contextual.png)
- Usuarios: Administrador, Empleado, Central Nexo, Propietario
- Sistema: NEXO ERP/PMS (Portal Profesional + Portal Cliente)
- Externos: Banco/SEPA, Brevo/Email, WhatsApp, AEAT, OCR Facturas(?), Empresa Insumos

### Diagrama 3 — Mapa de Módulos
Estado: definido, pendiente de dibujar en Excalidraw

**NÚCLEO** (rojo/naranja):
- Comunidades, Propietarios, Contabilidad, Cuotas y Cobros

**OPERACIONAL** (azul):
- Incidencias, Proveedores, Bancos y Tesorería, Documentación Digital

**VALOR AÑADIDO** (verde):
- Portal Propietario, Juntas Online, Comunicaciones, Informes, Agenda, Legal, Integraciones

## Módulos Completos (del cliente)

### Top 7 imprescindibles (según cliente)
1. Contabilidad
2. Cobros / morosidad
3. Incidencias
4. Proveedores
5. Portal del propietario
6. Juntas online
7. (sin completar)

### Lista completa de 15 módulos
1. **Gestión General de Comunidades** — alta, datos fiscales, bloques/subcomunidades, coeficientes, histórico
2. **Gestión de Propietarios/Clientes** — fichas, titularidades, cambio propietarios, estado de cuenta
3. **Contabilidad** — plan contable, asientos automáticos, diario/mayor, balance, liquidaciones, cierre ejercicios, conciliación bancaria
4. **Cuotas, Recibos y Cobros** — cuotas ordinarias, derramas, recibos mensuales, remesas SEPA, control devoluciones, recargos mora, impagados
5. **Gestión de Incidencias y Averías** — alta, seguimiento por estados, asignación proveedor
6. **Gestión de Proveedores** — base datos, oficios, presupuestos, comparativas, órdenes trabajo, facturas, evaluación
7. **Juntas de Propietarios** — convocatorias automáticas, orden del día, asistencia, votaciones, actas, archivo
8. **Portal del Propietario / Área Cliente** — recibos, actas, estado económico, incidencias, comunicados, votaciones online, reserva zonas comunes
9. **Documentación y Archivo Digital** — contratos, seguros, facturas, actas, certificados, escrituras, carpeta por comunidad
10. **Comunicación y Notificaciones** — email masivo, SMS/WhatsApp, circulares, avisos urgentes, plantillas automáticas
11. **Bancos y Tesorería** — integración bancaria API, importación movimientos, conciliación automática, pagos proveedores
12. **Informes y Cuadros de Mando** — morosidad, gastos, evolución presupuestaria, KPIs, exportable Excel/PDF
13. **Agenda y Tareas Internas** — calendario juntas, vencimientos contratos, tareas por empleado, recordatorios
14. **Mantenimiento Legal y Normativo** — RGPD, certificados digitales, Ley Propiedad Horizontal
15. **Integraciones y Automatización** — firma digital, ERP externo, IA incidencias, OCR facturas, API externa, app móvil

## Portales
- **Portal Profesional** — para administradores y empleados (ya existe según cliente)
- **Portal Cliente** — para propietarios (ya existe según cliente, foco inicial del encargo)

---

## Análisis Arquitectónico — Dependencias entre Módulos

### Capas de dependencia (de más fundamental a más derivado)

**CAPA 0 — ENTIDADES RAÍZ** (todo el sistema depende de esto, se construye primero)
- **M1: Comunidades** — entidad central del sistema. Sin comunidad no existe nada.
- **M2: Propietarios** — entidad secundaria raíz. Siempre pertenece a una comunidad.

**CAPA 1 — NÚCLEO FINANCIERO** (depende de Capa 0)
- **M3: Contabilidad** — depende de Comunidades. Es el motor financiero.
- **M4: Cuotas y Cobros** — depende de Contabilidad + Propietarios + Comunidades.

**CAPA 2 — OPERACIONAL** (depende de Capas 0-1)
- **M6: Proveedores** — depende de Comunidades.
- **M5: Incidencias** — depende de Comunidades + Propietarios + Proveedores.
- **M11: Bancos y Tesorería** — depende de Contabilidad + Cuotas.
- **M9: Documentación Digital** — depende de Comunidades + Propietarios.

**CAPA 3 — VALOR AÑADIDO** (depende de Capas 0-2)
- **M10: Comunicaciones** — depende de Propietarios + Incidencias.
- **M7: Juntas** — depende de Propietarios + Comunidades + Documentación.
- **M13: Agenda** — depende de Comunidades + Juntas.
- **M12: Informes/Dashboard** — depende de Contabilidad + Cuotas + Incidencias + Bancos.
- **M14: Legal/Normativo** — depende de Documentación + Comunidades + Propietarios.

**CAPA 4 — PORTALES E INTEGRACIONES** (depende de todo)
- **M8: Portal Propietario** — depende de Propietarios + Cuotas + Incidencias + Documentación + Juntas + Comunicaciones.
- **M15: Integraciones** — depende de prácticamente todo.

### Módulos sin los cuales el sistema no puede funcionar (bloqueantes)
1. Comunidades
2. Propietarios
3. Contabilidad
4. Cuotas y Cobros

### Orden de construcción recomendado
Fase 1 → M1 + M2 (entidades base + multi-tenant)
Fase 2 → M3 + M4 (motor financiero)
Fase 3 → M6 + M5 + M11 + M9 (operacional)
Fase 4 → M10 + M7 + M13 + M12 + M14 (valor añadido)
Fase 5 → M8 + M15 (portales e integraciones)

---

## Diagramas Recomendados (arquitectura completa)

| # | Diagrama | Estado | Propósito |
|---|---|---|---|
| 1 | Jerarquía Organizacional | ✅ Listo | Estructura Central → Sedes → Franquicias → Comunidades |
| 2 | Mapa de Contexto (C4 Nivel 1) | ✅ Listo | Actores + sistema + sistemas externos |
| 3 | Mapa de Módulos por capas | ⏳ Pendiente | Núcleo / Operacional / Valor Añadido |
| 4 | Diagrama de Dependencias | ⏳ Pendiente | Qué módulo depende de cuál (DAG) |
| 5 | Diagrama de Casos de Uso | ⏳ Pendiente | Qué hace cada actor (Admin, Propietario, Central) |
| 6 | Modelo Entidad-Relación conceptual | ⏳ Pendiente | Entidades core: Comunidad, Propietario, Cuota, Incidencia |
| 7 | Diagrama Multi-tenant | ⏳ Pendiente | Cómo se aíslan datos por franquicia/país |
