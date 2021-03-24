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
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders

import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertTrue
import static ar.edu.tareas.controller.JsonHelpers.*

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
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/tareas")).andReturn.response
		val tareas = fromJsonToList(responseEntity.contentAsString, Tarea)
		assertEquals(200, responseEntity.status)
		assertEquals(tareas.size, 2)
	}

	@DisplayName("se pueden pedir las tareas que contengan cierta descripcion")
	@Test
	def void testBuscarTareasPorDescripcion() {
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.get("/tareas/search").content(mapper.writeValueAsString(getTarea))).andReturn.
			response
		val tareas = fromJsonToList(responseEntity.contentAsString, Tarea)
		assertEquals(200, responseEntity.status)
		assertTrue(tareas.exists[tarea|tarea.descripcion.equals(getTarea.descripcion)])
	}

	@DisplayName("se pueden pedir tareas que contengan cierta descripcion y que no se encuentre ninguna")
	@Test
	def void testBuscarTareasPorDescripcionNoMatch() {
		val tareaBusqueda = new Tarea => [descripcion = "Esta tarea no existe"]
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.get("/tareas/search").content(mapper.writeValueAsString(tareaBusqueda))).andReturn.
			response
		val tareas = fromJsonToList(responseEntity.contentAsString, Tarea)
		assertEquals(200, responseEntity.status)
		assertTrue(tareas.isEmpty)
	}

	@DisplayName("se puede obtener una tarea por su id")
	@Test
	def void testBuscarTareaPorIdOk() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/tareas/" + tarea.id)).andReturn.response
		val tarea = fromJson(responseEntity.contentAsString, Tarea)
		assertEquals(200, responseEntity.status)
		assertEquals(tarea.descripcion, "Desarrollar componente de envio de mails")
	}

	@DisplayName("si se pide una tarea con un id inválido se devuelve bad request")
	@Test
	def void testBuscarTareaPorIdInvalido() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/tareas/0")).andReturn.response
		assertEquals(400, responseEntity.status)
		assertEquals("Debe ingresar el parámetro id", responseEntity.errorMessage)
	}

	@DisplayName("si se pide una tarea con un id que no existe se produce un error")
	@Test
	def void testBuscarTareaPorIdInexistente() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/tareas/20000")).andReturn.response
		assertEquals(404, responseEntity.status)
		assertEquals("No se encontró la tarea de id <20000>", responseEntity.errorMessage)
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
		val tareaActualizada = fromJson(responseEntityGet.contentAsString, Tarea)
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
		assertEquals("Id en URL distinto del id que viene en el body", responseEntityPut.errorMessage)
	}

	@DisplayName("si se intenta actualizar una tarea con datos inválidos se produce bad request")
	@Test
	def void testActualizarUnaTareaDatosInvalidosException() {
		val tareaBody = getTarea => [id = tarea.id descripcion = ""]
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/tareas/" + tarea.id).content(mapper.writeValueAsString(tareaBody))).andReturn.
			response
		assertEquals(400, responseEntityPut.status)
		assertEquals("Debe ingresar descripcion", responseEntityPut.errorMessage)
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
