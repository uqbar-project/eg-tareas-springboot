package ar.edu.tareas.service

import ar.edu.tareas.domain.Tarea
import ar.edu.tareas.errors.NotFoundException
import ar.edu.tareas.repos.RepoTareas
import ar.edu.tareas.repos.RepoUsuarios
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class TareaService {

	@Autowired
	RepoTareas repoTareas

	@Autowired
	RepoUsuarios repoUsuarios

	def tareas() {
		repoTareas.allInstances
	}

	def tareaPorId(Integer id) {
		val tarea = repoTareas.searchById(id)
		if (tarea === null) {
			throw new NotFoundException('''No se encontró la tarea de id <«id»>''');
		}
		tarea
	}

	def buscar(Tarea tareaBusqueda) {
		repoTareas.searchByExample(tareaBusqueda)
	}

	def validarYActualizar(Tarea tarea) {
		tarea.validar
		repoTareas.update(tarea)
		tarea
	}

	def actualizar(Integer id, Tarea tareaInput) {
		val tareaRepo = tareaPorId(id)
		val nombreAsignatario = tareaInput.asignatario.nombre
		tareaInput.asignatario = !nombreAsignatario.empty ? repoUsuarios.getAsignatario(nombreAsignatario)
		tareaRepo.actualizar(tareaInput)
		validarYActualizar(tareaRepo)
	}

}
