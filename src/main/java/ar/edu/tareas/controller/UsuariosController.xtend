package ar.edu.tareas.controller

import ar.edu.tareas.repos.RepoUsuarios
import io.swagger.annotations.ApiOperation
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin
class UsuariosController {

	@Autowired
	RepoUsuarios repoUsuarios

	@GetMapping("/usuarios")
	@ApiOperation("Devuelve todos los usuarios")
	def usuarios() {
		ResponseEntity.ok(repoUsuarios.allInstances)
	}

}