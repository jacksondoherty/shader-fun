// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Encapsulating code written in a material and shading language called
// 	ShaderLab.  It is similar to CgFX and Direct3D Effects (.FX) files
// 	languages - it describes everything needed to display a Material

// does not need to match file name
Shader "Unlit/MyFirstShader"
{
	// parameters to be set by artists in the editor
	// must be at top of shader file
	Properties 
	{
		// naming convention
		_Tint ("Tint", Color) = (1, 1, 1, 1)
	}

	// gives ability to provide different shaders for different platforms
	SubShader 
	{
		// where an object gets rendered
		// can have multiple if needed for certain effects
		Pass 
		{
			// Shader programs are written in Unity's shading language,
			//	which is a variant of HLSL and Cg referred by Unity as
			//	"Cg/HLSL".

			// HLSL -> DirectX
			// GLSL -> OpenGL
			// Cg (very similarl to HLSL) -> both DirectX and OpenGL
			// positives and negatives for using each in different situations

			// Unity takes Cg/HLSL code and compiles it depending on platform
			// 	Direct3D for Windows, OpenGL for Macs, OpenGL ES for mobiles, etc.
			//	Can get different results from different platforms

			// seperates Cg/HLSL code
			CGPROGRAM

			// pragma often used in programming to refer to compiler directives
			// We need both a vertex and fragment program.  These statements tell
			//	the compiler which programs to use
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			// shaders don't have classes
			// including files allows splitting code up
			// UnityCG.cgninc is a shader file bundled with Unity.  It includes
			//	a few other essential files and some generic functionality, like
			//		- UnityShaderVariables.cginc -> variables necessary for rendering
			//			like transformation, camera,  and light data
			//			This file is dependeded on by UnityInstancing.cginc which
			//				provides instancing support, a technique to reduce draw calls
			//		- HLSLSupport.cginc -> platform portability
			// contents of these files esentially copied into code, replacing include directives
			#include "UnityCG.cginc"

			float4 _Tint;

			// float4 is a collection of four floating point numbers
			// SV_POSITION signifies that this function will output 
			//	the position of the vertex
			float4 MyVertexProgram (float4 position : POSITION): SV_POSITION
			{
				return UnityObjectToClipPos(position);;
			}

			// float4 = RGBA
			// alpha is ingnored because this is an opaque shader
			// SV_TARGET indicates that the final color should be
			//	written to the frame buffer, which is the default
			// Fragment program receives vertex program's output
			// Texture coordinate semantics, indicated by TEXCOORD0,
			//	used for everything that's interpolated and isn't the
			//	vertex position
			float4 MyFragmentProgram (
				float4 position: SV_POSITION, 
				float3 localPosition: : TEXCOORD0
			): SV_TARGET 
			{
				return float4(localPosition, 1);
			}

			// ends Cg/HLSL code
			ENDCG
		}
	}
}
