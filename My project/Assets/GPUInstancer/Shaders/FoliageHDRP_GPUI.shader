// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GPUInstancer/FoliageHDRP"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_WindWaveNormalTexture("Wind Wave Normal Texture", 2D) = "bump" {}
		_WindWaveSize("Wind Wave Size", Range( 0 , 1)) = 0.5
		_DryColor("Dry Color", Color) = (1,0,0,0)
		_HealthyColor("Healthy Color", Color) = (0,1,0.2137935,0)
		_MainTex("MainTex", 2D) = "white" {}
		_AmbientOcclusion("Ambient Occlusion", Range( 0 , 1)) = 0.5
		_GradientPower("Gradient Power", Range( 0 , 1)) = 0.3
		_NoiseSpread("Noise Spread", Float) = 0.1
		_NormalMap("Normal Map", 2D) = "bump" {}
		_WindVector("Wind Vector", Vector) = (0.4,0.8,0,0)
		[Toggle]_IsBillboard("IsBillboard", Float) = 0
		_WindWaveTintColor("Wind Wave Tint Color", Color) = (0.07586241,0,1,0)
		_HealthyDryNoiseTexture("Healthy Dry Noise Texture", 2D) = "white" {}
		[Toggle]_WindWavesOn("Wind Waves On", Float) = 0
		_WindWaveTint("Wind Wave Tint", Range( 0 , 1)) = 0.5
		_WindWaveSway("Wind Wave Sway", Range( 0 , 1)) = 0.5
		_WindIdleSway("Wind Idle Sway", Range( 0 , 1)) = 0.6
		[Toggle(_BILLBOARDFACECAMPOS_ON)] _BillboardFaceCamPos("BillboardFaceCamPos", Float) = 0
		_CutOff("CutOff", Range( 0 , 1)) = 0.3
		_Smoothness("Smoothness", Float) = 0
		_Metallic("Metallic", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		[HideInInspector] _RenderQueueType("Render Queue Type", Float) = 1
		[HideInInspector] _StencilRef("Stencil Ref", Int) = 0
		[HideInInspector] _StencilWriteMask("Stencil Write Mask", Int) = 3
		[HideInInspector] _StencilRefDepth("Stencil Ref Depth", Int) = 0
		[HideInInspector] _StencilWriteMaskDepth("Stencil Write Mask Depth", Int) = 32
		[HideInInspector] _StencilRefMV("Stencil Ref MV", Int) = 128
		[HideInInspector] _StencilWriteMaskMV("Stencil Write Mask MV", Int) = 128
		[HideInInspector] _StencilRefDistortionVec("Stencil Ref Distortion Vec", Int) = 64
		[HideInInspector] _StencilWriteMaskDistortionVec("Stencil Write Mask Distortion Vec", Int) = 64
		[HideInInspector] _StencilWriteMaskGBuffer("Stencil Write Mask GBuffer", Int) = 3
		[HideInInspector] _StencilRefGBuffer("Stencil Ref GBuffer", Int) = 2
		[HideInInspector] _ZTestGBuffer("ZTest GBuffer", Int) = 4
		[HideInInspector] [ToggleUI] _RequireSplitLighting("Require Split Lighting", Float) = 0
		[HideInInspector] [ToggleUI] _ReceivesSSR("Receives SSR", Float) = 1
		[HideInInspector] _SurfaceType("Surface Type", Float) = 0
		[HideInInspector] _BlendMode("Blend Mode", Float) = 0
		[HideInInspector] _SrcBlend("Src Blend", Float) = 1
		[HideInInspector] _DstBlend("Dst Blend", Float) = 0
		[HideInInspector] _AlphaSrcBlend("Alpha Src Blend", Float) = 1
		[HideInInspector] _AlphaDstBlend("Alpha Dst Blend", Float) = 0
		[HideInInspector] [ToggleUI] _ZWrite("ZWrite", Float) = 0
		[HideInInspector] _CullMode("Cull Mode", Float) = 2
		[HideInInspector] _TransparentSortPriority("Transparent Sort Priority", Int) = 0
		[HideInInspector] _CullModeForward("Cull Mode Forward", Float) = 2
		[HideInInspector] [Enum(Front, 1, Back, 2)] _TransparentCullMode("Transparent Cull Mode", Float) = 2
		[HideInInspector] _ZTestDepthEqualForOpaque("ZTest Depth Equal For Opaque", Int) = 4
		[HideInInspector] [Enum(UnityEngine.Rendering.CompareFunction)] _ZTestTransparent("ZTest Transparent", Float) = 4
		[HideInInspector] [ToggleUI] _TransparentBackfaceEnable("Transparent Backface Enable", Float) = 0
		[HideInInspector] [ToggleUI] _AlphaCutoffEnable("Alpha Cutoff Enable", Float) = 1
		[HideInInspector] [ToggleUI] _UseShadowThreshold("Use Shadow Threshold", Float) = 1
		[HideInInspector] [ToggleUI] _DoubleSidedEnable("Double Sided Enable", Float) = 1
		[HideInInspector] [Enum(Flip, 0, Mirror, 1, None, 2)] _DoubleSidedNormalMode("Double Sided Normal Mode", Float) = 2
		[HideInInspector] _DoubleSidedConstants("DoubleSidedConstants", Vector) = (1,1,-1,0)
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="HDRenderPipeline" "RenderType"="Opaque" "Queue"="Geometry" }

		HLSLINCLUDE
		#pragma target 4.5
		#pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
		#pragma multi_compile_instancing
		#pragma multi_compile _ LOD_FADE_CROSSFADE

		struct GlobalSurfaceDescription
		{
			float3 Albedo;
			float3 Normal;
			float3 BentNormal;
			float3 Specular;
			float CoatMask;
			float Metallic;
			float3 Emission;
			float Smoothness;
			float Occlusion;
			float Alpha;
			float AlphaClipThreshold;
			float AlphaClipThresholdShadow;
			float AlphaClipThresholdDepthPrepass;
			float AlphaClipThresholdDepthPostpass;
			float SpecularAAScreenSpaceVariance;
			float SpecularAAThreshold;
			float SpecularOcclusion;
			float DepthOffset;
			//Refraction
			float RefractionIndex;
			float3 RefractionColor;
			float RefractionDistance;
			//SSS/Translucent
			float Thickness;
			float SubsurfaceMask;
			float DiffusionProfile;
			//Anisotropy
			float Anisotropy;
			float3 Tangent;
			//Iridescent
			float IridescenceMask;
			float IridescenceThickness;
			//BakedGI
			float3 BakedGI;
			float3 BakedBackGI;
		};

		struct AlphaSurfaceDescription
		{
			float Alpha;
			float AlphaClipThreshold;
			float AlphaClipThresholdShadow;
			float DepthOffset;
		};

		struct PrePassSurfaceDescription
		{
			float Smoothness;
			float Alpha;
			float AlphaClipThresholdDepthPrepass;
			float DepthOffset;
		};

		struct PostPassSurfaceDescription
		{
			float Smoothness;
			float Alpha;
			float AlphaClipThresholdDepthPostpass;
			float DepthOffset;
		};

		struct SmoothSurfaceDescription
		{
			float Smoothness;
			float Alpha;
			float AlphaClipThreshold;
			float DepthOffset;
		};

		struct DistortionSurfaceDescription
		{
			float Alpha;
			float2 Distortion;
			float DistortionBlur;
			float AlphaClipThreshold;
		};

		ENDHLSL
		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="GBuffer" }

			Cull [_CutOff]
			ZTest [_ZTestGBuffer]

			Stencil
			{
				Ref [_StencilRefGBuffer]
				WriteMask [_StencilWriteMaskGBuffer]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define SHADERPASS_GBUFFER_BYPASS_ALPHA_TEST 1
			#define _ALPHATEST_ON 1
			#define _ALPHATEST_SHADOW_ON 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define ASE_SRP_VERSION 70108


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

			#pragma vertex Vert
			#pragma fragment Frag

			#if defined(_DOTS_INSTANCING)
			#pragma instancing_options nolightprobe
			#pragma instancing_options nolodfade
			#else
			#pragma instancing_options renderinglayer
			#endif
			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#define SHADERPASS SHADERPASS_GBUFFER
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
			#pragma multi_compile _ LIGHT_LAYERS

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define ATTRIBUTES_NEED_TEXCOORD1
			#define ATTRIBUTES_NEED_TEXCOORD2
			#define VARYINGS_NEED_POSITION_WS
			#define VARYINGS_NEED_TANGENT_TO_WORLD
			#define VARYINGS_NEED_TEXCOORD1
			#define VARYINGS_NEED_TEXCOORD2

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_RELATIVE_WORLD_POS
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile_local __ _BILLBOARDFACECAMPOS_ON
			#include "Include/GPUInstancerInclude.cginc"
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setupGPUI


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 interp03 : TEXCOORD3;
				float4 interp04 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float _IsBillboard;
			float _WindWavesOn;
			float2 _WindVector;
			float _WindWaveSize;
			float _WindIdleSway;
			float _WindWaveSway;
			float _GradientPower;
			float4 _HealthyColor;
			float4 _DryColor;
			float _NoiseSpread;
			float4 _WindWaveTintColor;
			float _WindWaveTint;
			float4 _MainTex_ST;
			float4 _NormalMap_ST;
			float _Metallic;
			float _Smoothness;
			float _AmbientOcclusion;
			float _CutOff;
			float4 _EmissionColor;
			float _RenderQueueType;
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			CBUFFER_END
			sampler2D _WindWaveNormalTexture;
			sampler2D _HealthyDryNoiseTexture;
			sampler2D _MainTex;
			sampler2D _NormalMap;


			
			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.baseColor =                 surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion = surfaceDescription.SpecularOcclusion;
				#endif
				surfaceData.ambientOcclusion = surfaceDescription.Occlusion;
				surfaceData.metallic = surfaceDescription.Metallic;
				surfaceData.coatMask = surfaceDescription.CoatMask;

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask = surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness = surfaceDescription.IridescenceThickness;
				#endif
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif

				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor = surfaceDescription.Specular;
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif

				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif
				GetNormalWS(fragInputs, normalTS, surfaceData.normalWS,doubleSidedConstants);

				bentNormalWS = surfaceData.normalWS;
				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness = surfaceDescription.Thickness;
				#endif

				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness = surfaceDescription.Thickness;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask = surfaceDescription.SubsurfaceMask;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash = asuint(surfaceDescription.DiffusionProfile);
				#endif
				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy = surfaceDescription.Anisotropy;
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#else
				surfaceData.specularOcclusion = 1.0;
				#endif
				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif
			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				uint3 fadeMaskSeed = asuint( (int3)( V * _ScreenSize.xyx ) );
				LODDitheringTransition( fadeMaskSeed, unity_LODFade.x );
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, surfaceData, bentNormalWS );

				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				#ifdef _ASE_BAKEDGI
				builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
				#endif

				builtinData.emissiveColor = surfaceDescription.Emission;

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2( 0.0, 0.0 );
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS Vert(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);

				float BillboardOn261 = (( _IsBillboard )?( 1.0 ):( 0.0 ));
				float4x4 break301 = GetObjectToWorldMatrix();
				float3 appendResult302 = (float3(break301[ 0 ][ 0 ] , break301[ 1 ][ 0 ] , break301[ 2 ][ 0 ]));
				float3 appendResult306 = (float3(break301[ 0 ][ 1 ] , break301[ 1 ][ 1 ] , break301[ 2 ][ 1 ]));
				float3 appendResult307 = (float3(break301[ 0 ][ 2 ] , break301[ 1 ][ 2 ] , break301[ 2 ][ 2 ]));
				float4 appendResult303 = (float4(( float4(inputMesh.positionOS,1).x * length( appendResult302 ) ) , ( float4(inputMesh.positionOS,1).y * length( appendResult306 ) ) , ( float4(inputMesh.positionOS,1).z * length( appendResult307 ) ) , float4(inputMesh.positionOS,1).w));
				float4x4 break278 = UNITY_MATRIX_V;
				float3 appendResult287 = (float3(break278[ 0 ][ 0 ] , break278[ 0 ][ 1 ] , break278[ 0 ][ 2 ]));
				float3 normalizeResult288 = normalize( appendResult287 );
				float3 appendResult295 = (float3(normalizeResult288));
				float3 appendResult314 = (float3(break301[ 0 ][ 3 ] , break301[ 1 ][ 3 ] , break301[ 2 ][ 3 ]));
				float3 normalizeResult504 = normalize( cross( float3(0,1,0) , appendResult314 ) );
				#ifdef _BILLBOARDFACECAMPOS_ON
				float3 staticSwitch496 = normalizeResult504;
				#else
				float3 staticSwitch496 = appendResult295;
				#endif
				float3 appendResult279 = (float3(break278[ 1 ][ 0 ] , break278[ 1 ][ 1 ] , break278[ 1 ][ 2 ]));
				float3 normalizeResult283 = normalize( appendResult279 );
				float3 appendResult296 = (float3(normalizeResult283));
				float temp_output_416_0 = (appendResult296).y;
				float3 break419 = appendResult296;
				float4 appendResult420 = (float4(break419.x , ( temp_output_416_0 * -1.0 ) , break419.z , 0.0));
				#ifdef _BILLBOARDFACECAMPOS_ON
				float4 staticSwitch498 = float4(0,1,0,0);
				#else
				float4 staticSwitch498 = (( temp_output_416_0 > 0.0 ) ? float4( appendResult296 , 0.0 ) :  appendResult420 );
				#endif
				float3 appendResult281 = (float3(break278[ 2 ][ 0 ] , break278[ 2 ][ 1 ] , break278[ 2 ][ 2 ]));
				float3 normalizeResult284 = normalize( appendResult281 );
				float3 appendResult297 = (float3(( normalizeResult284 * -1.0 )));
				float3 appendResult322 = (float3(mul( appendResult303, float4x4(float4( staticSwitch496 , 0.0 ), staticSwitch498, float4( appendResult297 , 0.0 ), float4( 0,0,0,0 )) ).xyz));
				float4 appendResult323 = (float4(( appendResult322 + appendResult314 ) , float4(inputMesh.positionOS,1).w));
				float4 localWorldVar327 = ( float4( _WorldSpaceCameraPos , 0.0 ) + appendResult323 );
				(localWorldVar327).xyz = GetCameraRelativePositionWS((localWorldVar327).xyz);
				float4 transform327 = mul(GetWorldToObjectMatrix(),localWorldVar327);
				float4 BillboardedVertexPos320 = transform327;
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2Dlod( _WindWaveNormalTexture, float4( panner36, 0, 0.0) ), 1.0f );
				float3 FinalWindVectors181 = tex2DNode2;
				float3 break185 = FinalWindVectors181;
				float3 appendResult186 = (float3(break185.x , 0.0 , break185.y));
				float WindIdleSway197 = _WindIdleSway;
				float3 lerpResult230 = lerp( float3( 0,0,0 ) , ( appendResult186 * WindIdleSway197 ) , saturate( inputMesh.positionOS.y ));
				float3 WindIdleSwayCalculated218 = lerpResult230;
				float WindWaveSway191 = _WindWaveSway;
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float2 break206 = ( WindWaveNoise126 * WindDirVector29 );
				float3 appendResult205 = (float3(break206.x , 0.0 , break206.y));
				float3 lerpResult229 = lerp( float3( 0,0,0 ) , ( WindWaveSway191 * 20.0 * appendResult205 ) , saturate( inputMesh.positionOS.y ));
				float3 WindWaveSwayCalculated220 = lerpResult229;
				float3 lerpResult215 = lerp( WindIdleSwayCalculated218 , ( WindIdleSwayCalculated218 + ( WindWaveSwayCalculated220 * -1.0 ) ) , WindWaveNoise126);
				float4 localWorldVar233 = float4( ( _WorldSpaceCameraPos - (( WindWavesOn112 > 0.0 ) ? lerpResult215 :  WindIdleSwayCalculated218 ) ) , 0.0 );
				(localWorldVar233).xyz = GetCameraRelativePositionWS((localWorldVar233).xyz);
				float4 transform233 = mul(GetWorldToObjectMatrix(),localWorldVar233);
				float4 WindVertexOffset183 = transform233;
				float4 FinalVertexPos336 = (( BillboardOn261 > 0.0 ) ? ( BillboardedVertexPos320 + WindVertexOffset183 ) :  ( WindVertexOffset183 + float4(inputMesh.positionOS,1) ) );
				
				outputPackedVaryingsMeshToPS.ase_texcoord5 = float4(inputMesh.positionOS,1);
				outputPackedVaryingsMeshToPS.ase_texcoord6.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord6.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = FinalVertexPos336.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS = float3(0,1,0);
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz =	positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz =	normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				outputPackedVaryingsMeshToPS.interp03.xyzw = inputMesh.uv1;
				outputPackedVaryingsMeshToPS.interp04.xyzw = inputMesh.uv2;
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );
				return outputPackedVaryingsMeshToPS;
			}

			void Frag(  PackedVaryingsMeshToPS packedInput,
						OUTPUT_GBUFFER(outGBuffer)
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
						)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );
				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				float3 positionRWS = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;

				input.positionSS = packedInput.positionCS;
				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);
				input.texCoord1 = packedInput.interp03.xyzw;
				input.texCoord2 = packedInput.interp04.xyzw;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);
				float3 normalizedWorldViewDir = GetWorldSpaceNormalizeViewDir(input.positionRWS);
				SurfaceData surfaceData;
				BuiltinData builtinData;

				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float GradientPower161 = _GradientPower;
				float GradientColor160 = (( 1.0 - GradientPower161 ) + (saturate( packedInput.ase_texcoord5.xyz.y ) - 0.0) * (1.0 - ( 1.0 - GradientPower161 )) / (1.0 - 0.0));
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float4 HealthyColor116 = _HealthyColor;
				float4 DryColor118 = _DryColor;
				float3 ase_worldPos = GetAbsolutePositionWS( positionRWS );
				float NoiseSpread351 = _NoiseSpread;
				float div364=256.0/float((int)32.0);
				float4 posterize364 = ( floor( tex2D( _HealthyDryNoiseTexture, ( ( (ase_worldPos).xz * 0.05 ) * NoiseSpread351 ) ) * div364 ) / div364 );
				float4 break365 = posterize364;
				float HealthyDryNoise140 = saturate( sqrt( ( break365.r * break365.g * break365.b ) ) );
				float4 lerpResult59 = lerp( HealthyColor116 , DryColor118 , HealthyDryNoise140);
				float4 HealthyDryTint60 = lerpResult59;
				float4 WindWaveTintColor122 = _WindWaveTintColor;
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2D( _WindWaveNormalTexture, panner36 ), 1.0f );
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float WindWaveTintPower135 = _WindWaveTint;
				float4 lerpResult82 = lerp( HealthyDryTint60 , WindWaveTintColor122 , saturate( ( WindWaveNoise126 * WindWaveTintPower135 * 5.0 ) ));
				float4 WindWaveTint137 = lerpResult82;
				float2 uv_MainTex = packedInput.ase_texcoord6.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode166 = tex2D( _MainTex, uv_MainTex );
				float4 FinalAlbedo152 = ( GradientColor160 * ( (( WindWavesOn112 > 0.0 ) ? WindWaveTint137 :  HealthyDryTint60 ) * tex2DNode166 ) );
				
				float2 uv_NormalMap = packedInput.ase_texcoord6.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				
				float AmbientOcclusionPower163 = _AmbientOcclusion;
				float clampResult148 = clamp( ( saturate( packedInput.ase_texcoord5.xyz.y ) * AmbientOcclusionPower163 ) , 0.0 , 1.0 );
				float lerpResult150 = lerp( 1.0 , clampResult148 , AmbientOcclusionPower163);
				float AmbientOcclusion151 = lerpResult150;
				
				float AlphaCutoff167 = tex2DNode166.a;
				
				surfaceDescription.Albedo = FinalAlbedo152.rgb;
				surfaceDescription.Normal = UnpackNormalmapRGorAG( tex2D( _NormalMap, uv_NormalMap ), 1.0f );
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = _Metallic;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = 0;
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Occlusion = AmbientOcclusion151;
				surfaceDescription.Alpha = AlphaCutoff167;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _CutOff;
				#endif

				#ifdef _ALPHATEST_SHADOW_ON
				surfaceDescription.AlphaClipThresholdShadow = _CutOff;
				#endif

				#ifdef _ALPHATEST_PREPASS_ON
				surfaceDescription.AlphaClipThresholdDepthPrepass = 0.5;
				#endif

				#ifdef _ALPHATEST_POSTPASS_ON
				surfaceDescription.AlphaClipThresholdDepthPostpass = 0.5;
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				#ifdef _ASE_DISTORTION
				surfaceDescription.Distortion = float2 ( 2, -1 );
				surfaceDescription.DistortionBlur = 1;
				#endif

				#ifdef _ASE_BAKEDGI
				surfaceDescription.BakedGI = 0;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				surfaceDescription.BakedBackGI = 0;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				GetSurfaceAndBuiltinData( surfaceDescription, input, normalizedWorldViewDir, posInput, surfaceData, builtinData );
				ENCODE_INTO_GBUFFER( surfaceData, builtinData, posInput.positionSS, outGBuffer );
				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "META"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _ALPHATEST_ON 1
			#define _ALPHATEST_SHADOW_ON 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define ASE_SRP_VERSION 70108


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

			#pragma vertex Vert
			#pragma fragment Frag

			#if defined(_DOTS_INSTANCING)
			#pragma instancing_options nolightprobe
			#pragma instancing_options nolodfade
			#else
			#pragma instancing_options renderinglayer
			#endif

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#define SHADERPASS SHADERPASS_LIGHT_TRANSPORT

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define ATTRIBUTES_NEED_TEXCOORD0
			#define ATTRIBUTES_NEED_TEXCOORD1
			#define ATTRIBUTES_NEED_TEXCOORD2
			#define ATTRIBUTES_NEED_COLOR

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile_local __ _BILLBOARDFACECAMPOS_ON
			#include "Include/GPUInstancerInclude.cginc"
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setupGPUI



			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float _IsBillboard;
			float _WindWavesOn;
			float2 _WindVector;
			float _WindWaveSize;
			float _WindIdleSway;
			float _WindWaveSway;
			float _GradientPower;
			float4 _HealthyColor;
			float4 _DryColor;
			float _NoiseSpread;
			float4 _WindWaveTintColor;
			float _WindWaveTint;
			float4 _MainTex_ST;
			float4 _NormalMap_ST;
			float _Metallic;
			float _Smoothness;
			float _AmbientOcclusion;
			float _CutOff;
			float4 _EmissionColor;
			float _RenderQueueType;
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			CBUFFER_END
			sampler2D _WindWaveNormalTexture;
			sampler2D _HealthyDryNoiseTexture;
			sampler2D _MainTex;
			sampler2D _NormalMap;


			
			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);
				surfaceData.baseColor =                 surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion = surfaceDescription.SpecularOcclusion;
				#endif
				surfaceData.ambientOcclusion = surfaceDescription.Occlusion;
				surfaceData.metallic = surfaceDescription.Metallic;
				surfaceData.coatMask = surfaceDescription.CoatMask;

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask = surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness = surfaceDescription.IridescenceThickness;
				#endif
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif

				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor = surfaceDescription.Specular;
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				GetNormalWS(fragInputs, normalTS, surfaceData.normalWS,doubleSidedConstants);
				bentNormalWS = surfaceData.normalWS;
				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness = surfaceDescription.Thickness;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask = surfaceDescription.SubsurfaceMask;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash = asuint(surfaceDescription.DiffusionProfile);
				#endif
				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy = surfaceDescription.Anisotropy;
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );
				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#else
				surfaceData.specularOcclusion = 1.0;
				#endif
				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription,FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				uint3 fadeMaskSeed = asuint( (int3)( V * _ScreenSize.xyx ) ); // Quantize V to _ScreenSize values
				LODDitheringTransition( fadeMaskSeed, unity_LODFade.x );
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, surfaceData, bentNormalWS );

				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				InitBuiltinData (posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);

				builtinData.emissiveColor = surfaceDescription.Emission;

				builtinData.depthOffset = 0.0;

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2( 0.0, 0.0 );
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			CBUFFER_START(UnityMetaPass)
			bool4 unity_MetaVertexControl;
			bool4 unity_MetaFragmentControl;
			CBUFFER_END

			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;

			PackedVaryingsMeshToPS Vert(AttributesMesh inputMesh  )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);

				float BillboardOn261 = (( _IsBillboard )?( 1.0 ):( 0.0 ));
				float4x4 break301 = GetObjectToWorldMatrix();
				float3 appendResult302 = (float3(break301[ 0 ][ 0 ] , break301[ 1 ][ 0 ] , break301[ 2 ][ 0 ]));
				float3 appendResult306 = (float3(break301[ 0 ][ 1 ] , break301[ 1 ][ 1 ] , break301[ 2 ][ 1 ]));
				float3 appendResult307 = (float3(break301[ 0 ][ 2 ] , break301[ 1 ][ 2 ] , break301[ 2 ][ 2 ]));
				float4 appendResult303 = (float4(( float4(inputMesh.positionOS,1).x * length( appendResult302 ) ) , ( float4(inputMesh.positionOS,1).y * length( appendResult306 ) ) , ( float4(inputMesh.positionOS,1).z * length( appendResult307 ) ) , float4(inputMesh.positionOS,1).w));
				float4x4 break278 = UNITY_MATRIX_V;
				float3 appendResult287 = (float3(break278[ 0 ][ 0 ] , break278[ 0 ][ 1 ] , break278[ 0 ][ 2 ]));
				float3 normalizeResult288 = normalize( appendResult287 );
				float3 appendResult295 = (float3(normalizeResult288));
				float3 appendResult314 = (float3(break301[ 0 ][ 3 ] , break301[ 1 ][ 3 ] , break301[ 2 ][ 3 ]));
				float3 normalizeResult504 = normalize( cross( float3(0,1,0) , appendResult314 ) );
				#ifdef _BILLBOARDFACECAMPOS_ON
				float3 staticSwitch496 = normalizeResult504;
				#else
				float3 staticSwitch496 = appendResult295;
				#endif
				float3 appendResult279 = (float3(break278[ 1 ][ 0 ] , break278[ 1 ][ 1 ] , break278[ 1 ][ 2 ]));
				float3 normalizeResult283 = normalize( appendResult279 );
				float3 appendResult296 = (float3(normalizeResult283));
				float temp_output_416_0 = (appendResult296).y;
				float3 break419 = appendResult296;
				float4 appendResult420 = (float4(break419.x , ( temp_output_416_0 * -1.0 ) , break419.z , 0.0));
				#ifdef _BILLBOARDFACECAMPOS_ON
				float4 staticSwitch498 = float4(0,1,0,0);
				#else
				float4 staticSwitch498 = (( temp_output_416_0 > 0.0 ) ? float4( appendResult296 , 0.0 ) :  appendResult420 );
				#endif
				float3 appendResult281 = (float3(break278[ 2 ][ 0 ] , break278[ 2 ][ 1 ] , break278[ 2 ][ 2 ]));
				float3 normalizeResult284 = normalize( appendResult281 );
				float3 appendResult297 = (float3(( normalizeResult284 * -1.0 )));
				float3 appendResult322 = (float3(mul( appendResult303, float4x4(float4( staticSwitch496 , 0.0 ), staticSwitch498, float4( appendResult297 , 0.0 ), float4( 0,0,0,0 )) ).xyz));
				float4 appendResult323 = (float4(( appendResult322 + appendResult314 ) , float4(inputMesh.positionOS,1).w));
				float4 localWorldVar327 = ( float4( _WorldSpaceCameraPos , 0.0 ) + appendResult323 );
				(localWorldVar327).xyz = GetCameraRelativePositionWS((localWorldVar327).xyz);
				float4 transform327 = mul(GetWorldToObjectMatrix(),localWorldVar327);
				float4 BillboardedVertexPos320 = transform327;
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2Dlod( _WindWaveNormalTexture, float4( panner36, 0, 0.0) ), 1.0f );
				float3 FinalWindVectors181 = tex2DNode2;
				float3 break185 = FinalWindVectors181;
				float3 appendResult186 = (float3(break185.x , 0.0 , break185.y));
				float WindIdleSway197 = _WindIdleSway;
				float3 lerpResult230 = lerp( float3( 0,0,0 ) , ( appendResult186 * WindIdleSway197 ) , saturate( inputMesh.positionOS.y ));
				float3 WindIdleSwayCalculated218 = lerpResult230;
				float WindWaveSway191 = _WindWaveSway;
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float2 break206 = ( WindWaveNoise126 * WindDirVector29 );
				float3 appendResult205 = (float3(break206.x , 0.0 , break206.y));
				float3 lerpResult229 = lerp( float3( 0,0,0 ) , ( WindWaveSway191 * 20.0 * appendResult205 ) , saturate( inputMesh.positionOS.y ));
				float3 WindWaveSwayCalculated220 = lerpResult229;
				float3 lerpResult215 = lerp( WindIdleSwayCalculated218 , ( WindIdleSwayCalculated218 + ( WindWaveSwayCalculated220 * -1.0 ) ) , WindWaveNoise126);
				float4 localWorldVar233 = float4( ( _WorldSpaceCameraPos - (( WindWavesOn112 > 0.0 ) ? lerpResult215 :  WindIdleSwayCalculated218 ) ) , 0.0 );
				(localWorldVar233).xyz = GetCameraRelativePositionWS((localWorldVar233).xyz);
				float4 transform233 = mul(GetWorldToObjectMatrix(),localWorldVar233);
				float4 WindVertexOffset183 = transform233;
				float4 FinalVertexPos336 = (( BillboardOn261 > 0.0 ) ? ( BillboardedVertexPos320 + WindVertexOffset183 ) :  ( WindVertexOffset183 + float4(inputMesh.positionOS,1) ) );
				
				outputPackedVaryingsMeshToPS.ase_texcoord1.xyz = ase_worldPos;
				
				outputPackedVaryingsMeshToPS.ase_texcoord = float4(inputMesh.positionOS,1);
				outputPackedVaryingsMeshToPS.ase_texcoord2.xy = inputMesh.uv0.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord1.w = 0;
				outputPackedVaryingsMeshToPS.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = FinalVertexPos336.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS = float3(0,1,0);
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float2 uv;

				if (unity_MetaVertexControl.x)
				{
					uv = inputMesh.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				}
				else if (unity_MetaVertexControl.y)
				{
					uv = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				}

				outputPackedVaryingsMeshToPS.positionCS = float4(uv * 2.0 - 1.0, inputMesh.positionOS.z > 0 ? 1.0e-4 : 0.0, 1.0);
				return outputPackedVaryingsMeshToPS;
			}

			float4 Frag(PackedVaryingsMeshToPS packedInput  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( packedInput );
				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE(packedInput.cullFace, true, false);
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);
				float3 V = float3(1.0, 1.0, 1.0);

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float GradientPower161 = _GradientPower;
				float GradientColor160 = (( 1.0 - GradientPower161 ) + (saturate( packedInput.ase_texcoord.xyz.y ) - 0.0) * (1.0 - ( 1.0 - GradientPower161 )) / (1.0 - 0.0));
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float4 HealthyColor116 = _HealthyColor;
				float4 DryColor118 = _DryColor;
				float3 ase_worldPos = packedInput.ase_texcoord1.xyz;
				float NoiseSpread351 = _NoiseSpread;
				float div364=256.0/float((int)32.0);
				float4 posterize364 = ( floor( tex2D( _HealthyDryNoiseTexture, ( ( (ase_worldPos).xz * 0.05 ) * NoiseSpread351 ) ) * div364 ) / div364 );
				float4 break365 = posterize364;
				float HealthyDryNoise140 = saturate( sqrt( ( break365.r * break365.g * break365.b ) ) );
				float4 lerpResult59 = lerp( HealthyColor116 , DryColor118 , HealthyDryNoise140);
				float4 HealthyDryTint60 = lerpResult59;
				float4 WindWaveTintColor122 = _WindWaveTintColor;
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2D( _WindWaveNormalTexture, panner36 ), 1.0f );
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float WindWaveTintPower135 = _WindWaveTint;
				float4 lerpResult82 = lerp( HealthyDryTint60 , WindWaveTintColor122 , saturate( ( WindWaveNoise126 * WindWaveTintPower135 * 5.0 ) ));
				float4 WindWaveTint137 = lerpResult82;
				float2 uv_MainTex = packedInput.ase_texcoord2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode166 = tex2D( _MainTex, uv_MainTex );
				float4 FinalAlbedo152 = ( GradientColor160 * ( (( WindWavesOn112 > 0.0 ) ? WindWaveTint137 :  HealthyDryTint60 ) * tex2DNode166 ) );
				
				float2 uv_NormalMap = packedInput.ase_texcoord2.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				
				float AmbientOcclusionPower163 = _AmbientOcclusion;
				float clampResult148 = clamp( ( saturate( packedInput.ase_texcoord.xyz.y ) * AmbientOcclusionPower163 ) , 0.0 , 1.0 );
				float lerpResult150 = lerp( 1.0 , clampResult148 , AmbientOcclusionPower163);
				float AmbientOcclusion151 = lerpResult150;
				
				float AlphaCutoff167 = tex2DNode166.a;
				
				surfaceDescription.Albedo = FinalAlbedo152.rgb;
				surfaceDescription.Normal = UnpackNormalmapRGorAG( tex2D( _NormalMap, uv_NormalMap ), 1.0f );
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = _Metallic;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = 0;
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Occlusion = AmbientOcclusion151;
				surfaceDescription.Alpha = AlphaCutoff167;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _CutOff;
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				GetSurfaceAndBuiltinData(surfaceDescription,input, V, posInput, surfaceData, builtinData);

				BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);
				LightTransportData lightTransportData = GetLightTransportData(surfaceData, builtinData, bsdfData);

				float4 res = float4(0.0, 0.0, 0.0, 1.0);
				if (unity_MetaFragmentControl.x)
				{
					res.rgb = clamp(pow(abs(lightTransportData.diffuseColor), saturate(unity_OneOverOutputBoost)), 0, unity_MaxOutputValue);
				}

				if (unity_MetaFragmentControl.y)
				{
					res.rgb = lightTransportData.emissiveColor;
				}

				return res;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }
			Cull [_CullMode]

			ZClip [_ZClip]
			ZWrite On
			ZTest LEqual

			ColorMask 0

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _ALPHATEST_ON 1
			#define _ALPHATEST_SHADOW_ON 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define ASE_SRP_VERSION 70108


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

			#pragma vertex Vert
			#pragma fragment Frag

			#if defined(_DOTS_INSTANCING)
			#pragma instancing_options nolightprobe
			#pragma instancing_options nolodfade
			#else
			#pragma instancing_options renderinglayer
			#endif

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#define SHADERPASS SHADERPASS_SHADOWS
			#define USE_LEGACY_UNITY_MATRIX_VARIABLES

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_local __ _BILLBOARDFACECAMPOS_ON
			#include "Include/GPUInstancerInclude.cginc"
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setupGPUI


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float _IsBillboard;
			float _WindWavesOn;
			float2 _WindVector;
			float _WindWaveSize;
			float _WindIdleSway;
			float _WindWaveSway;
			float _GradientPower;
			float4 _HealthyColor;
			float4 _DryColor;
			float _NoiseSpread;
			float4 _WindWaveTintColor;
			float _WindWaveTint;
			float4 _MainTex_ST;
			float4 _NormalMap_ST;
			float _Metallic;
			float _Smoothness;
			float _AmbientOcclusion;
			float _CutOff;
			float4 _EmissionColor;
			float _RenderQueueType;
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			CBUFFER_END
			sampler2D _WindWaveNormalTexture;
			sampler2D _MainTex;


			
			void BuildSurfaceData(FragInputs fragInputs, inout AlphaSurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif

				float3 normalTS = float3( 0.0f, 0.0f, 1.0f );
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );
				bentNormalWS = surfaceData.normalWS;
				surfaceData.geomNormalWS = fragInputs.tangentToWorld[ 2 ];

				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif

				surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
				surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#else
				surfaceData.specularOcclusion = 1.0;
				#endif
				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

			}

			void GetSurfaceAndBuiltinData(AlphaSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				uint3 fadeMaskSeed = asuint( (int3)( V * _ScreenSize.xyx ) );
				LODDitheringTransition( fadeMaskSeed, unity_LODFade.x );
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				#ifdef _ALPHATEST_SHADOW_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow );
				#else
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, surfaceData, bentNormalWS );

				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				InitBuiltinData (posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2( 0.0, 0.0 );
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS Vert(AttributesMesh inputMesh  )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);

				float BillboardOn261 = (( _IsBillboard )?( 1.0 ):( 0.0 ));
				float4x4 break301 = GetObjectToWorldMatrix();
				float3 appendResult302 = (float3(break301[ 0 ][ 0 ] , break301[ 1 ][ 0 ] , break301[ 2 ][ 0 ]));
				float3 appendResult306 = (float3(break301[ 0 ][ 1 ] , break301[ 1 ][ 1 ] , break301[ 2 ][ 1 ]));
				float3 appendResult307 = (float3(break301[ 0 ][ 2 ] , break301[ 1 ][ 2 ] , break301[ 2 ][ 2 ]));
				float4 appendResult303 = (float4(( float4(inputMesh.positionOS,1).x * length( appendResult302 ) ) , ( float4(inputMesh.positionOS,1).y * length( appendResult306 ) ) , ( float4(inputMesh.positionOS,1).z * length( appendResult307 ) ) , float4(inputMesh.positionOS,1).w));
				float4x4 break278 = UNITY_MATRIX_V;
				float3 appendResult287 = (float3(break278[ 0 ][ 0 ] , break278[ 0 ][ 1 ] , break278[ 0 ][ 2 ]));
				float3 normalizeResult288 = normalize( appendResult287 );
				float3 appendResult295 = (float3(normalizeResult288));
				float3 appendResult314 = (float3(break301[ 0 ][ 3 ] , break301[ 1 ][ 3 ] , break301[ 2 ][ 3 ]));
				float3 normalizeResult504 = normalize( cross( float3(0,1,0) , appendResult314 ) );
				#ifdef _BILLBOARDFACECAMPOS_ON
				float3 staticSwitch496 = normalizeResult504;
				#else
				float3 staticSwitch496 = appendResult295;
				#endif
				float3 appendResult279 = (float3(break278[ 1 ][ 0 ] , break278[ 1 ][ 1 ] , break278[ 1 ][ 2 ]));
				float3 normalizeResult283 = normalize( appendResult279 );
				float3 appendResult296 = (float3(normalizeResult283));
				float temp_output_416_0 = (appendResult296).y;
				float3 break419 = appendResult296;
				float4 appendResult420 = (float4(break419.x , ( temp_output_416_0 * -1.0 ) , break419.z , 0.0));
				#ifdef _BILLBOARDFACECAMPOS_ON
				float4 staticSwitch498 = float4(0,1,0,0);
				#else
				float4 staticSwitch498 = (( temp_output_416_0 > 0.0 ) ? float4( appendResult296 , 0.0 ) :  appendResult420 );
				#endif
				float3 appendResult281 = (float3(break278[ 2 ][ 0 ] , break278[ 2 ][ 1 ] , break278[ 2 ][ 2 ]));
				float3 normalizeResult284 = normalize( appendResult281 );
				float3 appendResult297 = (float3(( normalizeResult284 * -1.0 )));
				float3 appendResult322 = (float3(mul( appendResult303, float4x4(float4( staticSwitch496 , 0.0 ), staticSwitch498, float4( appendResult297 , 0.0 ), float4( 0,0,0,0 )) ).xyz));
				float4 appendResult323 = (float4(( appendResult322 + appendResult314 ) , float4(inputMesh.positionOS,1).w));
				float4 localWorldVar327 = ( float4( _WorldSpaceCameraPos , 0.0 ) + appendResult323 );
				(localWorldVar327).xyz = GetCameraRelativePositionWS((localWorldVar327).xyz);
				float4 transform327 = mul(GetWorldToObjectMatrix(),localWorldVar327);
				float4 BillboardedVertexPos320 = transform327;
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2Dlod( _WindWaveNormalTexture, float4( panner36, 0, 0.0) ), 1.0f );
				float3 FinalWindVectors181 = tex2DNode2;
				float3 break185 = FinalWindVectors181;
				float3 appendResult186 = (float3(break185.x , 0.0 , break185.y));
				float WindIdleSway197 = _WindIdleSway;
				float3 lerpResult230 = lerp( float3( 0,0,0 ) , ( appendResult186 * WindIdleSway197 ) , saturate( inputMesh.positionOS.y ));
				float3 WindIdleSwayCalculated218 = lerpResult230;
				float WindWaveSway191 = _WindWaveSway;
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float2 break206 = ( WindWaveNoise126 * WindDirVector29 );
				float3 appendResult205 = (float3(break206.x , 0.0 , break206.y));
				float3 lerpResult229 = lerp( float3( 0,0,0 ) , ( WindWaveSway191 * 20.0 * appendResult205 ) , saturate( inputMesh.positionOS.y ));
				float3 WindWaveSwayCalculated220 = lerpResult229;
				float3 lerpResult215 = lerp( WindIdleSwayCalculated218 , ( WindIdleSwayCalculated218 + ( WindWaveSwayCalculated220 * -1.0 ) ) , WindWaveNoise126);
				float4 localWorldVar233 = float4( ( _WorldSpaceCameraPos - (( WindWavesOn112 > 0.0 ) ? lerpResult215 :  WindIdleSwayCalculated218 ) ) , 0.0 );
				(localWorldVar233).xyz = GetCameraRelativePositionWS((localWorldVar233).xyz);
				float4 transform233 = mul(GetWorldToObjectMatrix(),localWorldVar233);
				float4 WindVertexOffset183 = transform233;
				float4 FinalVertexPos336 = (( BillboardOn261 > 0.0 ) ? ( BillboardedVertexPos320 + WindVertexOffset183 ) :  ( WindVertexOffset183 + float4(inputMesh.positionOS,1) ) );
				
				outputPackedVaryingsMeshToPS.ase_texcoord1.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = FinalVertexPos336.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif
				inputMesh.normalOS = float3(0,1,0);

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS.xyz);
				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );
				return outputPackedVaryingsMeshToPS;
			}

			void Frag(  PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif

						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );

				float3 positionRWS  = packedInput.interp00.xyz;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				input.positionRWS = positionRWS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE(packedInput.cullFace, true, false);
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);
				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				SurfaceData surfaceData;
				BuiltinData builtinData;
				AlphaSurfaceDescription surfaceDescription = (AlphaSurfaceDescription)0;
				float2 uv_MainTex = packedInput.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode166 = tex2D( _MainTex, uv_MainTex );
				float AlphaCutoff167 = tex2DNode166.a;
				
				surfaceDescription.Alpha = AlphaCutoff167;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _CutOff;
				#endif

				#ifdef _ALPHATEST_SHADOW_ON
				surfaceDescription.AlphaClipThresholdShadow = _CutOff;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				GetSurfaceAndBuiltinData( surfaceDescription, input, V, posInput, surfaceData, builtinData );

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.vmesh.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}

			ENDHLSL
		}

			
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }
			ColorMask 0

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _ALPHATEST_ON 1
			#define _ALPHATEST_SHADOW_ON 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define ASE_SRP_VERSION 70108


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

			#pragma vertex Vert
			#pragma fragment Frag

			#if defined(_DOTS_INSTANCING)
			#pragma instancing_options nolightprobe
			#pragma instancing_options nolodfade
			#else
			#pragma instancing_options renderinglayer
			#endif

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#define SHADERPASS SHADERPASS_DEPTH_ONLY
			#define SCENESELECTIONPASS

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_local __ _BILLBOARDFACECAMPOS_ON
			#include "Include/GPUInstancerInclude.cginc"
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setupGPUI


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			int _ObjectId;
			int _PassValue;

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float _IsBillboard;
			float _WindWavesOn;
			float2 _WindVector;
			float _WindWaveSize;
			float _WindIdleSway;
			float _WindWaveSway;
			float _GradientPower;
			float4 _HealthyColor;
			float4 _DryColor;
			float _NoiseSpread;
			float4 _WindWaveTintColor;
			float _WindWaveTint;
			float4 _MainTex_ST;
			float4 _NormalMap_ST;
			float _Metallic;
			float _Smoothness;
			float _AmbientOcclusion;
			float _CutOff;
			float4 _EmissionColor;
			float _RenderQueueType;
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			CBUFFER_END
			sampler2D _WindWaveNormalTexture;
			sampler2D _MainTex;


			
			void BuildSurfaceData(FragInputs fragInputs, inout AlphaSurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif

				float3 normalTS = float3( 0.0f, 0.0f, 1.0f );
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				bentNormalWS = surfaceData.normalWS;
				surfaceData.geomNormalWS = fragInputs.tangentToWorld[ 2 ];

				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#else
				surfaceData.specularOcclusion = 1.0;
				#endif
				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif
			}

			void GetSurfaceAndBuiltinData(AlphaSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				uint3 fadeMaskSeed = asuint( (int3)( V * _ScreenSize.xyx ) );
				LODDitheringTransition( fadeMaskSeed, unity_LODFade.x );
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, surfaceData, bentNormalWS );

				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2( 0.0, 0.0 );
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS Vert(AttributesMesh inputMesh  )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);

				float BillboardOn261 = (( _IsBillboard )?( 1.0 ):( 0.0 ));
				float4x4 break301 = GetObjectToWorldMatrix();
				float3 appendResult302 = (float3(break301[ 0 ][ 0 ] , break301[ 1 ][ 0 ] , break301[ 2 ][ 0 ]));
				float3 appendResult306 = (float3(break301[ 0 ][ 1 ] , break301[ 1 ][ 1 ] , break301[ 2 ][ 1 ]));
				float3 appendResult307 = (float3(break301[ 0 ][ 2 ] , break301[ 1 ][ 2 ] , break301[ 2 ][ 2 ]));
				float4 appendResult303 = (float4(( float4(inputMesh.positionOS,1).x * length( appendResult302 ) ) , ( float4(inputMesh.positionOS,1).y * length( appendResult306 ) ) , ( float4(inputMesh.positionOS,1).z * length( appendResult307 ) ) , float4(inputMesh.positionOS,1).w));
				float4x4 break278 = UNITY_MATRIX_V;
				float3 appendResult287 = (float3(break278[ 0 ][ 0 ] , break278[ 0 ][ 1 ] , break278[ 0 ][ 2 ]));
				float3 normalizeResult288 = normalize( appendResult287 );
				float3 appendResult295 = (float3(normalizeResult288));
				float3 appendResult314 = (float3(break301[ 0 ][ 3 ] , break301[ 1 ][ 3 ] , break301[ 2 ][ 3 ]));
				float3 normalizeResult504 = normalize( cross( float3(0,1,0) , appendResult314 ) );
				#ifdef _BILLBOARDFACECAMPOS_ON
				float3 staticSwitch496 = normalizeResult504;
				#else
				float3 staticSwitch496 = appendResult295;
				#endif
				float3 appendResult279 = (float3(break278[ 1 ][ 0 ] , break278[ 1 ][ 1 ] , break278[ 1 ][ 2 ]));
				float3 normalizeResult283 = normalize( appendResult279 );
				float3 appendResult296 = (float3(normalizeResult283));
				float temp_output_416_0 = (appendResult296).y;
				float3 break419 = appendResult296;
				float4 appendResult420 = (float4(break419.x , ( temp_output_416_0 * -1.0 ) , break419.z , 0.0));
				#ifdef _BILLBOARDFACECAMPOS_ON
				float4 staticSwitch498 = float4(0,1,0,0);
				#else
				float4 staticSwitch498 = (( temp_output_416_0 > 0.0 ) ? float4( appendResult296 , 0.0 ) :  appendResult420 );
				#endif
				float3 appendResult281 = (float3(break278[ 2 ][ 0 ] , break278[ 2 ][ 1 ] , break278[ 2 ][ 2 ]));
				float3 normalizeResult284 = normalize( appendResult281 );
				float3 appendResult297 = (float3(( normalizeResult284 * -1.0 )));
				float3 appendResult322 = (float3(mul( appendResult303, float4x4(float4( staticSwitch496 , 0.0 ), staticSwitch498, float4( appendResult297 , 0.0 ), float4( 0,0,0,0 )) ).xyz));
				float4 appendResult323 = (float4(( appendResult322 + appendResult314 ) , float4(inputMesh.positionOS,1).w));
				float4 localWorldVar327 = ( float4( _WorldSpaceCameraPos , 0.0 ) + appendResult323 );
				(localWorldVar327).xyz = GetCameraRelativePositionWS((localWorldVar327).xyz);
				float4 transform327 = mul(GetWorldToObjectMatrix(),localWorldVar327);
				float4 BillboardedVertexPos320 = transform327;
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2Dlod( _WindWaveNormalTexture, float4( panner36, 0, 0.0) ), 1.0f );
				float3 FinalWindVectors181 = tex2DNode2;
				float3 break185 = FinalWindVectors181;
				float3 appendResult186 = (float3(break185.x , 0.0 , break185.y));
				float WindIdleSway197 = _WindIdleSway;
				float3 lerpResult230 = lerp( float3( 0,0,0 ) , ( appendResult186 * WindIdleSway197 ) , saturate( inputMesh.positionOS.y ));
				float3 WindIdleSwayCalculated218 = lerpResult230;
				float WindWaveSway191 = _WindWaveSway;
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float2 break206 = ( WindWaveNoise126 * WindDirVector29 );
				float3 appendResult205 = (float3(break206.x , 0.0 , break206.y));
				float3 lerpResult229 = lerp( float3( 0,0,0 ) , ( WindWaveSway191 * 20.0 * appendResult205 ) , saturate( inputMesh.positionOS.y ));
				float3 WindWaveSwayCalculated220 = lerpResult229;
				float3 lerpResult215 = lerp( WindIdleSwayCalculated218 , ( WindIdleSwayCalculated218 + ( WindWaveSwayCalculated220 * -1.0 ) ) , WindWaveNoise126);
				float4 localWorldVar233 = float4( ( _WorldSpaceCameraPos - (( WindWavesOn112 > 0.0 ) ? lerpResult215 :  WindIdleSwayCalculated218 ) ) , 0.0 );
				(localWorldVar233).xyz = GetCameraRelativePositionWS((localWorldVar233).xyz);
				float4 transform233 = mul(GetWorldToObjectMatrix(),localWorldVar233);
				float4 WindVertexOffset183 = transform233;
				float4 FinalVertexPos336 = (( BillboardOn261 > 0.0 ) ? ( BillboardedVertexPos320 + WindVertexOffset183 ) :  ( WindVertexOffset183 + float4(inputMesh.positionOS,1) ) );
				
				outputPackedVaryingsMeshToPS.ase_texcoord.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = FinalVertexPos336.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif
				inputMesh.normalOS = float3(0,1,0);

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );
				return outputPackedVaryingsMeshToPS;
			}

			void Frag(  PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH)
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif

						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );
				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE(packedInput.cullFace, true, false);
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = float3(1.0, 1.0, 1.0); // Avoid the division by 0

				SurfaceData surfaceData;
				BuiltinData builtinData;
				AlphaSurfaceDescription surfaceDescription = (AlphaSurfaceDescription)0;
				float2 uv_MainTex = packedInput.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode166 = tex2D( _MainTex, uv_MainTex );
				float AlphaCutoff167 = tex2DNode166.a;
				
				surfaceDescription.Alpha = AlphaCutoff167;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _CutOff;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				GetSurfaceAndBuiltinData( surfaceDescription, input, V, posInput, surfaceData, builtinData );

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.vmesh.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			Cull [_CullMode]

			ZWrite On

			Stencil
			{
				Ref [_StencilRefDepth]
				WriteMask [_StencilWriteMaskDepth]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _ALPHATEST_ON 1
			#define _ALPHATEST_SHADOW_ON 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define ASE_SRP_VERSION 70108


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

			#pragma vertex Vert
			#pragma fragment Frag

			#if defined(_DOTS_INSTANCING)
			#pragma instancing_options nolightprobe
			#pragma instancing_options nolodfade
			#else
			#pragma instancing_options renderinglayer
			#endif

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#define SHADERPASS SHADERPASS_DEPTH_ONLY
			#pragma multi_compile _ WRITE_NORMAL_BUFFER
			#pragma multi_compile _ WRITE_MSAA_DEPTH

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define ATTRIBUTES_NEED_TEXCOORD0
			#define ATTRIBUTES_NEED_TEXCOORD1
			#define ATTRIBUTES_NEED_TEXCOORD2
			#define ATTRIBUTES_NEED_TEXCOORD3
			#define ATTRIBUTES_NEED_COLOR
			#define VARYINGS_NEED_POSITION_WS
			#define VARYINGS_NEED_TANGENT_TO_WORLD
			#define VARYINGS_NEED_TEXCOORD0
			#define VARYINGS_NEED_TEXCOORD1
			#define VARYINGS_NEED_TEXCOORD2
			#define VARYINGS_NEED_TEXCOORD3
			#define VARYINGS_NEED_COLOR

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_local __ _BILLBOARDFACECAMPOS_ON
			#include "Include/GPUInstancerInclude.cginc"
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setupGPUI


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 uv3 : TEXCOORD3;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 interp03 : TEXCOORD3;
				float4 interp04 : TEXCOORD4;
				float4 interp05 : TEXCOORD5;
				float4 interp06 : TEXCOORD6;
				float4 interp07 : TEXCOORD7;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float _IsBillboard;
			float _WindWavesOn;
			float2 _WindVector;
			float _WindWaveSize;
			float _WindIdleSway;
			float _WindWaveSway;
			float _GradientPower;
			float4 _HealthyColor;
			float4 _DryColor;
			float _NoiseSpread;
			float4 _WindWaveTintColor;
			float _WindWaveTint;
			float4 _MainTex_ST;
			float4 _NormalMap_ST;
			float _Metallic;
			float _Smoothness;
			float _AmbientOcclusion;
			float _CutOff;
			float4 _EmissionColor;
			float _RenderQueueType;
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			CBUFFER_END
			sampler2D _WindWaveNormalTexture;
			sampler2D _MainTex;


			
			void BuildSurfaceData(FragInputs fragInputs, inout SmoothSurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);
				surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;

				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif

				float3 normalTS = float3( 0.0f, 0.0f, 1.0f );
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );
				bentNormalWS = surfaceData.normalWS;
				surfaceData.geomNormalWS = fragInputs.tangentToWorld[ 2 ];

				#ifdef _HAS_REFRACTION
				surfaceData.transmittanceMask = 1.0 - surfaceDescription.Alpha;
				surfaceDescription.Alpha = 1.0;
				#endif

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#else
				surfaceData.specularOcclusion = 1.0;
				#endif
				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

			}

			void GetSurfaceAndBuiltinData(SmoothSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				uint3 fadeMaskSeed = asuint( (int3)( V * _ScreenSize.xyx ) );
				LODDitheringTransition( fadeMaskSeed, unity_LODFade.x );
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, surfaceData, bentNormalWS );

				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2( 0.0, 0.0 );
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS Vert(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);

				float BillboardOn261 = (( _IsBillboard )?( 1.0 ):( 0.0 ));
				float4x4 break301 = GetObjectToWorldMatrix();
				float3 appendResult302 = (float3(break301[ 0 ][ 0 ] , break301[ 1 ][ 0 ] , break301[ 2 ][ 0 ]));
				float3 appendResult306 = (float3(break301[ 0 ][ 1 ] , break301[ 1 ][ 1 ] , break301[ 2 ][ 1 ]));
				float3 appendResult307 = (float3(break301[ 0 ][ 2 ] , break301[ 1 ][ 2 ] , break301[ 2 ][ 2 ]));
				float4 appendResult303 = (float4(( float4(inputMesh.positionOS,1).x * length( appendResult302 ) ) , ( float4(inputMesh.positionOS,1).y * length( appendResult306 ) ) , ( float4(inputMesh.positionOS,1).z * length( appendResult307 ) ) , float4(inputMesh.positionOS,1).w));
				float4x4 break278 = UNITY_MATRIX_V;
				float3 appendResult287 = (float3(break278[ 0 ][ 0 ] , break278[ 0 ][ 1 ] , break278[ 0 ][ 2 ]));
				float3 normalizeResult288 = normalize( appendResult287 );
				float3 appendResult295 = (float3(normalizeResult288));
				float3 appendResult314 = (float3(break301[ 0 ][ 3 ] , break301[ 1 ][ 3 ] , break301[ 2 ][ 3 ]));
				float3 normalizeResult504 = normalize( cross( float3(0,1,0) , appendResult314 ) );
				#ifdef _BILLBOARDFACECAMPOS_ON
				float3 staticSwitch496 = normalizeResult504;
				#else
				float3 staticSwitch496 = appendResult295;
				#endif
				float3 appendResult279 = (float3(break278[ 1 ][ 0 ] , break278[ 1 ][ 1 ] , break278[ 1 ][ 2 ]));
				float3 normalizeResult283 = normalize( appendResult279 );
				float3 appendResult296 = (float3(normalizeResult283));
				float temp_output_416_0 = (appendResult296).y;
				float3 break419 = appendResult296;
				float4 appendResult420 = (float4(break419.x , ( temp_output_416_0 * -1.0 ) , break419.z , 0.0));
				#ifdef _BILLBOARDFACECAMPOS_ON
				float4 staticSwitch498 = float4(0,1,0,0);
				#else
				float4 staticSwitch498 = (( temp_output_416_0 > 0.0 ) ? float4( appendResult296 , 0.0 ) :  appendResult420 );
				#endif
				float3 appendResult281 = (float3(break278[ 2 ][ 0 ] , break278[ 2 ][ 1 ] , break278[ 2 ][ 2 ]));
				float3 normalizeResult284 = normalize( appendResult281 );
				float3 appendResult297 = (float3(( normalizeResult284 * -1.0 )));
				float3 appendResult322 = (float3(mul( appendResult303, float4x4(float4( staticSwitch496 , 0.0 ), staticSwitch498, float4( appendResult297 , 0.0 ), float4( 0,0,0,0 )) ).xyz));
				float4 appendResult323 = (float4(( appendResult322 + appendResult314 ) , float4(inputMesh.positionOS,1).w));
				float4 localWorldVar327 = ( float4( _WorldSpaceCameraPos , 0.0 ) + appendResult323 );
				(localWorldVar327).xyz = GetCameraRelativePositionWS((localWorldVar327).xyz);
				float4 transform327 = mul(GetWorldToObjectMatrix(),localWorldVar327);
				float4 BillboardedVertexPos320 = transform327;
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2Dlod( _WindWaveNormalTexture, float4( panner36, 0, 0.0) ), 1.0f );
				float3 FinalWindVectors181 = tex2DNode2;
				float3 break185 = FinalWindVectors181;
				float3 appendResult186 = (float3(break185.x , 0.0 , break185.y));
				float WindIdleSway197 = _WindIdleSway;
				float3 lerpResult230 = lerp( float3( 0,0,0 ) , ( appendResult186 * WindIdleSway197 ) , saturate( inputMesh.positionOS.y ));
				float3 WindIdleSwayCalculated218 = lerpResult230;
				float WindWaveSway191 = _WindWaveSway;
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float2 break206 = ( WindWaveNoise126 * WindDirVector29 );
				float3 appendResult205 = (float3(break206.x , 0.0 , break206.y));
				float3 lerpResult229 = lerp( float3( 0,0,0 ) , ( WindWaveSway191 * 20.0 * appendResult205 ) , saturate( inputMesh.positionOS.y ));
				float3 WindWaveSwayCalculated220 = lerpResult229;
				float3 lerpResult215 = lerp( WindIdleSwayCalculated218 , ( WindIdleSwayCalculated218 + ( WindWaveSwayCalculated220 * -1.0 ) ) , WindWaveNoise126);
				float4 localWorldVar233 = float4( ( _WorldSpaceCameraPos - (( WindWavesOn112 > 0.0 ) ? lerpResult215 :  WindIdleSwayCalculated218 ) ) , 0.0 );
				(localWorldVar233).xyz = GetCameraRelativePositionWS((localWorldVar233).xyz);
				float4 transform233 = mul(GetWorldToObjectMatrix(),localWorldVar233);
				float4 WindVertexOffset183 = transform233;
				float4 FinalVertexPos336 = (( BillboardOn261 > 0.0 ) ? ( BillboardedVertexPos320 + WindVertexOffset183 ) :  ( WindVertexOffset183 + float4(inputMesh.positionOS,1) ) );
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = FinalVertexPos336.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS = float3(0,1,0);
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz = normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				outputPackedVaryingsMeshToPS.interp03.xyzw = inputMesh.uv0;
				outputPackedVaryingsMeshToPS.interp04.xyzw = inputMesh.uv1;
				outputPackedVaryingsMeshToPS.interp05.xyzw = inputMesh.uv2;
				outputPackedVaryingsMeshToPS.interp06.xyzw = inputMesh.uv3;
				outputPackedVaryingsMeshToPS.interp07.xyzw = inputMesh.color;
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );
				return outputPackedVaryingsMeshToPS;
			}

			void Frag(  PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH) // When only WRITE_MSAA_DEPTH is define and not WRITE_NORMAL_BUFFER it mean we are Unlit and only need depth, but we still have normal buffer binded
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif

						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );

				float3 positionRWS  = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;
				float4 texCoord0 = packedInput.interp03.xyzw;
				float4 texCoord1 = packedInput.interp04.xyzw;
				float4 texCoord2 = packedInput.interp05.xyzw;
				float4 texCoord3 = packedInput.interp06.xyzw;
				float4 vertexColor = packedInput.interp07.xyzw;


				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);

				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);
				input.texCoord0 = texCoord0;
				input.texCoord1 = texCoord1;
				input.texCoord2 = texCoord2;
				input.texCoord3 = texCoord3;
				input.color = vertexColor;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				SurfaceData surfaceData;
				BuiltinData builtinData;
				SmoothSurfaceDescription surfaceDescription = (SmoothSurfaceDescription)0;
				float2 uv_MainTex = packedInput.interp03.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode166 = tex2D( _MainTex, uv_MainTex );
				float AlphaCutoff167 = tex2DNode166.a;
				
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Alpha = AlphaCutoff167;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _CutOff;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="Forward" }

			Blend [_SrcBlend] [_DstBlend] , [_AlphaSrcBlend] [_AlphaDstBlend]

			Cull [_CullModeForward]

			ZTest [_ZTestDepthEqualForOpaque]

			ZWrite [_ZWrite]

			Stencil
			{
				Ref [_StencilRef]
				WriteMask [_StencilWriteMask]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			ColorMask [_ColorMaskTransparentVel] 1

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define SHADERPASS_FORWARD_BYPASS_ALPHA_TEST 1
			#define _ALPHATEST_ON 1
			#define _ALPHATEST_SHADOW_ON 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define ASE_SRP_VERSION 70108


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY

			#pragma vertex Vert
			#pragma fragment Frag

			#if defined(_DOTS_INSTANCING)
			#pragma instancing_options nolightprobe
			#pragma instancing_options nolodfade
			#else
			#pragma instancing_options renderinglayer
			#endif

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#define SHADERPASS SHADERPASS_FORWARD
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
			#pragma multi_compile USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST
			#pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH
			//#define USE_CLUSTERED_LIGHTLIST

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define ATTRIBUTES_NEED_TEXCOORD1
			#define ATTRIBUTES_NEED_TEXCOORD2
			#define VARYINGS_NEED_POSITION_WS
			#define VARYINGS_NEED_TANGENT_TO_WORLD
			#define VARYINGS_NEED_TEXCOORD1
			#define VARYINGS_NEED_TEXCOORD2


			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

			#define HAS_LIGHTLOOP

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_RELATIVE_WORLD_POS
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile_local __ _BILLBOARDFACECAMPOS_ON
			#include "Include/GPUInstancerInclude.cginc"
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setupGPUI


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			int _ObjectId;
			int _PassValue;

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 interp03 : TEXCOORD3;
				float4 interp04 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			float _IsBillboard;
			float _WindWavesOn;
			float2 _WindVector;
			float _WindWaveSize;
			float _WindIdleSway;
			float _WindWaveSway;
			float _GradientPower;
			float4 _HealthyColor;
			float4 _DryColor;
			float _NoiseSpread;
			float4 _WindWaveTintColor;
			float _WindWaveTint;
			float4 _MainTex_ST;
			float4 _NormalMap_ST;
			float _Metallic;
			float _Smoothness;
			float _AmbientOcclusion;
			float _CutOff;
			float4 _EmissionColor;
			float _RenderQueueType;
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			CBUFFER_END
			sampler2D _WindWaveNormalTexture;
			sampler2D _HealthyDryNoiseTexture;
			sampler2D _MainTex;
			sampler2D _NormalMap;


			
			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.baseColor =                 surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion = surfaceDescription.SpecularOcclusion;
				#endif
				surfaceData.ambientOcclusion = surfaceDescription.Occlusion;
				surfaceData.metallic = surfaceDescription.Metallic;
				surfaceData.coatMask = surfaceDescription.CoatMask;

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask = surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness = surfaceDescription.IridescenceThickness;
				#endif
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif

				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor = surfaceDescription.Specular;
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif

				float3 normalTS = float3( 0.0f, 0.0f, 1.0f );
				normalTS = surfaceDescription.Normal;
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
				#endif
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				bentNormalWS = surfaceData.normalWS;
				surfaceData.geomNormalWS = fragInputs.tangentToWorld[ 2 ];

				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness = surfaceDescription.Thickness;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask = surfaceDescription.SubsurfaceMask;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash = asuint(surfaceDescription.DiffusionProfile);
				#endif
				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy = surfaceDescription.Anisotropy;
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#else
				surfaceData.specularOcclusion = 1.0;
				#endif
				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription,FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				uint3 fadeMaskSeed = asuint( (int3)( V * _ScreenSize.xyx ) );
				LODDitheringTransition( fadeMaskSeed, unity_LODFade.x );
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				#ifdef _ALPHATEST_ON
				DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, surfaceData, bentNormalWS );

				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				#ifdef _ASE_BAKEDGI
				builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
				#endif

				builtinData.emissiveColor = surfaceDescription.Emission;

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2( 0.0, 0.0 );
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS Vert(AttributesMesh inputMesh )
			{

				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);

				float BillboardOn261 = (( _IsBillboard )?( 1.0 ):( 0.0 ));
				float4x4 break301 = GetObjectToWorldMatrix();
				float3 appendResult302 = (float3(break301[ 0 ][ 0 ] , break301[ 1 ][ 0 ] , break301[ 2 ][ 0 ]));
				float3 appendResult306 = (float3(break301[ 0 ][ 1 ] , break301[ 1 ][ 1 ] , break301[ 2 ][ 1 ]));
				float3 appendResult307 = (float3(break301[ 0 ][ 2 ] , break301[ 1 ][ 2 ] , break301[ 2 ][ 2 ]));
				float4 appendResult303 = (float4(( float4(inputMesh.positionOS,1).x * length( appendResult302 ) ) , ( float4(inputMesh.positionOS,1).y * length( appendResult306 ) ) , ( float4(inputMesh.positionOS,1).z * length( appendResult307 ) ) , float4(inputMesh.positionOS,1).w));
				float4x4 break278 = UNITY_MATRIX_V;
				float3 appendResult287 = (float3(break278[ 0 ][ 0 ] , break278[ 0 ][ 1 ] , break278[ 0 ][ 2 ]));
				float3 normalizeResult288 = normalize( appendResult287 );
				float3 appendResult295 = (float3(normalizeResult288));
				float3 appendResult314 = (float3(break301[ 0 ][ 3 ] , break301[ 1 ][ 3 ] , break301[ 2 ][ 3 ]));
				float3 normalizeResult504 = normalize( cross( float3(0,1,0) , appendResult314 ) );
				#ifdef _BILLBOARDFACECAMPOS_ON
				float3 staticSwitch496 = normalizeResult504;
				#else
				float3 staticSwitch496 = appendResult295;
				#endif
				float3 appendResult279 = (float3(break278[ 1 ][ 0 ] , break278[ 1 ][ 1 ] , break278[ 1 ][ 2 ]));
				float3 normalizeResult283 = normalize( appendResult279 );
				float3 appendResult296 = (float3(normalizeResult283));
				float temp_output_416_0 = (appendResult296).y;
				float3 break419 = appendResult296;
				float4 appendResult420 = (float4(break419.x , ( temp_output_416_0 * -1.0 ) , break419.z , 0.0));
				#ifdef _BILLBOARDFACECAMPOS_ON
				float4 staticSwitch498 = float4(0,1,0,0);
				#else
				float4 staticSwitch498 = (( temp_output_416_0 > 0.0 ) ? float4( appendResult296 , 0.0 ) :  appendResult420 );
				#endif
				float3 appendResult281 = (float3(break278[ 2 ][ 0 ] , break278[ 2 ][ 1 ] , break278[ 2 ][ 2 ]));
				float3 normalizeResult284 = normalize( appendResult281 );
				float3 appendResult297 = (float3(( normalizeResult284 * -1.0 )));
				float3 appendResult322 = (float3(mul( appendResult303, float4x4(float4( staticSwitch496 , 0.0 ), staticSwitch498, float4( appendResult297 , 0.0 ), float4( 0,0,0,0 )) ).xyz));
				float4 appendResult323 = (float4(( appendResult322 + appendResult314 ) , float4(inputMesh.positionOS,1).w));
				float4 localWorldVar327 = ( float4( _WorldSpaceCameraPos , 0.0 ) + appendResult323 );
				(localWorldVar327).xyz = GetCameraRelativePositionWS((localWorldVar327).xyz);
				float4 transform327 = mul(GetWorldToObjectMatrix(),localWorldVar327);
				float4 BillboardedVertexPos320 = transform327;
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2Dlod( _WindWaveNormalTexture, float4( panner36, 0, 0.0) ), 1.0f );
				float3 FinalWindVectors181 = tex2DNode2;
				float3 break185 = FinalWindVectors181;
				float3 appendResult186 = (float3(break185.x , 0.0 , break185.y));
				float WindIdleSway197 = _WindIdleSway;
				float3 lerpResult230 = lerp( float3( 0,0,0 ) , ( appendResult186 * WindIdleSway197 ) , saturate( inputMesh.positionOS.y ));
				float3 WindIdleSwayCalculated218 = lerpResult230;
				float WindWaveSway191 = _WindWaveSway;
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float2 break206 = ( WindWaveNoise126 * WindDirVector29 );
				float3 appendResult205 = (float3(break206.x , 0.0 , break206.y));
				float3 lerpResult229 = lerp( float3( 0,0,0 ) , ( WindWaveSway191 * 20.0 * appendResult205 ) , saturate( inputMesh.positionOS.y ));
				float3 WindWaveSwayCalculated220 = lerpResult229;
				float3 lerpResult215 = lerp( WindIdleSwayCalculated218 , ( WindIdleSwayCalculated218 + ( WindWaveSwayCalculated220 * -1.0 ) ) , WindWaveNoise126);
				float4 localWorldVar233 = float4( ( _WorldSpaceCameraPos - (( WindWavesOn112 > 0.0 ) ? lerpResult215 :  WindIdleSwayCalculated218 ) ) , 0.0 );
				(localWorldVar233).xyz = GetCameraRelativePositionWS((localWorldVar233).xyz);
				float4 transform233 = mul(GetWorldToObjectMatrix(),localWorldVar233);
				float4 WindVertexOffset183 = transform233;
				float4 FinalVertexPos336 = (( BillboardOn261 > 0.0 ) ? ( BillboardedVertexPos320 + WindVertexOffset183 ) :  ( WindVertexOffset183 + float4(inputMesh.positionOS,1) ) );
				
				outputPackedVaryingsMeshToPS.ase_texcoord5 = float4(inputMesh.positionOS,1);
				outputPackedVaryingsMeshToPS.ase_texcoord6.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord6.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = FinalVertexPos336.xyz;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif
				inputMesh.normalOS = float3(0,1,0);
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz = normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				outputPackedVaryingsMeshToPS.interp03.xyzw = inputMesh.uv1;
				outputPackedVaryingsMeshToPS.interp04.xyzw = inputMesh.uv2;
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );
				return outputPackedVaryingsMeshToPS;
			}

			void Frag(PackedVaryingsMeshToPS packedInput,
					#ifdef OUTPUT_SPLIT_LIGHTING
						out float4 outColor : SV_Target0,
						out float4 outDiffuseLighting : SV_Target1,
						OUTPUT_SSSBUFFER(outSSSBuffer)
					#else
						out float4 outColor : SV_Target0
					#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
						, out float4 outMotionVec : SV_Target1
					#endif
					#endif
					#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
					#endif
					
						)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );
				float3 positionRWS = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;
				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);
				input.texCoord1 = packedInput.interp03.xyzw;
				input.texCoord2 = packedInput.interp04.xyzw;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE(packedInput.cullFace, true, false);
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				input.positionSS.xy = _OffScreenRendering > 0 ? (input.positionSS.xy * _OffScreenDownsampleFactor) : input.positionSS.xy;

				uint2 tileIndex = uint2(input.positionSS.xy) / GetTileSize ();

				PositionInputs posInput = GetPositionInput( input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS.xyz, tileIndex );

				float3 normalizedWorldViewDir = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float GradientPower161 = _GradientPower;
				float GradientColor160 = (( 1.0 - GradientPower161 ) + (saturate( packedInput.ase_texcoord5.xyz.y ) - 0.0) * (1.0 - ( 1.0 - GradientPower161 )) / (1.0 - 0.0));
				float WindWavesOn112 = (( _WindWavesOn )?( 1.0 ):( 0.0 ));
				float4 HealthyColor116 = _HealthyColor;
				float4 DryColor118 = _DryColor;
				float3 ase_worldPos = GetAbsolutePositionWS( positionRWS );
				float NoiseSpread351 = _NoiseSpread;
				float div364=256.0/float((int)32.0);
				float4 posterize364 = ( floor( tex2D( _HealthyDryNoiseTexture, ( ( (ase_worldPos).xz * 0.05 ) * NoiseSpread351 ) ) * div364 ) / div364 );
				float4 break365 = posterize364;
				float HealthyDryNoise140 = saturate( sqrt( ( break365.r * break365.g * break365.b ) ) );
				float4 lerpResult59 = lerp( HealthyColor116 , DryColor118 , HealthyDryNoise140);
				float4 HealthyDryTint60 = lerpResult59;
				float4 WindWaveTintColor122 = _WindWaveTintColor;
				float2 WindDirVector29 = _WindVector;
				float mulTime407 = _TimeParameters.x * ( length( WindDirVector29 ) * 0.01 );
				float WindWaveSize128 = _WindWaveSize;
				float2 panner36 = ( mulTime407 * WindDirVector29 + ( ( 1.0 - (0.0 + (WindWaveSize128 - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) * 0.003 * (ase_worldPos).xz ));
				float3 tex2DNode2 = UnpackNormalmapRGorAG( tex2D( _WindWaveNormalTexture, panner36 ), 1.0f );
				float WindWaveNoise126 = saturate( tex2DNode2.g );
				float WindWaveTintPower135 = _WindWaveTint;
				float4 lerpResult82 = lerp( HealthyDryTint60 , WindWaveTintColor122 , saturate( ( WindWaveNoise126 * WindWaveTintPower135 * 5.0 ) ));
				float4 WindWaveTint137 = lerpResult82;
				float2 uv_MainTex = packedInput.ase_texcoord6.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode166 = tex2D( _MainTex, uv_MainTex );
				float4 FinalAlbedo152 = ( GradientColor160 * ( (( WindWavesOn112 > 0.0 ) ? WindWaveTint137 :  HealthyDryTint60 ) * tex2DNode166 ) );
				
				float2 uv_NormalMap = packedInput.ase_texcoord6.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				
				float AmbientOcclusionPower163 = _AmbientOcclusion;
				float clampResult148 = clamp( ( saturate( packedInput.ase_texcoord5.xyz.y ) * AmbientOcclusionPower163 ) , 0.0 , 1.0 );
				float lerpResult150 = lerp( 1.0 , clampResult148 , AmbientOcclusionPower163);
				float AmbientOcclusion151 = lerpResult150;
				
				float AlphaCutoff167 = tex2DNode166.a;
				
				surfaceDescription.Albedo = FinalAlbedo152.rgb;
				surfaceDescription.Normal = UnpackNormalmapRGorAG( tex2D( _NormalMap, uv_NormalMap ), 1.0f );
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = _Metallic;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = 0;
				surfaceDescription.Smoothness = _Smoothness;
				surfaceDescription.Occlusion = AmbientOcclusion151;
				surfaceDescription.Alpha = AlphaCutoff167;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = _CutOff;
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				#ifdef _ASE_BAKEDGI
				surfaceDescription.BakedGI = 0;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				surfaceDescription.BakedBackGI = 0;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				GetSurfaceAndBuiltinData(surfaceDescription,input, normalizedWorldViewDir, posInput, surfaceData, builtinData);

				BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);

				PreLightData preLightData = GetPreLightData(normalizedWorldViewDir, posInput, bsdfData);

				outColor = float4(0.0, 0.0, 0.0, 0.0);

				{
					#ifdef _SURFACE_TYPE_TRANSPARENT
					uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_TRANSPARENT;
					#else
					uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_OPAQUE;
					#endif
					float3 diffuseLighting;
					float3 specularLighting;

					LightLoop( normalizedWorldViewDir, posInput, preLightData, bsdfData, builtinData, featureFlags, diffuseLighting, specularLighting );

					diffuseLighting *= GetCurrentExposureMultiplier();
					specularLighting *= GetCurrentExposureMultiplier();

					#ifdef OUTPUT_SPLIT_LIGHTING
					if( _EnableSubsurfaceScattering != 0 && ShouldOutputSplitLighting( bsdfData ) )
					{
						outColor = float4( specularLighting, 1.0 );
						outDiffuseLighting = float4( TagLightingForSSS( diffuseLighting ), 1.0 );
					}
					else
					{
						outColor = float4( diffuseLighting + specularLighting, 1.0 );
						outDiffuseLighting = 0;
					}
					ENCODE_INTO_SSSBUFFER( surfaceData, posInput.positionSS, outSSSBuffer );
					#else
					outColor = ApplyBlendMode( diffuseLighting, specularLighting, builtinData.opacity );
					outColor = EvaluateAtmosphericScattering( posInput, normalizedWorldViewDir, outColor );
					#endif
					#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					/*VaryingsPassToPS inputPass = UnpackVaryingsPassToPS(packedInput.vpass);
					bool forceNoMotion = any(unity_MotionVectorsParams.yw == 0.0);
					if (forceNoMotion)
					{
						outMotionVec = float4(2.0, 0.0, 0.0, 0.0);
					}
					else
					{
						float2 motionVec = CalculateMotionVector(inputPass.positionCS, inputPass.previousPositionCS);
						EncodeMotionVector(motionVec * 0.5, outMotionVec);
						outMotionVec.zw = 1.0;
					}*/
					#endif
				}

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif
			}

			ENDHLSL
		}
		
	}
	CustomEditor "UnityEditor.Rendering.HighDefinition.HDLitGUI"
	
	
}
/*ASEBEGIN
Version=17800
196.5714;742.8572;1938;810;1587.113;1560.033;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;130;-4776.251,-469.1541;Inherit;False;813.948;1066.223;Wind related parameters;13;191;135;128;122;66;190;132;17;113;197;196;29;28;Wind Parameters;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-4726.808,290.4856;Float;False;Property;_WindWaveSize;Wind Wave Size;1;0;Create;True;0;0;False;0;0.5;0.359;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;28;-4730.966,-416.8831;Float;False;Property;_WindVector;Wind Vector;9;0;Create;True;0;0;False;0;0.4,0.8;0,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-4345.342,290.4856;Float;False;WindWaveSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-3792.662,-258.5315;Inherit;False;2253.782;581.4224;Wind waves noise map calculation;17;402;476;406;404;403;3;8;36;407;381;379;431;31;181;126;454;2;Wind Waves Noise;0.2640571,0.4734817,0.8161765,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-4346.821,-415.7327;Float;False;WindDirVector;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-3478.771,48.08096;Inherit;False;29;WindDirVector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;402;-3768.618,-201.8272;Inherit;False;128;WindWaveSize;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;431;-3230.005,148.1057;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;379;-3266.625,232.4436;Float;False;Constant;_Float13;Float 13;20;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-3766.468,-23.727;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;476;-3501.358,-201.0782;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;381;-3080.107,144.3363;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;406;-3270.251,-160.5732;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;404;-3277.4,-79.08368;Float;False;Constant;_Float0;Float 0;20;0;Create;True;0;0;False;0;0.003;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;8;-3487.779,-31.29717;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;403;-2937.443,-69.18651;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;407;-2938.271,142.419;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;335;-3782.486,-3856.065;Inherit;False;4159.689;1945.435;Billboarding matrix calculations. Native ASE billboarding solution does not allow billboard toggling.;53;319;323;422;315;322;312;303;424;311;309;305;423;308;304;310;299;307;496;306;425;302;498;333;492;417;499;503;420;332;286;505;330;285;502;421;284;419;288;287;281;314;416;301;300;283;331;279;278;271;539;320;562;563;Spherical Billboarding;0.9448276,1,0,1;0;0
Node;AmplifyShaderEditor.PannerNode;36;-2743.686,28.39046;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewMatrixNode;271;-3703.007,-2442.498;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.CommentaryNode;49;-3788.507,-853.5095;Inherit;False;2130.659;501.2978;Healthy/dry color noise map calculation;14;367;140;364;365;353;368;61;65;63;352;53;52;51;50;Healthy/Dry Noise;0.2627451,0.4745098,0.8156863,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;121;-4778.988,-1874.603;Inherit;False;650.0684;815.7568;Color related parameters and AO;10;163;145;161;155;116;118;119;57;351;64;Color Parameters;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-2463.012,-188.7563;Inherit;True;Property;_WindWaveNormalTexture;Wind Wave Normal Texture;0;0;Create;True;0;0;False;0;-1;78384f2a63e207744a3b1821e032ee03;78384f2a63e207744a3b1821e032ee03;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;278;-3549.711,-2443.538;Inherit;False;FLOAT4x4;1;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;64;-4727.625,-1206.72;Float;False;Property;_NoiseSpread;Noise Spread;7;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3762.304,-777.8906;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;279;-3134.316,-2285.431;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;454;-2104.865,-111.5891;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;300;-3619.255,-3547.899;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.CommentaryNode;331;-2726.662,-2336.055;Inherit;False;223;160;UpCamVec;1;296;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;51;-3559.911,-783.0955;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-3563.869,-624.9954;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;224;-3816.575,992.6206;Inherit;False;1812.334;469.6074;Wind wave sway vertex offset calculation;12;460;211;210;220;229;192;208;205;206;199;204;195;Wind Wave Sway;0.1647059,0.5803922,0.1098039,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-1941.614,-60.31606;Float;False;WindWaveNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;351;-4410.191,-1206.771;Float;False;NoiseSpread;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;283;-2978.624,-2285.588;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;301;-3143.544,-3601.687;Inherit;False;FLOAT4x4;1;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;204;-3768.537,1230.474;Inherit;False;29;WindDirVector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;296;-2676.662,-2286.055;Inherit;False;FLOAT3;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-3773.284,1140.805;Inherit;False;126;WindWaveNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;352;-3371.629,-591.4212;Inherit;False;351;NoiseSpread;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-3359.272,-707.178;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;281;-3214.304,-2139.984;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;416;-2410.457,-2385.654;Inherit;False;FLOAT;1;1;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-3444.645,1187.885;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-3163.857,-654.8336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;223;-3793.596,391.8932;Inherit;False;1562.368;497.6409;Wind idle sway vertex offset calculation;9;182;185;186;194;198;187;218;228;230;Wind Idle Sway;0.1661347,0.5808823,0.111051,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;287;-3140.774,-2458.427;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;314;-2729.535,-3163.162;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;181;-1822.424,-187.6183;Float;False;FinalWindVectors;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-4727.42,476.6104;Float;False;Property;_WindWaveSway;Wind Wave Sway;15;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;563;-2397.492,-2922.164;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;206;-3223.668,1184.09;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;196;-4727.118,-281.2434;Float;False;Property;_WindIdleSway;Wind Idle Sway;16;0;Create;True;0;0;False;0;0.6;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;288;-2994.716,-2458.427;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2928.52,-477.6389;Float;False;Constant;_Float2;Float 2;8;0;Create;True;0;0;False;0;32;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;-3020.064,-684.1801;Inherit;True;Property;_HealthyDryNoiseTexture;Healthy Dry Noise Texture;12;0;Create;True;0;0;False;0;-1;5d221d423a7e56d4d8e9bff0c4a73886;5d221d423a7e56d4d8e9bff0c4a73886;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;502;-2342.076,-3048.509;Float;False;Constant;_Vector2;Vector 2;18;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;-4345.42,476.6104;Float;False;WindWaveSway;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-3786.596,491.4998;Inherit;False;181;FinalWindVectors;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;-2192.242,-2271.506;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;419;-2457.462,-2213.921;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;330;-2724.442,-2510.669;Inherit;False;223;160;RightCamVec;1;295;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-3049.156,-2064.004;Float;False;Constant;_Float9;Float 9;18;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;284;-3045.444,-2141.106;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;420;-2020.113,-2216.79;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;295;-2674.442,-2460.669;Inherit;False;FLOAT3;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;460;-2865.781,1110.94;Float;False;Constant;_Float12;Float 12;19;0;Create;True;0;0;False;0;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;208;-2999.599,1317.661;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CrossProductOpNode;503;-2120.728,-2934.482;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;205;-2941.096,1189.462;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-4341.978,-281.2434;Float;False;WindIdleSway;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;185;-3479.431,494.4323;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;505;-1872.738,-2980.478;Inherit;False;236.2856;159.7144;CamPosRightVec;1;504;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;-2934.962,1032.316;Inherit;False;191;WindWaveSway;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;-2871.156,-2142.004;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;332;-2727.366,-2161.76;Inherit;False;223;160;ForwardCamVec;1;297;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosterizeNode;364;-2717.182,-583.5996;Inherit;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;365;-2541.298,-598.0021;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;499;-2108.68,-2652.138;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;210;-2719.327,1363.523;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;297;-2677.366,-2111.761;Inherit;False;FLOAT3;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-3268.898,632.6165;Inherit;False;197;WindIdleSway;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;417;-1842.971,-2390.484;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;492;-1623.725,-2265.632;Float;False;Constant;_Vector1;Vector 1;19;0;Create;True;0;0;False;0;0,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;228;-3135.394,728.7408;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-2660.728,1128.048;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;504;-1822.738,-2930.478;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;186;-3219.063,491.7997;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;333;-1091.653,-2705.52;Inherit;False;310;229;RotationCamMatrix;1;292;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;307;-2732.147,-3311.017;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;367;-2300.131,-598.0877;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;306;-2740.758,-3455.263;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;229;-2492.24,1183.714;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;496;-1476.998,-2704.716;Float;False;Property;_BillboardFaceCamPos;BillboardFaceCamPos;18;0;Create;True;0;0;False;0;1;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;425;-1434.565,-2063.344;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;498;-1477.998,-2607.716;Float;False;Property;_BillboardFaceCamPos;BillboardFaceCamPos;17;0;Create;True;0;0;False;0;1;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-2897.352,561.38;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;302;-2740.745,-3586.998;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;194;-2896.383,735.2308;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.MatrixFromVectors;292;-1041.653,-2655.52;Inherit;False;FLOAT4x4;True;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4x4;0
Node;AmplifyShaderEditor.LengthOpNode;299;-2551.462,-3584.584;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;113;-4740.985,-182.2288;Inherit;False;733.7993;257;Wind waves on/of switch;4;111;109;112;110;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LengthOpNode;310;-2546.153,-3311.216;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;308;-2544.819,-3455.95;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;230;-2695.262,543.3464;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;220;-2299.941,1177.225;Float;False;WindWaveSwayCalculated;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;304;-2619.814,-3806.066;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;222;-2098.119,386.6244;Inherit;False;2126.431;522.8922;Final wind sway vertex offset calculation;13;183;537;378;232;215;348;217;253;219;251;221;252;538;Final Wind Sway;0.1647059,0.5803922,0.1098039,1;0;0
Node;AmplifyShaderEditor.SqrtOpNode;368;-2162.728,-604.8068;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;353;-2042.691,-606.5488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;119;-4729.389,-1604.005;Float;False;Property;_DryColor;Dry Color;2;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;57;-4733.84,-1788.214;Float;False;Property;_HealthyColor;Healthy Color;3;0;Create;True;0;0;False;0;0,1,0.2137935,0;0,1,0.2137935,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;-2520.634,533.9471;Float;False;WindIdleSwayCalculated;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-2242.24,-3694.543;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-4692.985,-54.229;Float;False;Constant;_Float5;Float 5;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-2254.627,-3342.732;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;423;-779.3868,-3127.796;Inherit;False;1;0;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4x4;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-4692.985,-134.2289;Half;False;Constant;_Float4;Float 4;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;-2252.042,-3487.556;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-1956.898,727.6528;Float;False;Constant;_Float3;Float 3;18;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;221;-2070.89,637.7101;Inherit;False;220;WindWaveSwayCalculated;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;142;-2520.286,-1743.023;Inherit;False;829.4101;337.406;Comment;5;117;120;59;60;141;Healthy/Dry Color Tint;1,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-4410.13,-1603.9;Float;False;DryColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;424;-1650.563,-3231.397;Inherit;False;1;0;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4x4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-4410.214,-1787.986;Float;False;HealthyColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-1893.319,-610.5497;Float;False;HealthyDryNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;219;-2058.574,456.0962;Inherit;False;218;WindIdleSwayCalculated;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;303;-1995.092,-3530.697;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-4726.808,386.4854;Float;False;Property;_WindWaveTint;Wind Wave Tint;14;0;Create;True;0;0;False;0;0.5;2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;-1764.451,677.584;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;109;-4516.985,-134.2289;Float;False;Property;_WindWavesOn;Wind Waves On;13;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-2470.285,-1509.009;Inherit;False;140;HealthyDryNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;312;-1778.719,-3487.959;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;-1622.14,754.7783;Inherit;False;126;WindWaveNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-4260.985,-134.2289;Float;False;WindWavesOn;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;139;-3795.29,-1743.729;Inherit;False;1195.445;658.8863;Wind wave tint calculation;9;471;137;82;467;68;469;75;475;472;Wind Waves Color Tint;1,0,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-2450.93,-1681.415;Inherit;False;116;HealthyColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;253;-1625.975,603.92;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-4344.342,385.4854;Float;False;WindWaveTintPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-2450.097,-1592.172;Inherit;False;118;DryColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;475;-3647.967,-1245.409;Float;False;Constant;_Float6;Float 6;17;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;322;-1585.408,-3485.572;Inherit;False;FLOAT3;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-3735.535,-1434.635;Inherit;False;126;WindWaveNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;472;-3740.936,-1342.278;Inherit;False;135;WindWaveTintPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;215;-1382.485,570.9897;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;66;-4724.844,104.6633;Float;False;Property;_WindWaveTintColor;Wind Wave Tint Color;11;0;Create;True;0;0;False;0;0.07586241,0,1,0;0.1586208,0,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;348;-1428.722,425.8489;Inherit;False;112;WindWavesOn;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;59;-2173.735,-1641.303;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-4350.951,104.6633;Float;False;WindWaveTintColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareGreater;378;-1218.428,431.4981;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-4731.271,-1309.276;Float;False;Property;_GradientPower;Gradient Power;6;0;Create;True;0;0;False;0;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-1942.877,-1646.374;Float;False;HealthyDryTint;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;315;-1415.394,-3422.75;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;538;-1000.931,444.8141;Inherit;False;441.8858;411.1006;Counter HDRP Camera Relative Rendering;2;528;527;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;469;-3407.759,-1407.631;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;539;-991.7847,-3789.413;Inherit;False;441.8858;411.1006;Counter HDRP Camera Relative Rendering;2;561;540;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;422;-1868.041,-3799.718;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-4411.19,-1309.714;Float;False;GradientPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;467;-3693.434,-1573.069;Inherit;False;122;WindWaveTintColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;154;-2526.687,-1302.728;Inherit;False;977.8249;329.1819;Gradient color calculation from vertex position;6;160;157;162;159;158;156;Gradient Color Tint;1,0,0,1;0;0
Node;AmplifyShaderEditor.WireNode;537;-1043.565,674.1276;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;540;-965.5344,-3712.799;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;323;-1215.322,-3558.619;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;528;-981.1307,530.9141;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;68;-3692.525,-1669.134;Inherit;False;60;HealthyDryTint;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;471;-3240.305,-1423.247;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;527;-696.5307,759.6861;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;319;-440.2236,-3679.76;Inherit;False;429.1592;208.9326;Nullify billboard rotation;1;327;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;156;-2510.799,-1239.076;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;82;-3053.61,-1617.269;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-2480.034,-1091.541;Inherit;False;161;GradientPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;561;-683.8865,-3510.637;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;232;-511.0064,455.1767;Inherit;False;238.5411;234.6374;Ignore local rotation;1;233;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;265;-4774.624,-918.828;Inherit;False;724;207.9999;Billboarding on/off switch;4;261;262;264;263;Billboard Switch;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;143;-1577.114,-781.0618;Inherit;False;1175.44;314.7707;Simple Ambient Occlusion calculation from vertex position;7;151;150;148;147;146;144;164;Ambient Occlusion;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-4731.818,-1413.143;Float;False;Property;_AmbientOcclusion;Ambient Occlusion;5;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;-4724.624,-788.8282;Float;False;Constant;_Float8;Float 8;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;233;-478.0067,505.1768;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;263;-4724.624,-868.828;Half;False;Constant;_Float7;Float 7;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;327;-325.0796,-3641.329;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;157;-2214.558,-1087.742;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;144;-1558.667,-720.8851;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-4410.496,-1413.83;Float;False;AmbientOcclusionPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-2877.77,-1622.622;Float;False;WindWaveTint;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;174;-1482.725,-269.8707;Inherit;False;1619.745;594.8293;Final albedo input calculation;10;152;167;169;165;168;124;166;138;79;115;Final Albedo;1,0,0,1;0;0
Node;AmplifyShaderEditor.SaturateNode;158;-2311.094,-1192.581;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-1437.37,50.03017;Inherit;False;60;HealthyDryTint;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;146;-1353.961,-706.3902;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;-1553.687,-571.7743;Inherit;False;163;AmbientOcclusionPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;262;-4548.624,-868.828;Float;False;Property;_IsBillboard;IsBillboard;10;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-205.0663,501.9023;Float;False;WindVertexOffset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;159;-1989.005,-1248.63;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;337;-1947.016,999.465;Inherit;False;1208.167;517.2274;Final vertex position calculation including billboarding;8;336;508;329;507;260;328;321;184;Final Vertex Position;0.945098,1,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;320;97.87659,-3644.602;Float;False;BillboardedVertexPos;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-1436.339,-55.21833;Inherit;False;137;WindWaveTint;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-1437.938,-171.5748;Inherit;False;112;WindWavesOn;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;328;-1909.833,1335.326;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;184;-1885.938,1239.871;Inherit;False;183;WindVertexOffset;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;-1914.559,1143.273;Inherit;False;320;BillboardedVertexPos;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-1198.426,-706.3402;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;261;-4292.624,-868.828;Float;False;BillboardOn;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;166;-976.9665,107.9831;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreater;124;-889.1823,-172.5284;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-1758.388,-1251.918;Float;False;GradientColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;329;-1573.375,1313.019;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-625.121,-54.31267;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;507;-1841.535,1059.113;Inherit;False;261;BillboardOn;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-593.7906,-162.1037;Inherit;False;160;GradientColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;148;-1033.728,-706.1402;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;260;-1559.46,1160.964;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-348.091,-77.4103;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;150;-854.926,-664.4952;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;508;-1287.955,1116.056;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;562;-3064.983,-2985.887;Inherit;False;598.2461;408.7903;RHS disabled because of HDRP Camera Relative Rendering;2;501;500;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;336;-1000.557,1111.408;Float;False;FinalVertexPos;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-573.6011,199.7374;Float;False;AlphaCutoff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;-111.85,-83.31852;Float;False;FinalAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-650.64,-670.0631;Float;False;AmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;522;-991.801,-1642.875;Inherit;False;Property;_Metallic;Metallic;20;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;520;-1014.801,-1271.875;Inherit;False;Property;_CutOff;CutOff;18;0;Create;True;0;0;False;0;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;521;-995.801,-1550.875;Inherit;False;Property;_Smoothness;Smoothness;19;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;500;-3003.782,-2746.954;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;175;-933.5609,-1806.337;Inherit;False;152;FinalAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-936.7034,-1461.352;Inherit;False;151;AmbientOcclusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;501;-2621.822,-2927.887;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;257;-1300.46,-1780.727;Inherit;True;Property;_NormalMap;Normal Map;8;0;Create;True;0;0;False;0;-1;None;c6607b9d4c0768e40916d8784d721f09;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;338;-931.9393,-1174.697;Inherit;False;336;FinalVertexPos;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;176;-914.3837,-1088.178;Float;False;Constant;_VegetationNormal;Vegetation Normal;19;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;173;-948.9078,-1357.975;Inherit;False;167;AlphaCutoff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;519;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Forward;0;10;Forward;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;0;True;-18;0;True;-19;1;0;True;-20;0;True;-21;False;False;True;0;True;-25;False;True;True;0;True;-3;255;False;-1;255;True;-4;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;0;True;-22;True;0;True;-27;False;True;1;LightMode=Forward;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;518;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentDepthPostpass;0;9;TransparentDepthPostpass;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;True;0;True;-23;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=TransparentDepthPostpass;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;510;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;META;0;1;META;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;512;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;SceneSelectionPass;0;3;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;516;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentBackface;0;7;TransparentBackface;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;0;True;-18;0;True;-19;1;0;True;-20;0;True;-21;False;False;True;1;False;-1;False;False;True;0;True;-22;True;0;True;-28;False;True;1;LightMode=TransparentBackface;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;509;-616.888,-1637.674;Float;False;True;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;GPUInstancer/FoliageHDRP;53b46d85872c5b24c8f4f0a1c3fe4c87;True;GBuffer;0;0;GBuffer;35;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;520;False;True;True;0;True;-12;255;False;-1;255;True;-11;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;0;True;-13;False;True;1;LightMode=GBuffer;False;4;Include;;False;;Native;Include;Include/GPUInstancerInclude.cginc;False;;Custom;Pragma;multi_compile_instancing;False;;Custom;Pragma;instancing_options procedural:setupGPUI;False;;Custom;;0;0;Standard;29;Surface Type;0;  Rendering Pass;1;  Refraction Model;0;    Blending Mode;0;    Blend Preserves Specular;1;  Receive Fog;1;  Back Then Front Rendering;0;  Transparent Depth Prepass;0;  Transparent Depth Postpass;0;  Transparent Writes Motion Vector;0;  Distortion;0;    Distortion Mode;0;    Distortion Depth Test;1;  ZWrite;0;  Z Test;4;Double-Sided;1;Alpha Clipping;1;  Use Shadow Threshold;1;Material Type,InvertActionOnDeselection;0;  Energy Conserving Specular;1;  Transmission;1;Receive Decals;1;Receives SSR;1;Specular AA;0;Specular Occlusion Mode;0;Override Baked GI;0;Depth Offset;0;DOTS Instancing;0;Vertex Position;0;0;11;True;True;True;True;True;False;False;False;False;False;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;514;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Motion Vectors;0;5;Motion Vectors;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-23;False;True;True;0;True;-7;255;False;-1;255;True;-8;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;False;False;True;1;LightMode=MotionVectors;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;513;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;DepthOnly;0;4;DepthOnly;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-23;False;True;True;0;True;-5;255;False;-1;255;True;-6;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;511;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-23;True;False;False;False;False;0;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;517;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentDepthPrepass;0;8;TransparentDepthPrepass;1;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;True;0;True;-23;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=TransparentDepthPrepass;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;515;-616.888,-1637.674;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;2;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Distortion;0;6;Distortion;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;True;1;False;-1;1;False;-1;False;False;False;True;True;0;True;-9;255;False;-1;255;True;-9;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;False;True;1;LightMode=DistortionVectors;False;0;;0;0;Standard;0;0
WireConnection;128;0;17;0
WireConnection;29;0;28;0
WireConnection;431;0;31;0
WireConnection;476;0;402;0
WireConnection;381;0;431;0
WireConnection;381;1;379;0
WireConnection;406;0;476;0
WireConnection;8;0;3;0
WireConnection;403;0;406;0
WireConnection;403;1;404;0
WireConnection;403;2;8;0
WireConnection;407;0;381;0
WireConnection;36;0;403;0
WireConnection;36;2;31;0
WireConnection;36;1;407;0
WireConnection;2;1;36;0
WireConnection;278;0;271;0
WireConnection;279;0;278;4
WireConnection;279;1;278;5
WireConnection;279;2;278;6
WireConnection;454;0;2;2
WireConnection;51;0;50;0
WireConnection;126;0;454;0
WireConnection;351;0;64;0
WireConnection;283;0;279;0
WireConnection;301;0;300;0
WireConnection;296;0;283;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;281;0;278;8
WireConnection;281;1;278;9
WireConnection;281;2;278;10
WireConnection;416;0;296;0
WireConnection;199;0;195;0
WireConnection;199;1;204;0
WireConnection;63;0;53;0
WireConnection;63;1;352;0
WireConnection;287;0;278;0
WireConnection;287;1;278;1
WireConnection;287;2;278;2
WireConnection;314;0;301;3
WireConnection;314;1;301;7
WireConnection;314;2;301;11
WireConnection;181;0;2;0
WireConnection;563;0;314;0
WireConnection;206;0;199;0
WireConnection;288;0;287;0
WireConnection;61;1;63;0
WireConnection;191;0;190;0
WireConnection;421;0;416;0
WireConnection;419;0;296;0
WireConnection;284;0;281;0
WireConnection;420;0;419;0
WireConnection;420;1;421;0
WireConnection;420;2;419;2
WireConnection;295;0;288;0
WireConnection;503;0;502;0
WireConnection;503;1;563;0
WireConnection;205;0;206;0
WireConnection;205;2;206;1
WireConnection;197;0;196;0
WireConnection;185;0;182;0
WireConnection;286;0;284;0
WireConnection;286;1;285;0
WireConnection;364;1;61;0
WireConnection;364;0;65;0
WireConnection;365;0;364;0
WireConnection;499;0;295;0
WireConnection;210;0;208;2
WireConnection;297;0;286;0
WireConnection;417;0;416;0
WireConnection;417;2;296;0
WireConnection;417;3;420;0
WireConnection;211;0;192;0
WireConnection;211;1;460;0
WireConnection;211;2;205;0
WireConnection;504;0;503;0
WireConnection;186;0;185;0
WireConnection;186;2;185;1
WireConnection;307;0;301;2
WireConnection;307;1;301;6
WireConnection;307;2;301;10
WireConnection;367;0;365;0
WireConnection;367;1;365;1
WireConnection;367;2;365;2
WireConnection;306;0;301;1
WireConnection;306;1;301;5
WireConnection;306;2;301;9
WireConnection;229;1;211;0
WireConnection;229;2;210;0
WireConnection;496;1;499;0
WireConnection;496;0;504;0
WireConnection;425;0;297;0
WireConnection;498;1;417;0
WireConnection;498;0;492;0
WireConnection;187;0;186;0
WireConnection;187;1;198;0
WireConnection;302;0;301;0
WireConnection;302;1;301;4
WireConnection;302;2;301;8
WireConnection;194;0;228;2
WireConnection;292;0;496;0
WireConnection;292;1;498;0
WireConnection;292;2;425;0
WireConnection;299;0;302;0
WireConnection;310;0;307;0
WireConnection;308;0;306;0
WireConnection;230;1;187;0
WireConnection;230;2;194;0
WireConnection;220;0;229;0
WireConnection;368;0;367;0
WireConnection;353;0;368;0
WireConnection;218;0;230;0
WireConnection;305;0;304;1
WireConnection;305;1;299;0
WireConnection;311;0;304;3
WireConnection;311;1;310;0
WireConnection;423;0;292;0
WireConnection;309;0;304;2
WireConnection;309;1;308;0
WireConnection;118;0;119;0
WireConnection;424;0;423;0
WireConnection;116;0;57;0
WireConnection;140;0;353;0
WireConnection;303;0;305;0
WireConnection;303;1;309;0
WireConnection;303;2;311;0
WireConnection;303;3;304;4
WireConnection;251;0;221;0
WireConnection;251;1;252;0
WireConnection;109;0;110;0
WireConnection;109;1;111;0
WireConnection;312;0;303;0
WireConnection;312;1;424;0
WireConnection;112;0;109;0
WireConnection;253;0;219;0
WireConnection;253;1;251;0
WireConnection;135;0;132;0
WireConnection;322;0;312;0
WireConnection;215;0;219;0
WireConnection;215;1;253;0
WireConnection;215;2;217;0
WireConnection;59;0;117;0
WireConnection;59;1;120;0
WireConnection;59;2;141;0
WireConnection;122;0;66;0
WireConnection;378;0;348;0
WireConnection;378;2;215;0
WireConnection;378;3;219;0
WireConnection;60;0;59;0
WireConnection;315;0;322;0
WireConnection;315;1;314;0
WireConnection;469;0;75;0
WireConnection;469;1;472;0
WireConnection;469;2;475;0
WireConnection;422;0;304;4
WireConnection;161;0;155;0
WireConnection;537;0;378;0
WireConnection;323;0;315;0
WireConnection;323;3;422;0
WireConnection;471;0;469;0
WireConnection;527;0;528;0
WireConnection;527;1;537;0
WireConnection;82;0;68;0
WireConnection;82;1;467;0
WireConnection;82;2;471;0
WireConnection;561;0;540;0
WireConnection;561;1;323;0
WireConnection;233;0;527;0
WireConnection;327;0;561;0
WireConnection;157;0;162;0
WireConnection;163;0;145;0
WireConnection;137;0;82;0
WireConnection;158;0;156;2
WireConnection;146;0;144;2
WireConnection;262;0;263;0
WireConnection;262;1;264;0
WireConnection;183;0;233;0
WireConnection;159;0;158;0
WireConnection;159;3;157;0
WireConnection;320;0;327;0
WireConnection;147;0;146;0
WireConnection;147;1;164;0
WireConnection;261;0;262;0
WireConnection;124;0;115;0
WireConnection;124;2;138;0
WireConnection;124;3;79;0
WireConnection;160;0;159;0
WireConnection;329;0;184;0
WireConnection;329;1;328;0
WireConnection;165;0;124;0
WireConnection;165;1;166;0
WireConnection;148;0;147;0
WireConnection;260;0;321;0
WireConnection;260;1;184;0
WireConnection;169;0;168;0
WireConnection;169;1;165;0
WireConnection;150;1;148;0
WireConnection;150;2;164;0
WireConnection;508;0;507;0
WireConnection;508;2;260;0
WireConnection;508;3;329;0
WireConnection;336;0;508;0
WireConnection;167;0;166;4
WireConnection;152;0;169;0
WireConnection;151;0;150;0
WireConnection;501;0;314;0
WireConnection;501;1;500;0
WireConnection;509;0;175;0
WireConnection;509;1;257;0
WireConnection;509;4;522;0
WireConnection;509;7;521;0
WireConnection;509;8;153;0
WireConnection;509;9;173;0
WireConnection;509;10;520;0
WireConnection;509;30;520;0
WireConnection;509;11;338;0
WireConnection;509;12;176;0
ASEEND*/
//CHKSM=69F249D8F2BA7DC01482102EAE6C3346FA57C4B1