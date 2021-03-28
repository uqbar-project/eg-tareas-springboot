package ar.edu.tareas.controller

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import java.util.List

class JsonHelpers {

	static final ObjectMapper mapper = new ObjectMapper => [
		configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
		configure(SerializationFeature.INDENT_OUTPUT, true)
	]

	static def <T extends Object> T fromJson(String json, Class<T> expectedType) {
		mapper.readerFor(expectedType).readValue(json)
	}

	static def <T extends Object> List<T> fromJsonToList(String json, Class<T> expectedType) {
		val type = mapper.getTypeFactory().constructCollectionType(List, expectedType)
		mapper.readerFor(type).readValue(json)
	}

	static def <T> String toJson(T object) {
		mapper.writer.writeValueAsString(object)
	}

}
