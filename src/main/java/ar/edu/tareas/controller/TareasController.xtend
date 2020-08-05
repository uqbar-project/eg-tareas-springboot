package ar.edu.tareas.controller

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.errors.BusinessException
import ar.edu.tareas.repos.RepoTareas
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin
class TareasController {

	@GetMapping(value="/tareas")
	def tareas() {
		try {
			val tareas = RepoTareas.instance.allInstances
			ResponseEntity.ok(mapper.writeValueAsString(tareas))
		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}

	@GetMapping(value="/tareas/{id}")
	def tareaPorId(@PathVariable Integer id) {
		try {
			if (id === 0) {
				return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
			}
			val tarea = RepoTareas.instance.searchById(id)
			if (tarea === null) {
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontró la tarea de id <«id»>''')
			}
			ResponseEntity.ok(mapper.writeValueAsString(tarea))
		} catch (RuntimeException e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}

	@GetMapping(value="/tareas/search")
	def buscar(@RequestBody String body) {
		try {
			val tareaBusqueda = mapper.readValue(body, Tarea)
			val encontrada = RepoTareas.instance.searchByExample(tareaBusqueda)
			ResponseEntity.ok(mapper.writeValueAsString(encontrada))
		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}

	@PutMapping(value="/tareas/{id}")
	def actualizar(@RequestBody String body, @PathVariable Integer id) {
		try {
			if (id === null || id === 0) {
				return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
			}
			val actualizada = mapper.readValue(body, Tarea)

			if (id != actualizada.id) {
				return ResponseEntity.badRequest.body("Id en URL distinto del id que viene en el body")
			}
			RepoTareas.instance.update(actualizada)
			ResponseEntity.ok(mapper.writeValueAsString(actualizada))
		} catch (BusinessException e) {
			ResponseEntity.badRequest.body(e.message)
		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}

}
