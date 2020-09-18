package ar.edu.tareas.controller

import ar.edu.tareas.repos.RepoUsuarios
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin
class UsuariosController {

	@GetMapping("/usuarios")
	def usuarios() {
		try {
			ResponseEntity.ok(RepoUsuarios.instance.allInstances)

		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}

}
