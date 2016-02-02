#version 330


in vec4 position;
//in vec2 texCoord0; //RAFA

layout (std140) uniform Lights{ //RAFA
	vec4 light_dir;	   // global space
};

layout (std140) uniform Matrices{ //RAFA
	mat4 m_viewModel;
	mat4 m_pvm;
};

layout (std140) uniform Camera{ //RAFA
	vec4 c_pos;    //camera position
};

out Data{
		//vec3 uv /*: TEXCOORD0*/;
		vec3 c0 /*: COLOR0*/;
		vec3 c1 /*: COLOR1*/;
} DataOut;

void main (){
	
	// INIT
	float fOuterRadius = 5.125;		// The outer (atmosphere) radius //= raio da esfera 2 do projeto
	float fOuterRadius2 = 26.265625;	// fOuterRadius^2
	float fInnerRadius = 5;		// The inner (planetary) radius //= raio da esfera 1 do projeto
	float fInnerRadius2 = 25;	// fInnerRadius^2
	
	float fScaleDepth = 0.25;		// The scale depth (i.e. the altitude at which the atmosphere's average density is found)
	float fScale = 8;			// 1 / (fOuterRadius - fInnerRadius)
	float fScaleOverScaleDepth = 32;	// fScale / fScaleDepth
	
	vec3 v3InvWavelength = vec3( 5.602044746 , 9.473284438 , 19.64380261); // 1 / pow(wavelength, 4) for the red, green, and blue channels //calculado a mao
	float fKr4PI = 0.031415927;			// Kr=0.0025 * 4 * PI //aproximado
	float fKm4PI = 0.012566371;			// Km=0.001 * 4 * PI
	
	
	vec3 v3Translate = vec3 (0 , 0 , 0); // The objects world pos
	vec3 v3CameraPos = c_pos - v3Translate;	// The camera's current position
	float fCameraHeight = length(v3CameraPos);					// The camera's current height
	float fCameraHeight2 = fCameraHeight*fCameraHeight;			// fCameraHeight^2
	
	// Get the ray from the camera to the vertex and its length (which is the far point of the ray passing through the atmosphere)
	vec3 v3Pos = ( m_viewModel * position).xyz - v3Translate;
	vec3 v3Ray = v3Pos - v3CameraPos;
	float fFar = length(v3Ray);
	v3Ray = normalize (v3Ray);
	
	// Calculate the closest intersection of the ray with the outer atmosphere (which is the near point of the ray passing through the atmosphere)
	float B = 2.0 * dot(v3CameraPos, v3Ray);
	float C = fCameraHeight2 - fOuterRadius2;
	float fDet = max(0.0, B*B - 4.0 * C);
	float fNear = 0.5 * (-B - sqrt(fDet));
	
	// Calculate the ray's starting position, then calculate its scattering offset
	vec3 v3Start = v3CameraPos + v3Ray * fNear;
	fFar -= fNear;
	float fDepth = exp((fInnerRadius - fOuterRadius) / fScaleDepth);
	float fCameraAngle = dot(-v3Ray, v3Pos) / length(v3Pos);
	float fLightAngle = dot(vec3(light_dir) , v3Pos) / length(v3Pos);
	
	float x = 1.0 - fCameraAngle;
	float fCameraScale = fScaleDepth * exp(-0.00287 + x*(0.459 + x*(3.83 + x*(-6.80 + x*5.25))));
	
	float x = 1.0 - fLightAngle;
	float fLightScale = fScaleDepth * exp(-0.00287 + x*(0.459 + x*(3.83 + x*(-6.80 + x*5.25))));
	
	float fCameraOffset = fDepth*fCameraScale;
	float fTemp = (fLightScale + fCameraScale);
	
	float fSamples = 2.0;
	
	// Initialize the scattering loop variables
	float fSampleLength = fFar / fSamples;
	float fScaledLength = fSampleLength * fScale;
	vec3 v3SampleRay = v3Ray * fSampleLength;
	vec3 v3SamplePoint = v3Start + v3SampleRay * 0.5;
	
	// Now loop through the sample rays
	vec3 v3FrontColor = vec3 (0.0 , 0.0 , 0.0);
	vec3 v3Attenuate;
	for(int i=0; i<int(fSamples); i++)
	{
		float fHeight = length(v3SamplePoint);
		float fDepth = exp(fScaleOverScaleDepth * (fInnerRadius - fHeight));
		float fScatter = fDepth*fTemp - fCameraOffset;
		v3Attenuate = exp(-fScatter * (v3InvWavelength * fKr4PI + fKm4PI));
		v3FrontColor += v3Attenuate * (fDepth * fScaledLength);
		v3SamplePoint += v3SampleRay;
	}
	
	//OUT.pos = mul(UNITY_MATRIX_MVP, v.vertex);
	gl_Position = m_pvm * position; //RAFA
	//DataOut.uv = v.texcoord.xy;
	DataOut.c0 = v3FrontColor * (v3InvWavelength * fKrESun + fKmESun);
	DataOut.c1 = v3Attenuate;
				
}