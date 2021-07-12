Shader "Unlit/ToonShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Brightness("Brightness",Range(0,1))=0.3 //light birght
        _Strength("Strength",Range(0,1))=0.5 // strength of the toon shader effect
        _Color("Color",Color)=(1,1,1,1) //Tinting the Object
        _Color2("Color 2", Color) = (0,0,0,1)
        _Detail("Detail",Range(0,1))=0.3 //how detailed is our toon shader
       
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
         

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal :NORMAL; 
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                half3 worldNormal : NORMAL;
                float4 vertex : SV_POSITION;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Brightness;
            float _Strength;
            float4 _Color;
            float4 _Color2;
            float _Detail;
         

            float Toon(float3 normal , float3 lightDir)
            {
                float NdotL = max(0.0,dot(normalize(normal), normalize(lightDir)));
                //<0 shadows
                //if dot product is less than zero then NdotL will be zero
                return floor(NdotL/_Detail);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                
               // o.uv = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.vertex.xy / i.vertex.w;
                _Color.rgb = LinearToGammaSpace(_Color);
                _Color2.rgb = LinearToGammaSpace(_Color2);
                half4 tol = lerp(_Color2, _Color, uv.y);
                tol.rgb = GammaToLinearSpace(tol);
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
              
            col *= Toon(i.worldNormal,_WorldSpaceLightPos0.xyz)*_Strength+tol+_Brightness; //get the world normal and get ther light posisiton to cast for the toon shader
                return col;
            }
            ENDCG
        }
            Pass
        {
            Name "CastShadow"
            Tags { "LightMode" = "ShadowCaster" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct v2f
            {
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
