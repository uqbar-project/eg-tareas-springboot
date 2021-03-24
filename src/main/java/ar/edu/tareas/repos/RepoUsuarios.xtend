package ar.edu.tareas.repos

import ar.edu.tareas.domain.Usuario
import org.apache.commons.collections15.Predicate
import org.uqbar.commons.model.CollectionBasedRepo
import org.springframework.stereotype.Repository

@Repository
class RepoUsuarios extends CollectionBasedRepo<Usuario> {

	override createExample() {
		new Usuario
	}

	override getEntityType() {
		Usuario
	}

	override protected Predicate<Usuario> getCriterio(Usuario example) {
		new Predicate<Usuario> {

			override evaluate(Usuario usuario) {
				usuario.nombre.toUpperCase.contains(example.nombre.toUpperCase)
			}

		}
	}

	def getAsignatario(String nombreAsignatario) {
		searchByExample(new Usuario(nombreAsignatario))?.head
	}

}
