Shader "Custom/WriteBackFaceDistance"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            Cull Front
            ZTest Less
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float distanceToCamera: TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.distanceToCamera = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                return float4(i.distanceToCamera, 0 , 0, 1);
            }
            ENDCG
        }
    }
}