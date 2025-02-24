Shader "Custom/FrontFaceWithThickness"
{
    Properties
    {
        _ThicknessMultiplier ("Thickness Multiplier", Range(0,10)) = 0.1
        _BaseColor ("Base Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags { "LightMode"="UniversalForward" "RenderType" = "Transparent" }
        Pass
        {
            Cull Back
            ZWrite Off
            ZTest Less
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _BackfaceDepthTexture;
            float _ThicknessMultiplier;
            float4 _BaseColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv: TEXCOORD0;
                float4 worldPos: TEXCOORD1;
                float4 screenPos : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.pos);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.screenPos.xy / i.screenPos.w;
                float backFaceDistance = tex2D(_BackfaceDepthTexture, uv).r;
                float frontFaceDistance = distance(i.worldPos, _WorldSpaceCameraPos);

                float thickness = (backFaceDistance - frontFaceDistance) * _ThicknessMultiplier;
                thickness = saturate(abs(thickness));
                return float4(1.0, 1.0, 1.0, thickness);
            }
            ENDCG
        }
    }
}