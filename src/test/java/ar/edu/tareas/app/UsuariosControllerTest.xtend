package ar.edu.tareas.app

import ar.edu.tareas.controller.UsuariosController
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
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders

import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertTrue

@AutoConfigureJsonTesters
@ContextConfiguration(classes=UsuariosController)
@WebMvcTest
@DisplayName("Dado un controller de usuarios")
class UsuariosControllerTest {

	@Autowired
	MockMvc mockMvc
	RepoUsuarios repoUsuarios = RepoUsuarios.instance

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
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/usuarios")).andReturn.response
		val usuarios = responseEntity.contentAsString.fromJsonToList(Usuario)
		assertEquals(200, responseEntity.status)
		assertEquals(usuarios.size, 5)
		assertTrue(usuarios.exists[usuario|usuario.nombre.equals("Fernando Dodino")])
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
