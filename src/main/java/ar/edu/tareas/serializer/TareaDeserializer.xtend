package ar.edu.tareas.serializer

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.repos.RepoUsuarios
import com.fasterxml.jackson.core.JsonParser
import com.fasterxml.jackson.core.JsonProcessingException
import com.fasterxml.jackson.databind.DeserializationContext
import com.fasterxml.jackson.databind.deser.std.StdDeserializer
import com.fasterxml.jackson.databind.node.IntNode
import com.fasterxml.jackson.databind.node.TextNode
import java.io.IOException
import java.time.LocalDate

class TareaDeserializer extends StdDeserializer<Tarea> {
	
	new() {
		super(Tarea)
	}
	
	override deserialize(JsonParser parser, DeserializationContext context) throws IOException, JsonProcessingException {
		val node = parser.readValueAsTree
		new Tarea => [
			id = (node.get("id") as IntNode).asInt
			descripcion = (node.get("descripcion") as TextNode).asText
			iteracion = (node.get("iteracion") as TextNode).asText
			porcentajeCumplimiento = (node.get("porcentajeCumplimiento") as IntNode).asInt
			asignatario = RepoUsuarios.instance.getAsignatario((node.get("asignadoA") as TextNode).asText)
			val fechaTarea = (node.get("fecha") as TextNode).asText
			fecha = LocalDate.parse(fechaTarea, Tarea.formatter)
		]
	}
	
}