package ar.edu.tareas.app

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.context.annotation.ComponentScan

@SpringBootApplication
@ComponentScan(basePackages=#["ar.edu.tareas"])
class TareasApplication {
	def static void main(String[] args) {
		SpringApplication.run(TareasApplication, args)
	}
}
