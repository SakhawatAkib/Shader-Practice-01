Shader "Unlit/Vertex Offset"
{
    Properties{ //input data
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
//        _Scale ("UV Scale", Float ) = 1
//        _Offset ("UV Offset",  Float ) = 0
        _ColorStart ("Color Start", Range(0,1) ) = 0
        _ColorEnd ("Color End", Range(0,1) ) = 1
        _WaveAmp ("Wave Amplitude", Range(0,0.2) ) = 0.1
    }
        SubShader{
            Tags { 
                "RenderType" = "Opaque"  // tag to inform the render pipeline of what type this is 
                "Queue" = "Geometry"  // changes the render order
            }


            Pass{
                // pass tags
                
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag


                #include "UnityCG.cginc"

                #define TAU 6.28318530718

                float4 _ColorA;
                float4 _ColorB;
                // float _Scale;
                // float _Offset;
                float _ColorStart; 
                float _ColorEnd;
                float _WaveAmp;

            // automatically filled out by Unity
            struct MeshData { // per-vertex mesh data
                float4 vertex : POSITION; // local space vertex position
                float3 normals : NORMAL; // local space normal direction
                // float4 tangent : TANGENT; // tangent direction (xyz) tangent sign (w)
                // float4 color : COLOR; // vertex colors
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
                // float4 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinates
                // float4 uv2 : TEXCOORD2; // uv2 coordinates lightmap coordinates
                // float4 uv3 : TEXCOORD3; // uv3 coordinates lightmap coordinates
            };

            struct Interpolators {
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                // float2  tangent : TEXCOORD2;
                // float2 justSomeValues : TEXCOORD3;
            };

            Interpolators vert (MeshData v){
                Interpolators o;


                float wave = cos( (v.uv0.y - _Time.y * 0.04) * TAU * 5);
                v.vertex.y = wave * _WaveAmp;
                
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                // o.normal = mul( (float3x3)UNITY_MATRIX_M, v.normals); //mul( (float3x3)unity_ObjectToWorld, v.normals); //mul(v.normals, (float3x3)unity_WorldToObject ); //UnityObjectToWorldNormal(v.normals) ; // just pass through
                o.normal = UnityObjectToWorldNormal(v.normals) ;
                // o.normal = v.normals;
                o.uv = v.uv0; // (v.uv0 + _Offset) * _Scale; // passthrough
                return o;
            }

                // bool 0 1
                // int
                // float (32 bit float)
                // half (16 bit float)
                // fixed (lower precision) -1 to 1
                // float4 -> half4 -> fixed4
                // float4x4 -> half4x4 ( C#: Matrix4x4)



            float InverseLerp( float a, float b, float v){
                return (v-a)/(b-a);
            }
                

            fixed4 frag (Interpolators i) : SV_Target {


                float wave = cos( (i.uv.y - _Time.y * 0.04) * TAU * 5) * 0.5 + 0.5;
                return wave;
                
                
            }
            ENDCG
        }
    }
}
