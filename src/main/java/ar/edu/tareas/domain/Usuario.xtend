package ar.edu.tareas.domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.Entity

@Accessors
class Usuario extends Entity {

	String nombre

	new() {
	}

	new(String nombre) {
		this.nombre = nombre
	}

}
