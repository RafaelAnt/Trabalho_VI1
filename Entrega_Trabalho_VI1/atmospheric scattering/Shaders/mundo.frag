#version 330 

//layout (std140) uniform Textures{
uniform sampler2D mundo_tex,noite;
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
	
	float intensity = max(dot( l, n ), 0.0 );

	if (intensity > 0.5){
		colorOut= texture(mundo_tex,DataIn.texCoord) * intensity ;
	}else{
		if( intensity < 0){
			colorOut= texture(noite,DataIn.texCoord) ;
		}else{
			vec3 h = normalize( e + l);
		
			vec4 cd = texture (mundo_tex, DataIn.texCoord) * intensity;
			vec4 cn = texture (noite, DataIn.texCoord);
			
			float f=smoothstep(0.0 , 0.5 , intensity);
			colorOut=mix(cn,cd,f);
		}
		
	}
	
}