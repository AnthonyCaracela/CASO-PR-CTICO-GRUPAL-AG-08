# Revisión Cruzada de Diagramas C4 (Anexo A)

**Grupo revisor:** Nagin Jazmin Carfer Carpio, Benjamín, Diego, Kenedy

## 1. Auditoría técnica sobre el modelo revisado (Formato P5 / Anexo A)

| Hallazgo | Elemento o relación | Gravedad | Corrección sugerida |
| :--- | :--- | :--- | :--- |
| Etiqueta genérica con el verbo prohibido "usa" | `turista -> ruta.webTurista "Usa la web"` | Alta | Reemplazar por una oración con verbo específico y preposición: `"Busca tours, registra su boleto y solicita reservas en"`. |
| Relación entre contenedores sin protocolo explícito | `ruta.api -> ruta.bd` | Alta | Especificar el protocolo `"JDBC"` en el tercer parámetro de la declaración de la relación en el DSL. |
| Contenedor mal conceptualizado como infraestructura | `docker = container "Contenedor Docker"` | Alta | Eliminar ese contenedor; Docker pertenece a la vista de despliegue (`deploymentNode`), no al diagrama de contenedores C4. |
| Sistema externo sin etiqueta visual diferenciadora | `autocolca = softwareSystem "Sistema de AUTOCOLCA"` | Media | Añadir el bloque `tags "Externo"` dentro de la definición del sistema para que se pinte en color gris (`#8C8C8C`). |
| Vista sin propiedad `title` descriptiva de alcance | `container ruta "Contenedores"` | Baja | Agregar `title "Diagrama de Contenedores - RutaColca"` dentro de la vista para facilitar la lectura de la audiencia. |

## 2. Registro de decisiones del equipo (Tabla 7 de la guía)

| N.° | Hallazgo | ¿Lo aceptamos? | Motivo |
| :---: | :--- | :---: | :--- |
| 1 | Cambiar el verbo genérico "usa" por verbos de acción con preposición en todas las relaciones. | Sí | Cumple la regla de relaciones del Anexo A para que cada flecha se lea como una oración clara. |
| 2 | Añadir protocolos (`JSON/HTTPS`, `JDBC`) en todas las flechas entre contenedores y sistemas externos. | Sí | Es obligatorio en el nivel 2 de C4 para especificar cómo se comunican los procesos en ejecución. |
| 3 | Validar el boleto turístico en AUTOCOLCA antes de ejecutar el cobro en la pasarela en la vista dinámica. | Sí | Evita cobros y extornos bancarios a turistas cuyo boleto turístico no sea válido o no esté vigente. |
