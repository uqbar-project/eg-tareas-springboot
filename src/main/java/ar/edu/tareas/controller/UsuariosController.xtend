package ar.edu.tareas.controller

import ar.edu.tareas.repos.RepoUsuarios
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin
class UsuariosController {

	@GetMapping("/usuarios")
	def usuarios() {
		ResponseEntity.ok(RepoUsuarios.instance.allInstances)

	}

}
