Shader "Custom/URP_VertexPaintTerrain"
{
    Properties
    {
        _MainTex ("Tierra (Base)", 2D) = "white" {}
        _GrassTex ("Hierba (Canal Rojo)", 2D) = "white" {}
        _SnowTex ("Nieve (Canal Verde)", 2D) = "white" {}
        _Height ("Altura Montaña (Canal Azul)", Range(-10, 10)) = 5.0
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

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float2 uv           : TEXCOORD0;
                float4 color        : COLOR;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float2 uv           : TEXCOORD0;
                float4 color        : COLOR;
            };

            TEXTURE2D(_MainTex);    SAMPLER(sampler_MainTex);
            TEXTURE2D(_GrassTex);   SAMPLER(sampler_GrassTex);
            TEXTURE2D(_SnowTex);    SAMPLER(sampler_SnowTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float _Height;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                float3 displacedPos = IN.positionOS.xyz + (IN.normalOS * IN.color.b * _Height);

                OUT.positionHCS = TransformObjectToHClip(displacedPos);
                
                OUT.uv = TRANSFORM_TEX(IN.uv, _MainTex);
                OUT.color = IN.color; 

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 colorTierra = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                half4 colorHierba = SAMPLE_TEXTURE2D(_GrassTex, sampler_GrassTex, IN.uv);
                half4 colorNieve  = SAMPLE_TEXTURE2D(_SnowTex, sampler_SnowTex, IN.uv);

                half4 colorFinal = lerp(colorTierra, colorHierba, IN.color.r);
                
                colorFinal = lerp(colorFinal, colorNieve, IN.color.g);

                return colorFinal;
            }
            ENDHLSL
        }
    }
}