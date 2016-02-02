#version 330






		half3 texel = tex2D(_MainTex, IN.uv).rgb;
				float3 col = IN.c0 + 0.25 * IN.c1;
				//Adjust color from HDR
				col = 1.0 - exp(col * -fHdrExposure);
				texel *= col.b;
				return half4(texel+col,1.0);