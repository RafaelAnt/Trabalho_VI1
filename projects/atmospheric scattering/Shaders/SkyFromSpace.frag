#version 330 

in vec4 c0;
in vec4 c1;
in vec3 v3Direction;

uniform vec3 v3LightDirection;
uniform float g;
uniform float g2;

out vec4 colorOut;

// Mie phase function
float getMiePhase(float fCos, float fCos2, float g, float g2)
{
   return 1.5 * ((1.0 - g2) / (2.0 + g2)) * (1.0 + fCos2) / pow(1.0 + g2 - 2.0*g*fCos, 1.5);   
}

// Rayleigh phase function
float getRayleighPhase(float fCos2)
{
   //return 0.75 + 0.75 * fCos2;
   return 0.75 * (2.0 + 0.5 * fCos2);
   
}

void main(){
  float fCos = dot(v3LightDirection, v3Direction) / length(v3Direction);
  float fCos2 = fCos * fCos;
  vec4 color = getRayleighPhase(fCos2) * c0 + getMiePhase(fCos, fCos2, g, g2) * c1;
  color.a = color.b;
  //colorOut=vec4(0.0,1.0,0.0,1);
  colorOut = color;
}


