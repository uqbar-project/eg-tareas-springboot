package ar.edu.tareas.app

import ar.edu.tareas.domain.Usuario
import ar.edu.tareas.repos.RepoTareas
import ar.edu.tareas.repos.RepoUsuarios
import java.time.LocalDate
import org.springframework.beans.factory.InitializingBean
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class Bootstrap implements InitializingBean {

	@Autowired
	RepoTareas repoTareas

	@Autowired
	RepoUsuarios repoUsuarios

	Usuario juan

	Usuario rodrigo

	def void crearTareas() {
		repoTareas => [
			crearTarea("Desarrollar componente de envio de mails", juan, LocalDate.now(), "Iteración 1", 0)
			crearTarea("Implementar single sign on desde la extranet", null, LocalDate.of(2018, 9, 9), "Iteración 1",
				76)
			crearTarea("Cancelar pedidos que esten pendientes desde hace 2 meses", rodrigo, LocalDate.of(2018, 6, 30),
				"Iteración 1", 22)
			crearTarea("Mostrar info del pedido cuando esta finalizado", null, LocalDate.of(2018, 8, 10), "Iteración 2",
				90)
		]
	}

	def void crearUsuarios() {

		juan = new Usuario("Juan Contardo")

		rodrigo = new Usuario("Rodrigo Grisolia")

		repoUsuarios => [
			create(new Usuario("Fernando Dodino"))
			create(rodrigo)
			create(new Usuario("Dario Grinberg"))
			create(juan)
			create(new Usuario("Nahuel Palumbo"))
		]

	}

	override afterPropertiesSet() throws Exception {
		crearUsuarios
		crearTareas
	}

}
