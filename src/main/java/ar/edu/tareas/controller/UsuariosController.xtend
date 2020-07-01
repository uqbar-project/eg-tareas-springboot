package ar.edu.tareas.controller

import ar.edu.tareas.repos.RepoUsuarios
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.http.ResponseEntity

@RestController
class UsuariosController {

	@GetMapping(value="/usuarios")
	def usuarios() {
		val mapper = new ObjectMapper
		ResponseEntity.ok(mapper.writeValueAsString(RepoUsuarios.instance.allInstances))
	}

}
