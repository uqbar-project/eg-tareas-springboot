package ar.edu.tareas.controller

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.service.TareaService
import io.swagger.annotations.ApiOperation
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
	@ApiOperation("Devuelve todas las tareas")
	def tareas() {
		ResponseEntity.ok(tareaService.tareas)
	}

	@GetMapping("/tareas/{id}")
	@ApiOperation("Permite conocer la información de una tarea por identificador")
	def tareaPorId(@PathVariable Integer id) {
		val tarea = tareaService.tareaPorId(id)
		ResponseEntity.ok(tarea)
	}

	@GetMapping("/tareas/search")
	@ApiOperation("Devuelve todas las tareas cuya descripción contiene la descripción que pasamos como parámetro")
	def buscar(@RequestBody Tarea tareaBusqueda) {
		val encontrada = tareaService.buscar(tareaBusqueda)
		ResponseEntity.ok(encontrada)
	}

	@PutMapping("/tareas/{id}")
	@ApiOperation("Permite actualizar la información de una tarea")
	def actualizar(@PathVariable Integer id, @RequestBody Tarea tareaBody) {
		val actualizada = tareaService.actualizar(id, tareaBody)
		ResponseEntity.ok(actualizada)
	}

}
