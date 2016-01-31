#version 330

uniform mat4 PVM;
uniform mat4 VM;
uniform mat4 V;
uniform mat3 mat_normal;
uniform vec4 light_pos;

in vec4 positionV;
in vec2 texCoord0;
in vec3 normalV;

out Data {
  vec2 texCoord;
  vec3 normal;
  vec3 l_dir;
  vec4 eye;
} DataOut;

void main(void) {
	
	vec4 pos=VM * positionV;
	vec4 lpos = V * light_pos;
	
	DataOut.texCoord = texCoord0;
	DataOut.l_dir = vec3(lpos-pos);
	//DataOut.eye = vec3(-pos);
	DataOut.eye = -(VM * positionV);
	DataOut.normal = normalize(mat_normal * normalV);

	gl_Position = PVM * positionV;
}
