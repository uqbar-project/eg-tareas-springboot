package ar.edu.tareas.app

import ar.edu.tareas.domain.Usuario
import ar.edu.tareas.repos.RepoTareas
import ar.edu.tareas.repos.RepoUsuarios
import java.time.LocalDate
import org.springframework.beans.factory.annotation.Autowired

class Bootstrap {

	@Autowired
	RepoTareas repoTareas
	
	@Autowired
	RepoUsuarios repoUsuarios
	
	def void run() {
		crearUsuarios
		crearTareas
	}

	def void crearTareas() {
		repoTareas => [
			crearTarea("Desarrollar componente de envio de mails", "Juan Contardo", LocalDate.now(), "Iteración 1", 0)
			crearTarea("Implementar single sign on desde la extranet", null, LocalDate.of(2018, 9, 9), "Iteración 1",
				76)
			crearTarea("Cancelar pedidos que esten pendientes desde hace 2 meses", "Rodrigo Grisolia",
				LocalDate.of(2018, 6, 30), "Iteración 1", 22)
			crearTarea("Mostrar info del pedido cuando esta finalizado", null, LocalDate.of(2018, 8, 10), "Iteración 2",
				90)
		]
	}

	def void crearUsuarios() {
		repoUsuarios => [
			create(new Usuario("Fernando Dodino"))
			create(new Usuario("Rodrigo Grisolia"))
			create(new Usuario("Dario Grinberg"))
			create(new Usuario("Juan Contardo"))
			create(new Usuario("Nahuel Palumbo"))
		]
	}

}
