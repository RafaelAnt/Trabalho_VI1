#version 330

in vec4 position;	// local space 
//in vec2 texCoord0; //RAFA


//uniform vec3 v3LightPos;		// The direction vector to the light source = uniform	vec4 l_dir;??
layout (std140) uniform Lights{ //RAFA
	vec4 light_dir;	   // global space
};

layout (std140) uniform Camera{ //RAFA
	vec4 c_pos;    //camera position
};
	

layout (std140) uniform Matrices{ //RAFA
	mat4 m_pvm;
	mat4 m_m;
}; //RAFA

out Data{
		//vec4 pos /*: SV_POSITION*/; //RAFA
		//vec2 uv /*: TEXCOORD0*/; //RAFA
		vec3 t0 /*: TEXCOORD1*/;
		vec3 c0 /*: COLOR0*/;
		vec3 c1 /*: COLOR1*/;
	} DataOut;


void main () {
	vec3 v3Translate = vec3(0 , 0 , 0);		// The objects world pos //= translação dada as esferas no objeto;
	vec3 v3InvWavelength = vec3( 5.602044746 , 9.473284438 , 19.64380261); // 1 / pow(wavelength, 4) for the red, green, and blue channels //calculado a mao
	float fOuterRadius = 10.25;		// The outer (atmosphere) radius //= raio da esfera 2 do projeto
	float fOuterRadius2 = 105.0625;	// fOuterRadius^2
	float fInnerRadius = 10;		// The inner (planetary) radius //= raio da esfera 1 do projeto
	float fInnerRadius2 = 100;	// fInnerRadius^2
	float fKrESun = 0.0375;			// Kr=0.0025 * ESun=15
	float fKmESun = 0.015;			// Km=0.001 * ESun=15
	/*float fKrESun = 7.5;			// Kr=0.0025 * ESun=15
	float fKmESun = 0.15;			// Km=0.001 * ESun=15*/
	float fKr4PI = 0.31415927;			// Kr=0.0025 * 4 * PI //aproximado
	float fKm4PI = 0.12566371;			// Km=0.001 * 4 * PI
	float fScaleDepth = 0.125;		// The scale depth (i.e. the altitude at which the atmosphere's average density is found)
	float fScale =4;			// 1 / (fOuterRadius - fInnerRadius)
	float fScaleOverScaleDepth = 16;	// fScale / fScaleDepth
//uniform float fHdrExposure =0.6;		// HDR exposure
//uniform float g = -0.99;				// The Mie phase asymmetry factor
//uniform float g2 = 0.9801;				// The Mie phase asymmetry factor squared
	vec3 v3CameraPos = vec3(c_pos) - v3Translate;	// The camera's current position
	float fCameraHeight = length(v3CameraPos);					// The camera's current height
	float fCameraHeight2 = fCameraHeight*fCameraHeight;			// fCameraHeight^2

	// Get the ray from the camera to the vertex and its length (which is the far point of the ray passing through the atmosphere)
	vec3 v3Pos = ( m_m * position).xyz - v3Translate;
	vec3 v3Ray = v3Pos - v3CameraPos;
	float fFar = length(v3Ray);
	v3Ray = normalize (v3Ray); //RAFA
	
	// Calculate the closest intersection of the ray with the outer atmosphere (which is the near point of the ray passing through the atmosphere)
	float B = 2.0 * dot(v3CameraPos, v3Ray);
	float C = fCameraHeight2 - fOuterRadius2;
	float fDet = max(0.0, B*B - 4.0 * C);
	float fNear = 0.5 * (-B - sqrt(fDet));
	
	// Calculate the ray's start and end positions in the atmosphere, then calculate its scattering offset
	vec3 v3Start = v3CameraPos + v3Ray * fNear;
	fFar -= fNear;
	float fStartAngle = dot(v3Ray, v3Start) / fOuterRadius;
	float fStartDepth = exp(-1.0/fScaleDepth);
	float x = 1.0 - fStartAngle;
	float scaleFStartAngle = fScaleDepth * exp(-0.00287 + x*(0.459 + x*(3.83 + x*(-6.80 + x*5.25))));
	float fStartOffset = fStartDepth*scaleFStartAngle;
	
	const float fSamples = 2.0;

	// Initialize the scattering loop variables
	float fSampleLength = fFar / fSamples;
	float fScaledLength = fSampleLength * fScale;
	vec3 v3SampleRay = v3Ray * fSampleLength;
	vec3 v3SamplePoint = v3Start + v3SampleRay * 0.5;

	// Now loop through the sample rays
	vec3 v3FrontColor = vec3(0.0 , 0.0 , 0.0);
	for(int i=0; i < int(fSamples); i++)
	{
		float fHeight = length(v3SamplePoint);
		float fDepth = exp(fScaleOverScaleDepth * (fInnerRadius - fHeight));
		float fLightAngle = dot(vec3(light_dir), v3SamplePoint) / fHeight;
		float fCameraAngle = dot(v3Ray, v3SamplePoint) / fHeight;
		float x2 = 1.0 - fLightAngle;
		float scaleFLightAngle = fScaleDepth * exp(-0.00287 + x2*(0.459 + x2*(3.83 + x2*(-6.80 + x2*5.25))));
		float x3 = 1.0 - fCameraAngle;
		float scaleFCameraAngle = fScaleDepth * exp(-0.00287 + x3*(0.459 + x3*(3.83 + x3*(-6.80 + x3*5.25))));
		float fScatter = (fStartOffset + fDepth*(scaleFLightAngle - scaleFCameraAngle));
		vec3 v3Attenuate = exp(-fScatter * (v3InvWavelength * fKr4PI + fKm4PI));
		v3FrontColor += v3Attenuate * (fDepth * fScaledLength);
		v3SamplePoint += v3SampleRay;
	}

	//DataOut.pos = m_pvm * position; //RAFA
	//DataOut.uv = texCoord0; //RAFA
	gl_Position = m_pvm * position; //RAFA
	
	// Finally, scale the Mie and Rayleigh colors and set up the varying variables for the pixel shader
	DataOut.c0 = v3FrontColor * (v3InvWavelength * fKrESun);
	DataOut.c1 = v3FrontColor * fKmESun;
	DataOut.t0 = v3CameraPos - v3Pos;
				
			

}
