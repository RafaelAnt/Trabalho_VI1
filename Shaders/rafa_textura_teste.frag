#version 330 

//uniform sampler2D tex;
//uniform vec4 diffuse;

uniform float div = 8;
uniform float width =0.5;
uniform float gap = 0.04;
uniform vec4 cor1;
uniform vec4 cor2;



in Data {
  vec2 texCoord;
} DataIn;

out vec4 colorOut;

void main(){
	vec2 t= DataIn.texCoord * div;
	float f = fract(t.s);
	
	if( f < (width - gap)) {
		colorOut=cor1;
	}else{ 
		if(f > width && f< ((width * 2) - gap)){
			colorOut=cor2;
		}else{
			if(f<width){
				colorOut=mix(cor1,cor2,(f - (width -gap))* (50));
			}else{
				colorOut=mix(cor2,cor1,(f - (width*2 -gap))* (50));
			}
		}
	}
}
