workspace "RutaColca" "Modelo C4 de RutaColca - Grupo de Nagin Jazmin Carfer Carpio" {

    !identifiers hierarchical

    model {
        // PASO 2 - Personas: un rol humano por elemento
        turista = person "Turista" "Visitante nacional o extranjero que busca, reserva y paga tours al valle del Colca en línea."
        operador = person "Operador de agencia" "Personal de agencia en Arequipa o Chivay que publica tours, fechas de salida, cupos y registra reservas."
        guia = person "Guía de turismo" "Profesional de campo que recibe por WhatsApp el itinerario y la lista de pasajeros antes de la salida."
        administrador = person "Administrador" "Encargado del consorcio que aprueba el registro de agencias y revisa los reportes de ventas."

        // PASO 2 - Sistemas externos (etiqueta "Externo")
        pasarela = softwareSystem "Pasarela de pagos" "Servicio externo que procesa pagos en línea con tarjeta o billetera móvil." {
            tags "Externo"
        }
        whatsapp = softwareSystem "WhatsApp Business" "Plataforma externa de mensajería que entrega notificaciones e itinerarios a los guías." {
            tags "Externo"
        }
        autocolca = softwareSystem "Sistema de AUTOCOLCA" "Sistema externo de la entidad oficial para validar la vigencia del boleto turístico del Colca." {
            tags "Externo"
        }

        // PASO 2 y PASO 3 - El sistema en estudio y sus contenedores (ADR-001)
        ruta = softwareSystem "RutaColca" "Plataforma para publicar, reservar y pagar tours al valle del Colca con validación de boleto turístico." {
            webTurista = container "Web del turista" "Permite al turista buscar salidas, ingresar su boleto turístico, reservar y pagar en línea." "React (SPA)"
            portalAgencias = container "Portal de agencias" "Permite a los operadores gestionar tours y reservas, y al administrador aprobar agencias y ver reportes." "React (PWA)"
            api = container "API de RutaColca" "Ejecuta las reglas de negocio de publicación, validación de boletos, reservas, cobros y notificaciones." "Java 21 Spring Boot"
            bd = container "Base de datos" "Almacena usuarios, agencias, catálogo de tours, salidas, cupos y reservas (sin datos de tarjetas)." "PostgreSQL 16" {
                tags "Database"
            }
        }

        // Relaciones desde personas hacia contenedores de RutaColca (crean relaciones implícitas en Contexto)
        turista -> ruta.webTurista "Busca tours, registra su boleto y solicita reservas en" "HTTPS"
        operador -> ruta.portalAgencias "Publica tours, fechas de salida, cupos y gestiona reservas en" "HTTPS"
        administrador -> ruta.portalAgencias "Aprueba agencias registradas y consulta reportes de ventas en" "HTTPS"

        // Relaciones internas entre contenedores de RutaColca
        ruta.webTurista -> ruta.api "Solicita disponibilidad, reservas y pagos mediante" "JSON/HTTPS"
        ruta.portalAgencias -> ruta.api "Gestiona catálogo de tours, agencias y reportes mediante" "JSON/HTTPS"
        ruta.api -> ruta.bd "Lee y escribe registros de agencias, tours, cupos y reservas en" "JDBC"

        // Relaciones desde contenedores hacia sistemas externos y personas
        ruta.api -> autocolca "Valida el número de boleto turístico con" "JSON/HTTPS"
        ruta.api -> pasarela "Procesa el cobro de las reservas en" "JSON/HTTPS"
        ruta.api -> whatsapp "Envía el itinerario y la lista del grupo mediante" "JSON/HTTPS"
        whatsapp -> guia "Entrega el itinerario y la lista del grupo a" "HTTPS"
    }

    views {
        systemContext ruta "Contexto" "Diagrama de contexto del sistema RutaColca" {
            include *
            autolayout lr
            title "Diagrama de Contexto del Sistema - RutaColca"
        }

        container ruta "Contenedores" "Diagrama de contenedores del sistema RutaColca (ADR-001)" {
            include *
            autolayout tb
            title "Diagrama de Contenedores - RutaColca"
        }

        dynamic ruta "Dinamico" "Flujo de reserva y pago en línea de un tour (HU-02 y HU-03)" {
            title "Diagrama Dinámico - Reservar y pagar un tour (HU-02 y HU-03)"
            turista -> ruta.webTurista "1. Selecciona fecha de salida, ingresa número de boleto turístico y confirma pago en"
            ruta.webTurista -> ruta.api "2. Envía solicitud de reserva con número de boleto y token de pago mediante"
            ruta.api -> autocolca "3. Valida la vigencia del boleto turístico antes de cobrar con"
            ruta.api -> pasarela "4. Procesa la autorización del cobro de la reserva en"
            ruta.api -> ruta.bd "5. Registra la reserva confirmada y descuenta el cupo disponible en"
            ruta.api -> whatsapp "6. Envía el itinerario y la lista actualizada del grupo mediante"
            whatsapp -> guia "7. Entrega el itinerario y la lista de pasajeros un día antes de la salida a"
            autolayout lr
        }

        styles {
            element "Person" {
                shape Person
                background #0B3D62
                color #ffffff
            }
            element "Software System" {
                background #1B5E8B
                color #ffffff
            }
            element "Container" {
                background #0E7D73
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
            element "Externo" {
                background #8C8C8C
                color #ffffff
            }
        }
    }
}
