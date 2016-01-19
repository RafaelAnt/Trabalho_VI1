#version 330

uniform mat4 PVM;
//uniform mat4 VM;
//uniform mat4 M;

in vec4 position;
in vec2 texCoord0;

out Data {
  vec2 texCoord;
} DataOut;

void main(void) {
	DataOut.texCoord = texCoord0;

	gl_Position = PVM * position;
}
