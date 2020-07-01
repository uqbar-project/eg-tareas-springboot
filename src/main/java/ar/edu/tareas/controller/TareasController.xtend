package ar.edu.tareas.controller

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.errors.BusinessException
import ar.edu.tareas.repos.RepoTareas
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException

@RestController
class TareasController {

	@GetMapping(value="/tareas")
	def tareas() {
		try {
			val tareas = RepoTareas.instance.allInstances
			ResponseEntity.ok(mapper.writeValueAsString(tareas))
		} catch (Exception e) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, e.message)
		}
	}

	@GetMapping(value="/tareas/{id}")
	def tareaPorId(@PathVariable Integer id) {
		try {
			val tarea = RepoTareas.instance.searchById(id)
			ResponseEntity.ok(mapper.writeValueAsString(tarea))
		} catch (RuntimeException e) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.message)
		}
	}

	// Ojo con el parámetro, debe decir exactamente descripcion
	@GetMapping(value="/tareas/search")
	def buscar(@RequestBody String body) {
		val tareaBusqueda = mapper.readValue(body, Tarea)
		ResponseEntity.ok(mapper.writeValueAsString(RepoTareas.instance.searchByExample(tareaBusqueda)))
	}

	@PutMapping(value="/tareas/{id}")
	def actualizar(@RequestBody String body, @PathVariable Integer id) {
		try {
			val actualizada = mapper.readValue(body, Tarea)

			if (id != actualizada.id) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					'{ "error" : "Id en URL distinto del cuerpo" }')
			}
			RepoTareas.instance.update(actualizada)
			ResponseEntity.ok("Se actualizó la tarea correctamente")
		} catch (BusinessException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.message)
		}
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}

}
