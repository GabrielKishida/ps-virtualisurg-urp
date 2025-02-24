Shader "Custom/BackFaceAdd"
{
    Properties
    {
        _ThicknessMultiplier ("Thickness Multiplier", Range(0,10)) = 0.1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent"
            "Queue"="Transparent" 
            "RenderPipeline"="UniversalRenderPipeline"
        }

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode"="UniversalForward" "RenderQueue" = "2000"}

            Cull Front
            ZTest Always
            Blend One One 

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_BackfaceDepthTexture);
            SAMPLER(sampler_BackfaceDepthTexture);

            float _ThicknessMultiplier;
            float4 _BaseColor;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 screenPos : TEXCOORD0;
                float frontFaceDistance: TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = TransformObjectToHClip(v.vertex.xyz);
                o.screenPos = ComputeScreenPos(o.pos);
                o.frontFaceDistance = distance(_WorldSpaceCameraPos, mul(UNITY_MATRIX_M, v.vertex).xyz) * _ThicknessMultiplier;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                return float4(i.frontFaceDistance, i.frontFaceDistance, i.frontFaceDistance, 1);
            }
            ENDHLSL
        }


    }
}