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
	//float cloud = texture(clouds, DataIn.texCoord).r;
	
	vec4 c;
	
	c = texture(mundo_tex,DataIn.texCoord) * intensity ;

	
	/*if(intensity > 0.5){
	
		// compute the half vector
		vec3 h = normalize( e + l);
	
		// compute the specular intensity
		float intSpec = max(dot( h, n), 0 );
		
		// compute the specular intensity (valores escolhidos por mim)
		spec = vec4( 0.7 , 0.7 , 0.7 , 0.0) * pow( intSpec , 500);
		//spec = vec4( 0 , 0.9 , 0 , 0.0) * pow( intSpec , 0.5);
		
		// Apply texture
		c = cloud + texture (dia, DataIn.texCoord) * intensity + spec * texture(texSpec,DataIn.texCoord).r * (1-cloud);
	}else{
		if(intensity < 0 )
			c = texture (noite, DataIn.texCoord) * (1-cloud);
		else{
			// compute the half vector
			vec3 h = normalize( e + l);
		
			// compute the specular intensity
			float intSpec = max(dot( h, n), 0 );
			
			// compute the specular intensity
			spec = vec4( 1 , 1 , 1 , 0.0) * pow( intSpec , 75);
			
			vec4 cd = cloud + texture (dia, DataIn.texCoord) * intensity + spec * texture(texSpec,DataIn.texCoord).r * (1-cloud) ;
			vec4 cn = texture (noite, DataIn.texCoord)  * (1-cloud);
			
			float f=smoothstep(0.0 , 0.5 , intensity);
			c=mix(cn,cd,f);
		}
	}*/

	colorOut= c;
}