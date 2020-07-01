package ar.edu.tareas.domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.Entity

@Accessors
class Usuario extends Entity {

	String nombre
	List<Tarea> tareasAsignadas = newArrayList

	new() {
	}

	new(String nombre) {
		this.nombre = nombre
	}
	
	def asignarTarea(Tarea tarea) {
		tareasAsignadas.add(tarea)
	}

}
