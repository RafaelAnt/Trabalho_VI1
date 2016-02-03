#version 330

uniform sampler2D mundo_tex;

in Data{
	vec2 uv /*: TEXCOORD0*/;
	vec3 c0 /*: COLOR0*/;
	vec3 c1 /*: COLOR1*/;
}DataIn;

out vec4 colorOut;

void main(){
	float fHdrExposure =0.4;		// HDR exposure
	
	vec3 texel = vec3(texture(mundo_tex, DataIn.uv));
	vec3 col = DataIn.c0 + 0.25 * DataIn.c1;
	
	//Adjust color from HDR
	col = 1.0 - exp(col * -fHdrExposure);
	texel *= col.b;
	colorOut = vec4(texel+col,1.0);
}
		