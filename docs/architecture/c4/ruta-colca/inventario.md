# Inventario de Elementos C4 — RutaColca

**Integrantes del grupo:** Nagin Jazmin Carfer Carpio, Benjamín, Diego, Kenedy

## 1. Tabla de clasificación C4

| Elemento del caso | Tipo C4 | Justificación (una línea) |
| :--- | :--- | :--- |
| **Turista** | Persona (`Person`) | Actor humano que busca salidas al valle del Colca, registra su boleto turístico, reserva y paga en línea. |
| **Operador de agencia** | Persona (`Person`) | Actor humano de una agencia de Arequipa o Chivay que publica tours, fechas de salida, cupos y registra reservas presenciales. |
| **Guía de turismo** | Persona (`Person`) | Actor humano del negocio que conduce al grupo en el Colca y recibe el itinerario y la lista de pasajeros a través de WhatsApp. |
| **Administrador** | Persona (`Person`) | Actor humano del consorcio que aprueba el registro de agencias y revisa los reportes de ventas mensuales. |
| **RutaColca** | Sistema de software propio (`Software System`) | Plataforma central en estudio que digitaliza la publicación, reserva, validación de boletos y pago de tours al Colca. |
| **Pasarela de pagos** | Sistema de software externo (`Software System` - `Externo`) | Servicio de terceros encargado de procesar cobros con tarjeta o billetera móvil sin que RutaColca almacene datos financieros. |
| **WhatsApp Business** | Sistema de software externo (`Software System` - `Externo`) | Plataforma externa de mensajería mediante la cual se entregan los itinerarios y listas de grupos a los guías de turismo. |
| **Sistema de AUTOCOLCA** | Sistema de software externo (`Software System` - `Externo`) | Sistema externo de la autoridad autónoma que permite validar la autenticidad y vigencia del boleto turístico del Colca vía HTTPS. |
| **Web del turista** | Contenedor (`Container` - Aplicación) | Aplicación web SPA en React ejecutada en el navegador del turista para explorar el catálogo de tours, reservar y pagar. |
| **Portal de agencias** | Contenedor (`Container` - Aplicación) | Aplicación web progresiva (PWA) en React para que los operadores gestionen salidas, cupos y el administrador audite ventas. |
| **API Backend** | Contenedor (`Container` - Aplicación) | Servicio backend en Java 21 con Spring Boot que expone la lógica de negocio e integra los sistemas externos. |
| **Base de datos** | Contenedor (`Container` - Almacén de datos) | Motor relacional PostgreSQL 16 que almacena de forma persistente agencias, tours, salidas, cupos y reservas confirmadas. |

## 2. Decisión arquitectónica sobre el Guía de turismo

* **Decisión:** Se incluye al **Guía de turismo** como `Person` dentro del diagrama de contexto y de contenedores.
* **Motivo:** Aunque el guía no interactúa directamente con la interfaz gráfica de RutaColca, es un actor humano esencial del dominio del negocio y destinatario final del flujo de la historia de usuario HU-04 (recibe el itinerario y la lista del grupo a través del sistema externo WhatsApp Business).
