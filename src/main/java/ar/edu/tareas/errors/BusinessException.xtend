package ar.edu.tareas.errors

import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(BAD_REQUEST)
class BusinessException extends RuntimeException {

	new(String msg) {
		super(msg)
	}
}

@ResponseStatus(NOT_FOUND)
class NotFoundException extends RuntimeException {

	new(String message) {
		super(message)
	}
}