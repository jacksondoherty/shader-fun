﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Encapsulating code written in a material and shading language called
// 	ShaderLab.  It is similar to CgFX and Direct3D Effects (.FX) files
// 	languages - it describes everything needed to display a Material

// does not need to match file name
Shader "Unlit/MyFirstShader"
{
	// parameters to be set by artists in the editor, must be at top
	Properties 
	{
		_Tint ("Tint", Color) = (1, 1, 1, 1) // _NamingConvention
		// default value string refers to Unity texture, white black or gray
		// curly brackets are legacy but compilers expect them
		_MainTex ("Texture", 2D) = "white" {}
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

			// pragma directives tell compiler which program to use
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			// shaders don't have classes
			// including files allows splitting code up
			// UnityCG.cgninc is a shader file bundled with Unity.  It includes
			//	a few other essential files and some generic functionality
			#include "UnityCG.cginc"

			// different types from properties
			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST; // must have same name as texture the data comes from + _ST

			struct Interpolators {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolators MyVertexProgram(VertexData v)
			{
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return i;
			}

			// output of vertex program used as input for fragment, with interpolation
			float4 MyFragmentProgram (Interpolators i): SV_TARGET 
			{
				return tex2D(_MainTex, i.uv)* _Tint;
			}

			// ends Cg/HLSL code
			ENDCG
		}
	}
}
