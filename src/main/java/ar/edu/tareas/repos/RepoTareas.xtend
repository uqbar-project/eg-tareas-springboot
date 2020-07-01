package ar.edu.tareas.repos

import ar.edu.tareas.domain.Tarea
import java.time.LocalDate
import org.apache.commons.collections15.Predicate
import org.uqbar.commons.model.CollectionBasedRepo

class RepoTareas extends CollectionBasedRepo<Tarea> {

	static RepoTareas repoTareas

	def static RepoTareas getInstance() {
		if (repoTareas === null) {
			repoTareas = new RepoTareas
		}
		repoTareas
	}

	private new() {
	}

	def crearTarea(String unaDescripcion, String responsable, LocalDate date, String unaIteracion, int cumplimiento) {
		new Tarea => [
			asignarA(responsable)
			descripcion = unaDescripcion
			fecha = date ?: LocalDate.now
			iteracion = unaIteracion
			porcentajeCumplimiento = cumplimiento
			this.create(it)
		]
	}

	def crearTarea(Tarea tarea) {
		this.create(tarea)
		tarea
	}

	override validateCreate(Tarea tarea) {
		tarea.validar
	}

	override protected Predicate<Tarea> getCriterio(Tarea example) {
		new Predicate<Tarea> {
			override evaluate(Tarea tarea) {
				example.descripcion === null ||
					tarea?.descripcion.toUpperCase.contains(example.descripcion?.toUpperCase)
			}
		}
	}

	override createExample() {
		new Tarea
	}

	override getEntityType() {
		Tarea
	}

	def tareasPendientes() {
		allInstances.filter[estaPendiente].toList
	}

	override update(Tarea tarea) {
		tarea.validar
		super.update(tarea)
	}

}