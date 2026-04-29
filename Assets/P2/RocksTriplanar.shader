Shader "Custom/URP_RocksTriplanar"
{
    Properties
    {
        _MainTex ("Textura Roca", 2D) = "white" {}
        _Tiling ("Escala Textura", Float) = 1.0
        [Toggle(_LOCAL_COORDS_ON)] _UseLocal ("Usar Coordenadas Locales", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }
        LOD 100

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode"="UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ _LOCAL_COORDS_ON

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float3 positionWS   : TEXCOORD0;
                float3 normalWS     : TEXCOORD1;
                float3 positionOS   : TEXCOORD2;
                float3 normalOS     : TEXCOORD3;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float _Tiling;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                OUT.positionOS = IN.positionOS.xyz;
                OUT.normalOS = IN.normalOS;
                
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float3 pos;
                float3 norm;

                #if defined(_LOCAL_COORDS_ON)
                    pos = IN.positionOS;
                    norm = IN.normalOS;
                #else
                    pos = IN.positionWS;
                    norm = IN.normalWS;
                #endif

                pos *= _Tiling;

                float3 blendWeights = abs(norm);
                blendWeights = blendWeights / (blendWeights.x + blendWeights.y + blendWeights.z);

                float2 uvX = pos.zy;
                float2 uvY = pos.xz;
                float2 uvZ = pos.xy;

                half4 colX = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uvX);
                half4 colY = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uvY);
                half4 colZ = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uvZ);

                half4 finalColor = colX * blendWeights.x + colY * blendWeights.y + colZ * blendWeights.z;

                return finalColor;
            }
            ENDHLSL
        }
    }
}