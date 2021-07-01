package ar.edu.tareas.app

import ar.edu.tareas.domain.Usuario
import ar.edu.tareas.repos.RepoUsuarios
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.json.AutoConfigureJsonTesters
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@AutoConfigureJsonTesters
@WebMvcTest
@DisplayName("Dado un controller de usuarios")
class UsuariosControllerTest {

	@Autowired
	MockMvc mockMvc
	@Autowired
	RepoUsuarios repoUsuarios

	@BeforeEach
	def void init() {
		repoUsuarios => [
			objects.clear
			create(new Usuario("Fernando Dodino"))
			create(new Usuario("Rodrigo Grisolia"))
			create(new Usuario("Dario Grinberg"))
			create(new Usuario("Juan Contardo"))
			create(new Usuario("Nahuel Palumbo"))
		]
	}

	@DisplayName("se pueden obtener todos las usuarios")
	@Test
	def void testGetTodosLosUsuarios() {
		mockMvc
			.perform(MockMvcRequestBuilders.get("/usuarios"))
			.andExpect(status.isOk)
			.andExpect(content.contentType("application/json"))
			.andExpect(jsonPath("$.length()").value(5))
	}

}
