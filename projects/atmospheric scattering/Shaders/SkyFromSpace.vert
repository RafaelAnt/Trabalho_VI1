#version 330 

  in vec4 positionV;

  uniform mat4 PVM;
  uniform vec3 v3CameraPos;        		// The camera's current position
  /*uniform vec3 v3LightDir,         		// Direction vector to the light source
  uniform vec3 v3InvWavelength,    		// 1 / pow(wavelength, 4) for RGB
  uniform float fCameraHeight,     		// The camera's current height
  uniform float fCameraHeight2,   		// fCameraHeight^2
  uniform float fOuterRadius,   		// The outer (atmosphere) radius
  uniform float fOuterRadius2,    		// fOuterRadius^2
  uniform float fInnerRadius,   		// The inner (planetary) radius
  uniform float fInnerRadius2,   		// fInnerRadius^2
  uniform float fKrESun,          		// Kr * ESun
  uniform float fKmESun,          		// Km * ESun
  uniform float fKr4PI,           		// Kr * 4 * PI
  uniform float fKm4PI,          		// Km * 4 * PI
  uniform float fScale,           		// 1 / (fOuterRadius - fInnerRadius)
  uniform float fScaleOverScaleDepth)	// fScale / fScaleDepth
*/
out Data {
	vec3 c0;
	vec3 c1;
	vec3 t0;
} DataOut;


  // Get the ray from the camera to the vertex and its length (which

  // is the far point of the ray passing through the atmosphere)

void main(){

	vec3 v3Pos = vec3 (positionV);

	//vec3 v3Ray = v3Pos - v3CameraPos;

	//float fFar = length(v3Ray);
	//v3Ray=normalize(v3Ray);

	DataOut.t0 = v3CameraPos - v3Pos;
	DataOut.c0 = vec3 (0,0,0);
	DataOut.c1 = vec3 (0.1,0,0.1);
	gl_Position = PVM * positionV;

}