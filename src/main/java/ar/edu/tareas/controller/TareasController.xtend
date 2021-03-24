package ar.edu.tareas.controller

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.errors.BusinessException
import ar.edu.tareas.repos.RepoTareas
import ar.edu.tareas.repos.RepoUsuarios
import com.fasterxml.jackson.databind.node.ObjectNode
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException

import static ar.edu.tareas.controller.JsonHelpers.*

@RestController
@CrossOrigin
class TareasController {

	@Autowired
	RepoTareas repoTareas
	@Autowired
	RepoUsuarios repoUsuarios

	@GetMapping("/tareas")
	def tareas() {
		val tareas = repoTareas.allInstances
		ResponseEntity.ok(tareas)
	}

	@GetMapping("/tareas/{id}")
	def tareaPorId(@PathVariable Integer id) {
		if (id === 0) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, '''Debe ingresar el parámetro id''');
		}
		val tarea = repoTareas.searchById(id)
		if (tarea === null) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, '''No se encontró la tarea de id <«id»>''');
		}
		ResponseEntity.ok(tarea)
	}

	@GetMapping("/tareas/search")
	def buscar(@RequestBody Tarea tareaBusqueda) {
		val encontrada = repoTareas.searchByExample(tareaBusqueda)
		ResponseEntity.ok(encontrada)
	}

	@PutMapping("/tareas/{id}")
	def actualizar(@RequestBody String body, @PathVariable Integer id) {
		try {
			if (id === null || id === 0) {
				throw new BusinessException('''Debe ingresar el parámetro id''')
			}
			val actualizada = mapper.readValue(body, Tarea)

			val String nombreAsignatario = mapper.readValue(body, ObjectNode).get("asignadoA").asText

			actualizada.asignarA(repoUsuarios.getAsignatario(nombreAsignatario))

			if (id != actualizada.id) {
				throw new BusinessException("Id en URL distinto del id que viene en el body")
			}
			repoTareas.update(actualizada)
			ResponseEntity.ok(actualizada)
		} catch (BusinessException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.message);
		}
	}

}
