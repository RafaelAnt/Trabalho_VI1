#version 330

uniform	vec4 l_dir;


in Data
	{
		vec4  pos /*: SV_POSITION*/;
		vec2  uv /*: TEXCOORD0*/;
		vec3 t0 /*: TEXCOORD1*/;
		vec3 c0 /*: COLOR0*/;
		vec3 c1 /*: COLOR1*/;
	}DataIn;
	
out vec4 colorOut;

void main() {
	float fHdrExposure =0.6;		// HDR exposure
	float g = -0.99;				// The Mie phase asymmetry factor
	float g2 = 0.9801;				// The Mie phase asymmetry factor squared
	float fCos = dot(vec3(l_dir), DataIn.t0) / length(DataIn.t0);
	float fCos2 = fCos*fCos;
	float getRayleighPhase = 0.75 + 0.75*fCos2;
	float getMiePhase = 1.5 * ((1.0 - g2) / (2.0 + g2)) * (1.0 + fCos2) / pow(1.0 + g2 - 2.0*g*fCos, 1.5);
	
	vec3 col = getRayleighPhase * DataIn.c0 + getMiePhase * DataIn.c1;
	
	col = 1.0 - exp(col * -fHdrExposure);
	
	colorOut= vec4(col,col.b);

}
