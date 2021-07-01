package ar.edu.tareas.controller

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.service.TareaService
import javax.validation.Valid
import org.springframework.beans.factory.annotation.Autowired
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

	@Autowired
	TareaService tareaService

	@GetMapping("/tareas")
	def tareas() {
		ResponseEntity.ok(tareaService.tareas)
	}

	@GetMapping("/tareas/{id}")
	def tareaPorId(@PathVariable Integer id) {
		val tarea = tareaService.tareaPorId(id)
		ResponseEntity.ok(tarea)
	}

	@GetMapping("/tareas/search")
	def buscar(@RequestBody Tarea tareaBusqueda) {
		val encontrada = tareaService.buscar(tareaBusqueda)
		ResponseEntity.ok(encontrada)
	}

	@PutMapping("/tareas/{id}")
	def actualizar(@PathVariable Integer id, @RequestBody @Valid Tarea tareaInput) {
		val actualizada = tareaService.actualizar(id, tareaInput)
		ResponseEntity.ok(actualizada)
	}

}
