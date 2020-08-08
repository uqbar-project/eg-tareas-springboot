package ar.edu.tareas.serializer

import ar.edu.tareas.domain.Tarea
import com.fasterxml.jackson.core.JsonGenerator
import com.fasterxml.jackson.databind.SerializerProvider
import com.fasterxml.jackson.databind.ser.std.StdSerializer
import java.io.IOException
import java.time.format.DateTimeFormatter

class TareaSerializer extends StdSerializer<Tarea> {
	
	new() {
		super(Tarea)
	}
	
	override serialize(Tarea tarea, JsonGenerator gen, SerializerProvider provider) throws IOException {
		gen => [
			writeStartObject
			writeNumberField("id", tarea.id)
			writeStringField("descripcion", tarea.descripcion)
			if (tarea.asignatario !== null) {
				writeStringField("asignadoA", tarea.asignatario.nombre)
			}
			writeStringField("iteracion", tarea.iteracion)
			writeStringField("fecha", DateTimeFormatter.ofPattern("dd/MM/yyyy").format(tarea.fecha))
			writeNumberField("porcentajeCumplimiento", tarea.porcentajeCumplimiento)
			writeEndObject
		]
	}
	
}
