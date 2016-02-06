#version 330

layout (std140) uniform Lights{//RAFA
	vec4 light_dir;	   // global space
};

in Data{
		//vec4  pos /*: SV_POSITION*/; //RAFA
		//vec2  uv /*: TEXCOORD0*/; //RAFA
		vec3 t0 /*: TEXCOORD1*/;
		vec3 c0 /*: COLOR0*/;
		vec3 c1 /*: COLOR1*/;
	}DataIn;
	
out vec4 colorOut;

void main() {
	float fHdrExposure =0.8;		// HDR exposure
	float g = -0.99;				// The Mie phase asymmetry factor
	float g2 = 0.9801;				// The Mie phase asymmetry factor squared
	float fCos = dot(vec3(light_dir), DataIn.t0) / length(DataIn.t0);
	float fCos2 = fCos*fCos;
	float getRayleighPhase = 0.75 + 0.75*fCos2;
	float getMiePhase = 1.5 * ((1.0 - g2) / (2.0 + g2)) * (1.0 + fCos2) / pow(1.0 + g2 - 2.0*g*fCos, 1.5);
	
	vec3 col = getRayleighPhase * DataIn.c0 + getMiePhase * DataIn.c1;
	
	col = 1.0 - exp(col * -fHdrExposure);
	
	colorOut= vec4(col,1);
	//colorOut = vec4(1,0,0,1); //DEGUG //RAFA

}
