package ar.edu.tareas.app

import ar.edu.tareas.controller.TareasController
import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.domain.Usuario
import ar.edu.tareas.repos.RepoTareas
import ar.edu.tareas.repos.RepoUsuarios
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import java.time.LocalDate
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
@ContextConfiguration(classes=TareasController)
@WebMvcTest
@DisplayName("Dado un controller de tareas")
class TareasControllerTest {

	@Autowired
	MockMvc mockMvc
	RepoTareas repoTareas = RepoTareas.instance
	RepoUsuarios repoUsuarios = RepoUsuarios.instance
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
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/tareas")).andReturn.response
		val tareas = responseEntity.contentAsString.fromJsonToList(Tarea)
		assertEquals(200, responseEntity.status)
		assertEquals(tareas.size, 2)
	}

	@DisplayName("se pueden pedir las tareas que tengan cierta descripcion")
	@Test
	def void testBuscarTareasPorDescripcion() {
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.get("/tareas/search").content(mapper.writeValueAsString(getTarea))).andReturn.
			response
		val tareas = responseEntity.contentAsString.fromJsonToList(Tarea)
		assertEquals(200, responseEntity.status)
		assertTrue(tareas.exists[tarea|tarea.descripcion.equals(getTarea.descripcion)])
	}

	@DisplayName("se pueden pedir tareas que tengan cierta descripcion y que no se encuentre ninguna")
	@Test
	def void testBuscarTareasPorDescripcionNoMatch() {
		val tareaBusqueda = new Tarea => [descripcion = "Esta tarea no existe"]
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.get("/tareas/search").content(mapper.writeValueAsString(tareaBusqueda))).andReturn.
			response
		val tareas = responseEntity.contentAsString.fromJsonToList(Tarea)
		assertEquals(200, responseEntity.status)
		assertTrue(tareas.isEmpty)
	}

	@DisplayName("se puede obtener una tarea por su id")
	@Test
	def void testBuscarTareaPorIdOk() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/tareas/" + tarea.id)).andReturn.response
		val tarea = responseEntity.contentAsString.fromJson(Tarea)
		assertEquals(200, responseEntity.status)
		assertEquals(tarea.descripcion, "Desarrollar componente de envio de mails")
	}

	@DisplayName("si se pide una tarea con un id que no existe se produce un error")
	@Test
	def void testBuscarTareaPorIdException() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/tareas/20000")).andReturn.response
		assertEquals(404, responseEntity.status)
	}

	@DisplayName("actualizar una tarea a un valor válido actualiza correctamente")
	@Test
	def void testActualizarUnaTareaOk() {
		val tareaBody = getTarea => [
			id = tarea.id
			porcentajeCumplimiento = 70
		]
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/tareas/" + tarea.id).content(mapper.writeValueAsString(tareaBody))).andReturn.
			response
		assertEquals(200, responseEntityPut.status)
		val responseEntityGet = mockMvc.perform(MockMvcRequestBuilders.get("/tareas/" + tarea.id)).andReturn.response
		val tareaActualizada = responseEntityGet.contentAsString.fromJson(Tarea)
		assertEquals(200, responseEntityGet.status)
		assertEquals(tareaActualizada.porcentajeCumplimiento, tareaBody.porcentajeCumplimiento)
	}

	@DisplayName("si se intenta actualizar una tarea y no coinciden los ids de la url y el body se produce bad request")
	@Test
	def void testActualizarUnaTareaDistintosIdsException() {
		val tareaBody = getTarea => [id = tarea.id]
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/tareas/" + (tarea.id + 1)).content(mapper.writeValueAsString(tareaBody))).
			andReturn.response
		assertEquals(400, responseEntityPut.status)
	}

	@DisplayName("si se intenta actualizar una tarea con datos inválidos se produce bad request")
	@Test
	def void testActualizarUnaTareaDatosInvalidosException() {
		val tareaBody = getTarea => [id = tarea.id descripcion = ""]
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/tareas/" + tarea.id).content(mapper.writeValueAsString(tareaBody))).andReturn.
			response
		assertEquals(400, responseEntityPut.status)
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

	static def <T extends Object> fromJson(String json, Class<T> expectedType) {
		mapper.readValue(json, expectedType)
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
