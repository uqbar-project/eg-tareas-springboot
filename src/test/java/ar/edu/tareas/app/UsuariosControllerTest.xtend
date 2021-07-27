package ar.edu.tareas.app

import ar.edu.tareas.domain.Usuario
import ar.edu.tareas.repos.RepoUsuarios
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import java.util.List
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

	@DisplayName("se pueden obtener todes les usuaries")
	@Test
	def void testGetTodosLosUsuarios() {
		mockMvc
			.perform(MockMvcRequestBuilders.get("/usuarios"))
			.andExpect(status.isOk)
			.andExpect(content.contentType("application/json"))
			.andExpect(jsonPath("$.length()").value(5))
	}

	static def <T extends Object> List<T> fromJsonToList(String json, Class<T> expectedType) {
		val type = mapper.getTypeFactory().constructCollectionType(List, expectedType)
		mapper.readValue(json, type)
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}

}
