Shader "Raymarch/Mandelbulb"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Power("Power", Range(0,100)) = 0 //power of the mandelbulb set
        
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

            #define MAX_STEPS 300
            #define MAX_DIST 100
            #define SURF_DIST 1e-3
            #define NO_OF_BALLS 10
            #define RADIUS 0.8

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 ro : TEXCOORD1;
                float3 hitPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Power;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.ro = _WorldSpaceCameraPos;
                o.hitPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float3 mod(float3 x, float y)
            {
                return float3(x.x - y * floor(x.x/y), x.y - y * floor(x.y/y), x.z - y * floor(x.z/y));
            }

            float GetDist( float3 p, float radius)
            {
                float power = _Time;
                float3 z = p;
                float dr = 1;
                float r;

                for(int i = 0; i < 15; i++)
                {
                    r = length(z);
                    if(r > 2)
                        break;

                    float theta = acos(z.z/r) * power;
                    float phi = atan2(z.y,z.x) * power;
                    float zr = pow(r,power);
                    dr = pow(r, power - 1) * power * dr + 1;

                    z = zr * float3(sin(theta) * cos(phi), sin(phi) * sin(theta), cos(theta));
                    z += p;
                }
                return 0.5 * log(r) * r/ dr;
            }

            float3 GetNormal(float3 p, float radius)
            {
                float2 e = float2(1e-4, 0);
                float3 n = GetDist(p, radius) - float3(GetDist(p-e.xyy, radius),GetDist(p-e.yxy, radius),GetDist(p-e.yyx, radius));
                return normalize(float3(n.y,n.x,n.z));
            }

            float Raymarch2(float3 ro, float3 rd)
            {
                float4 col;
                float3 n;
                float dO = 0;
                float dS;
                for(int i = 0; i < MAX_STEPS; i++)
                {
                    float3 p = ro + dO * rd;
                    dS = GetDist(p, RADIUS);
                    dO += dS;
                    if(dS < SURF_DIST || dO > MAX_DIST)
                    {
                        return i/(float) 100;
                        break;
                    }
                }
                return 1;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv - 0.5; //Centering UV to center

                float3 ro = i.ro;
                float3 rd = normalize(i.hitPos - ro);   //(float3(uv.x,uv.y,1));
                
                float d = Raymarch2(ro, rd);
                fixed4 col = 0;
                /*
                Try to put col.(anything) = d, and different colors should appear
                */
                col.bg = d;
                return col;
            }

















































            // float4 Raymarch2(float3 ro, float3 rd)
            // {
            //     float4 col;
            //     float3 n;
            //     float dO = 0;
            //     float dS;
            //     for(int i = 0; i < MAX_STEPS; i++)
            //     {
            //         float3 p = ro + dO * rd;
            //         float minDist = 100;
            //         float currDist;
            //         for(int a = 0; a < 10; a+=2)
            //         {
            //             for(int b = 0; b < 10; b+=2)
            //             {
            //                 for(int c = 0; c < 10; c+=2)
            //                 {
            //                     currDist = GetDist(p, float3(a,b,c), .5);
            //                     if(currDist < minDist)
            //                     {
            //                         minDist = currDist;
            //                         n = GetNormal(p, float3(a,b,c), .5);
            //                     }
            //                 }
            //             }
            //         }
            //         dS = minDist;
            //         dO += dS;
            //         if(dS < SURF_DIST || dO > MAX_DIST)
            //         {
            //             break;
            //         }
            //     }
            //     col.r = dO;
            //     col.gba = n;
            //     return col;
            // }


            // fixed4 frag (v2f i) : SV_Target
            // {
            //     float2 uv = i.uv - 0.5;

            //     float3 ro = i.ro;
            //     float3 rd = normalize(i.hitPos - ro);   //(float3(uv.x,uv.y,1));
                
            //     float4 color = Raymarch2(ro, rd);
            //     float d = color.x;
            //     fixed4 col = 0;

            //     if(d >= MAX_DIST)
            //     {
            //         // discard;
            //     }else
            //     {
            //         float3 p = ro + rd * d;
            //         float3 n = color.yzw;
            //         col.rgb = n;

            //     }
            //     // col.rgb=rd;
            //     return col;
            // }
            ENDCG
        }
    }
}
