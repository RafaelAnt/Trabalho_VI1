#version 330 

//layout (std140) uniform Textures{
uniform sampler2D mundo_tex;
//};

in Data {
  vec2 texCoord;
  vec3 normal;
  vec3 l_dir;
  vec4 eye;
} DataIn;

out vec4 colorOut;

void main(){
	vec3 n = normalize( DataIn.normal );
	vec3 l = normalize( DataIn.l_dir );
	vec3 e = normalize( vec3(DataIn.eye) );
	
	vec4 spec = vec4 (0);
	
	float intensity = max(dot( l, n ), 0.0 );

	colorOut= texture(mundo_tex,DataIn.texCoord) * intensity ;
}