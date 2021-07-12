Shader "Custom/RadiusShader"
{
    Properties
    {
        _MainTex("MaintTex",2D) = "white"{}  
       _Center("Center",Vector) = (200,0,200,0)
       _Radius("Radius",Float) = 100
       _RadiusColorA("Radius Color",Color) = (0,0,1,1)
       _RadiusColorB("Radius Color",Color) = (1,0,0,1)
       _ColorControl("ControlColor",Range(0,1))=.5
       _RadiusWidth("Radius Width",Float) = 10

    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0


        sampler2D _MainTex;
        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        float3 _Center; //re declare the values
        float _Radius;
        float  _ColorControl;
        float4 _RadiusColorA;
        float4 _RadiusColorB;
        float _RadiusWidth;
      

      
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float d = distance(_Center, IN.worldPos); // we get the distance from the center to the world position 
            float3 LerpColor = lerp(_RadiusColorA, _RadiusColorB, _ColorControl);
            if (d > _Radius && d < (_Radius + _RadiusWidth)) //if the distance is greater than the radius but smaller than the width then we show the color // so we form a circle
            {
                o.Albedo = LerpColor;
            }
            else {
                o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb; //otherwise we display the normal color
            }

        }
        ENDCG
    }
    FallBack "Diffuse"
}
