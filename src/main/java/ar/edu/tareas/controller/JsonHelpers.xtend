package ar.edu.tareas.controller

import com.fasterxml.jackson.databind.ObjectMapper

class JsonHelpers {

	static final ObjectMapper mapper = new ObjectMapper

	static def <T> String toJson(T object) {
		mapper.writer.writeValueAsString(object)
	}

}
