package ar.edu.tareas.errors

import org.springframework.core.annotation.Order
import org.springframework.core.Ordered
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus

@Order(Ordered.HIGHEST_PRECEDENCE)
@ControllerAdvice
class RestExceptionHandler extends ResponseEntityExceptionHandler {

	@ExceptionHandler(BusinessException)
	def protected handleBusinessException(BusinessException e) {
		ResponseEntity.badRequest.body(e.message)
	}

	@ExceptionHandler(Exception)
	def protected handleException(Exception e) {
		ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
	}

}
