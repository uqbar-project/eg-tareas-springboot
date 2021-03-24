package ar.edu.tareas.domain

import ar.edu.tareas.errors.BusinessException
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.Entity

@Accessors
class Tarea extends Entity {
	static int TAREA_COMPLETA = 100
	static String DATE_PATTERN = "dd/MM/yyyy"

	String descripcion
	String iteracion
	int porcentajeCumplimiento
	@JsonIgnore Usuario asignatario
	@JsonIgnore LocalDate fecha

	new() {
		initialize()
	}

	new(String descripcion, LocalDate fecha) {
		initialize()
		this.descripcion = descripcion
		this.fecha = fecha
	}

	def void initialize() {
		descripcion = ""
		iteracion = ""
		fecha = LocalDate.now
		porcentajeCumplimiento = 0
	}

	def validar() {
		if (descripcion.empty) {
			throw new BusinessException("Debe ingresar descripcion")
		}
		if (fecha === null) {
			throw new BusinessException("Debe ingresar fecha")
		}
	}

	def estaCumplida() {
		porcentajeCumplimiento == TAREA_COMPLETA
	}

	def estaPendiente() {
		!estaCumplida
	}

	override toString() {
		descripcion
	}

	@JsonProperty("asignadoA")
	def String getAsignadoA() {
		if (asignatario === null) {
			return ""
		}
		asignatario.nombre
	}

	@JsonProperty("fecha")
	def getFechaAsString() {
		formatter.format(this.fecha)
	}

	def asignarA(Usuario usuario) {
		this.asignatario = usuario
		usuario.asignarTarea(this)
	}

	@JsonProperty("fecha")
	def asignarFecha(String fecha) {
		this.fecha = LocalDate.parse(fecha, formatter)
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}

}
