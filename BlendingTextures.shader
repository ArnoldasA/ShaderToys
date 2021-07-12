Shader "Custom/BlendingTextures"
{
    Properties
    {
        _MainTint("Diffuse Tint",Color) = (1,1,1,1)
        _ColorA ("Terrain Color A", Color) = (1,1,1,1)
        _ColorB("Terrain Color B", Color) = (1,1,1,1)
        _RTex ("Red texture values", 2D) = "white" {}
        _GTex("Green texture values", 2D) = "white" {}
        _BTex("Blue texture values", 2D) = "white" {}
        _ATex("Alpha texture values", 2D) = "white" {}
        _BlendTex("Blend texture values", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        
        #pragma target 3.5

        sampler2D _RTex;
        sampler2D _GTex;
        sampler2D _BTex;
        sampler2D _ATex;
        sampler2D _BlendTex;


        struct Input
        {
            float2 uv_RTex;
            float2 uv_GTex;
            float2 uv_BTex;
            float2 uv_ATex;
            float2 uv_BlendTex;
        };

        float4 _MainTint;
        float4 _ColorA;
        float4 _ColorB;

        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            //getting the blend text values 
            float4 BlendData = tex2D(_BlendTex, IN.uv_BlendTex);
            float4 RedData = tex2D(_RTex, IN.uv_RTex);
            float4 BlueData = tex2D(_BTex, IN.uv_BTex);
            float4 GreenData = tex2D(_GTex, IN.uv_GTex);
            float4 AlphaData = tex2D(_ATex, IN.uv_ATex);

            float4 FinalColor;
            FinalColor = lerp(RedData, GreenData, BlendData.g); //Lerp over each value in the final color to get a single blended texute
            FinalColor = lerp(FinalColor, BlueData, BlendData.b);
            FinalColor = lerp(FinalColor, AlphaData, BlendData.a);
            FinalColor.a = 1;
          
            //Add terrain tinting colors
            float4 TerrainTintColor = lerp(_ColorA, _ColorB, BlendData.r);//We can tint the blends r channel by lerping through colora a and b
            FinalColor *= TerrainTintColor;//we input the terraint tint into our final color
            FinalColor = saturate(FinalColor);//returns the smallest interger value
            o.Albedo = FinalColor.rgb * _MainTint.rgb;//our final albedo is the final color plus the terraint tint
            o.Alpha = FinalColor.a;//final color alpha

        }
        ENDCG
    }
    FallBack "Diffuse"
}
