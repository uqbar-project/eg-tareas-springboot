package ar.edu.tareas.app

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.domain.Usuario
import ar.edu.tareas.repos.RepoTareas
import ar.edu.tareas.repos.RepoUsuarios
import java.time.LocalDate
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.json.AutoConfigureJsonTesters
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders

import static ar.edu.tareas.controller.JsonHelpers.*
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@AutoConfigureJsonTesters
@WebMvcTest
@DisplayName("Dado un controller de tareas")
class TareasControllerTest {

	@Autowired
	MockMvc mockMvc
	
	@Autowired
	RepoTareas repoTareas
	
	@Autowired
	RepoUsuarios repoUsuarios
	
	Usuario usuario
	Tarea tarea

	@BeforeEach
	def void init() {
		repoUsuarios.objects.clear
		repoTareas.objects.clear
		usuario = new Usuario("Juan Contardo")
		repoUsuarios.create(usuario)
		tarea = repoTareas.crearTarea(getTarea)
		repoTareas.crearTarea(getTarea => [
			descripcion = "Implementar single sign on desde la extranet"
			fecha = LocalDate.of(2018, 9, 9)
			iteracion = "Iteracion 1"
			porcentajeCumplimiento = 76
		])
	}

	@DisplayName("se pueden obtener todas las tareas")
	@Test
	def void testGetTodasLasTareas() {
		mockMvc
			.perform(MockMvcRequestBuilders.get("/tareas"))
			.andExpect(status.isOk)
			.andExpect(content.contentType("application/json"))
			.andExpect(jsonPath("$.length()").value(2))
	}

	@DisplayName("se pueden pedir las tareas que contengan cierta descripcion")
	@Test
	def void testBuscarTareasPorDescripcion() {
		val tareaBusqueda = getTarea
		mockMvc
			.perform(MockMvcRequestBuilders.get("/tareas/search")
				.contentType(MediaType.APPLICATION_JSON)
				.content(toJson(tareaBusqueda)))
			.andExpect(status.isOk)
			.andExpect(content.contentType("application/json"))
			.andExpect(jsonPath("$.length()").value(1))
			.andExpect(jsonPath("$.[0].descripcion").value(tareaBusqueda.descripcion))
	}

	@DisplayName("se pueden pedir tareas que contengan cierta descripcion y que no se encuentre ninguna")
	@Test
	def void testBuscarTareasPorDescripcionNoMatch() {
		val tareaBusqueda = new Tarea => [descripcion = "Esta tarea no existe"]
		mockMvc
			.perform(
				MockMvcRequestBuilders
				.get("/tareas/search")
				.contentType(MediaType.APPLICATION_JSON)
				.content(toJson(tareaBusqueda)))
			.andExpect(status.isOk)
			.andExpect(content.contentType("application/json"))
			.andExpect(jsonPath("$.length()").value(0))
	}

	@DisplayName("se puede obtener una tarea por su id")
	@Test
	def void testBuscarTareaPorIdOk() {
		mockMvc
			.perform(MockMvcRequestBuilders.get("/tareas/" + tarea.id))
			.andExpect(status.isOk)
			.andExpect(content.contentType("application/json"))
			.andExpect(jsonPath("$.id").value(tarea.id))
			.andExpect(jsonPath("$.descripcion").value(tarea.descripcion))
	}

	@DisplayName("si se pide una tarea con un id que no existe se produce un error")
	@Test
	def void testBuscarTareaPorIdInexistente() {
		mockMvc
			.perform(MockMvcRequestBuilders.get("/tareas/20000"))
			.andExpect(status.notFound)
	}

	@DisplayName("actualizar una tarea a un valor válido actualiza correctamente")
	@Test
	def void testActualizarUnaTareaOk() {
		val tareaValida = getTarea => [
			id = tarea.id
			porcentajeCumplimiento = 70
		]
		mockMvc
			.perform(
				MockMvcRequestBuilders
				.put("/tareas/" + tarea.id)
				.contentType(MediaType.APPLICATION_JSON)
				.content(toJson(tareaValida)))
			.andExpect(status.isOk)
			.andExpect(content.contentType("application/json"))
			.andExpect(jsonPath("$.porcentajeCumplimiento").value('70'))
	}

	@DisplayName("si se intenta actualizar una tarea con datos inválidos se produce bad request")
	@Test
	def void testActualizarUnaTareaDatosInvalidosException() {
		val tareaInvalida = getTarea => [
			id = tarea.id
			descripcion = ""
		]
		
		mockMvc
			.perform(
				MockMvcRequestBuilders
				.put("/tareas/" + tarea.id)
				.contentType(MediaType.APPLICATION_JSON)
				.content(toJson(tareaInvalida)))
			.andExpect(status.badRequest)
	}

	def getTarea() {
		new Tarea => [
			descripcion = "Desarrollar componente de envio de mails"
			asignarA(usuario)
			fecha = LocalDate.now
			iteracion = "Iteración 1"
			porcentajeCumplimiento = 0
		]
	}

}
