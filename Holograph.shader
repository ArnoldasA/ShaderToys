Shader "Custom/Holograph"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DotProduct("Rim effect",Range(-1,1))=.25
       
    }
    SubShader
    {
        Tags 
        { 
         "RenderType"="Transparent"
         "Queue"="Transparent"
         "IgnoreProjector"="True"
    
    
    }
        LOD 200
        Cull Off
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert alpha:fade nolightning //As this wont take lighting we can make it a lambert and then we fade and say there is no light

        
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal; //world normal direction 
            float3 viewDir; // camera veiw direction
        };

        float _DotProduct;
        fixed4 _Color;

      
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            
            float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
            float alpha = (border * (1 - _DotProduct) + _DotProduct);
          
            o.Alpha = c.a*alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
