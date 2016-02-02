#version 330

uniform sampler2D mundo_tex,noite;

in Data{
	vec2 uv /*: TEXCOORD0*/;
	vec3 c0 /*: COLOR0*/;
	vec3 c1 /*: COLOR1*/;
}DataIn;

out vec4 colorOut;

void main(){

	float fHdrExposure =0.6;		// HDR exposure
	
	//vec3 n = normalize( DataIn.normal );
	//vec3 l = normalize( DataIn.l_dir );
	//vec3 e = normalize( vec3(DataIn.eye) );
	

	//float intensity = max(dot( l, n ), 0.0 );
	
	vec3 texel = vec3(texture(mundo_tex, DataIn.uv));
	vec3 col = DataIn.c0 + 0.5 * DataIn.c1;
	
	//Adjust color from HDR
	col = 1.0 - exp(col * -fHdrExposure);
	texel *= col.b;
	colorOut = vec4(texel+col,1.0);
	//colorOut=vec4(texel, 1);
	//colorOut = vec4(0,0,1,1); //DEGUG //RAFA
}
		