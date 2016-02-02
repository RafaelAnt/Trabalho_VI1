#version 330

sampler2D mainTex;

in Data{
	vec3 uv /*: TEXCOORD0*/;
	vec3 c0 /*: COLOR0*/;
	vec3 c1 /*: COLOR1*/;
}DataIn;

out vec4 colorOut;

void main(){
	float fHdrExposure =0.6;		// HDR exposure
	
	vec3 texel = texture(mainTex, DataIn.uv).rgb;
	vec3 col = DataIn.c0 + 0.25 * DataIn.c1;
	
	//Adjust color from HDR
	col = 1.0 - exp(col * -fHdrExposure);
	texel *= col.b;
	return half4(texel+col,1.0);
}
		