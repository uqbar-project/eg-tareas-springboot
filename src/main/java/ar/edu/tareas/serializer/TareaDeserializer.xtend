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
import org.springframework.beans.factory.annotation.Autowired

class TareaDeserializer extends StdDeserializer<Tarea> {
	
	@Autowired
	RepoUsuarios repoUsuarios
	
	new() {
		super(Tarea)
	}
	
	override deserialize(JsonParser parser, DeserializationContext context) throws IOException, JsonProcessingException {
		val node = parser.readValueAsTree
		new Tarea => [
			val nodoId = node.get("id") as IntNode
			if (nodoId !== null) {
				id = nodoId.asInt
			}
			descripcion = (node.get("descripcion") as TextNode).asText
			iteracion = (node.get("iteracion") as TextNode).asText
			val nodoPorcentaje = node.get("porcentajeCumplimiento") as IntNode
			if (nodoPorcentaje !== null) {
				porcentajeCumplimiento = nodoPorcentaje.asInt
			}
			val nodoAsignatario = node.get("asignadoA") as TextNode
			if (nodoAsignatario !== null) {
				asignatario = repoUsuarios.getAsignatario(nodoAsignatario.asText)
			}
			val nodoFecha = node.get("fecha") as TextNode
			if (nodoFecha !== null) {
				fecha = LocalDate.parse(nodoFecha.asText, Tarea.formatter)
			}
		]
	}
	
}