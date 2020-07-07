package ar.edu.tareas.controller

import ar.edu.tareas.repos.RepoUsuarios
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.http.HttpStatus

@RestController
@CrossOrigin
class UsuariosController {

	@GetMapping(value="/usuarios")
	def usuarios() {
		try {
			val mapper = new ObjectMapper
			ResponseEntity.ok(mapper.writeValueAsString(RepoUsuarios.instance.allInstances))

		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}

}
