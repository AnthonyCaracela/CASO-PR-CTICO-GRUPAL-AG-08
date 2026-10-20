# ADR-002: Soporte de registro de reservas presenciales sin conexión en Chivay

* **Estado:** Aceptado
* **Fecha:** 20 de octubre de 2026
* **Autores:** Nagin Jazmin Carfer Carpio, Benjamín, Diego, Kenedy

## 1. Contexto
Las agencias asociadas ubicadas en Chivay experimentan cortes e intermitencia frecuente en el servicio de internet (Tabla 4 y HU-05). Los operadores necesitan registrar ventas presenciales de tours en todo momento desde sus tablets y sincronizarlas automáticamente con el servidor central cuando se restablezca la conectividad, manteniendo las tecnologías base definidas en el ADR-001 (Portal de agencias como React PWA, API en Java 21 Spring Boot y PostgreSQL 16).

## 2. Decisión (Respuestas a las 4 preguntas del Paso 8)

1. **Contenedor nuevo en el diagrama de contenedores:**
   Se incorpora el contenedor **Almacén local de reservas** (`almacenLocal`). Es un **almacén de datos** local en el cliente implementado con la tecnología **IndexedDB** (nativa de los navegadores modernos y gestionada mediante el Service Worker de la React PWA), sin añadir motores externos fuera del ADR-001.
2. **Relación nueva y cambio en la relación Portal de agencias → API:**
   * **Relación nueva:** `Portal de agencias -> Almacén local de reservas` con la etiqueta *"Encola reservas presenciales sin internet y lee cupos en caché en"* usando `"IndexedDB API"`.
   * **Cambio en la relación hacia la API:** La relación `Portal de agencias -> API de RutaColca` pasa de realizar únicamente peticiones síncronas inmediatas a ejecutar también el envío de lotes asíncronos mediante Background Sync (*"Gestiona catálogo y sincroniza reservas diferidas al recuperar conexión mediante"* `[JSON/HTTPS]`).
3. **Nodo de ejecución en el diagrama de despliegue:**
   El nuevo contenedor se despliega como un `containerInstance` dentro del nodo **Navegador web con Service Worker** (`navAgencia`), el cual reside en el nodo físico **Tablet de la agencia** (`tabletAgencia`).
4. **Riesgo de negocio por sincronización diferida y regla de resolución:**
   * **Riesgo:** Sobreventa de cupos (*overbooking*) cuando una agencia sin conexión en Chivay vende el último asiento disponible de una salida mientras un turista en línea u otra agencia reserva simultáneamente ese mismo cupo en el servidor central.
   * **Regla de negocio:** Las reservas registradas sin internet nacen con el estado `PENDIENTE_CONFIRMACION`. La autoridad única de cupos es la base de datos central (`PostgreSQL 16`), que asigna los lugares por orden estricto de llegada al servidor (*First-Come, First-Served* en la transacción de la API). Si al sincronizar el lote el cupo ya fue agotado, la API marca la reserva diferida como `CONFLICTO_CUPO` y notifica de inmediato en el Portal de agencias para que el operador reubique al pasajero en el siguiente horario o emita la devolución del efectivo. Moreover, se permite asignar una cuota fija de "cupos exclusivos de oficina Chivay" bloqueados previamente para venta local offline.

## 3. Consecuencias
* **Positivas:** Continuidad operativa en las oficinas de Chivay durante caídas de red; cumplimiento estricto del ADR-001 aprovechando las capacidades estándar de una PWA en React.
* **Negativas / Compromisos:** La confirmación definitiva ante AUTOCOLCA y el descuento real del inventario ocurren de forma eventual al recuperar internet, lo que exige mostrar en el comprobante impreso local que la reserva está sujeta a validación de sincronización si se usó un cupo compartido.
