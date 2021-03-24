package ar.edu.tareas.controller

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.errors.BusinessException
import ar.edu.tareas.repos.RepoTareas
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException

@RestController
@CrossOrigin
class TareasController {

	@GetMapping("/tareas")
	def tareas() {
		val tareas = RepoTareas.instance.allInstances
		ResponseEntity.ok(tareas)
	}

	@GetMapping("/tareas/{id}")
	def tareaPorId(@PathVariable Integer id) {
		if (id === 0) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, '''Debe ingresar el parámetro id''');
		}
		val tarea = RepoTareas.instance.searchById(id)
		if (tarea === null) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, '''No se encontró la tarea de id <«id»>''');
		}
		ResponseEntity.ok(tarea)
	}

	@GetMapping("/tareas/search")
	def buscar(@RequestBody String body) {
		val tareaBusqueda = mapper.readValue(body, Tarea)
		val encontrada = RepoTareas.instance.searchByExample(tareaBusqueda)
		ResponseEntity.ok(encontrada)
	}

	@PutMapping("/tareas/{id}")
	def actualizar(@RequestBody String body, @PathVariable Integer id) {
		try {
			if (id === null || id === 0) {
				throw new BusinessException('''Debe ingresar el parámetro id''')
			}
			val actualizada = mapper.readValue(body, Tarea)
			if (id != actualizada.id) {
				throw new BusinessException("Id en URL distinto del id que viene en el body")
			}
			RepoTareas.instance.update(actualizada)
			ResponseEntity.ok(actualizada)
		} catch (BusinessException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.message);
		}
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
		]
	}

}
