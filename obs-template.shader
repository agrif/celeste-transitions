// -*- mode: c -*-

// for streamfx
// https://github.com/Xaymar/obs-StreamFX/

uniform float4x4 ViewProj<bool automatic = true;>;
uniform float4 ViewSize<bool automatic = true;>;
uniform texture2d InputA<bool automatic = true;>;
uniform texture2d InputB<bool automatic = true;>;
uniform float TransitionTime<bool automatic = true;>;
uniform float4x4 Random<bool automatic = true;>;

{{ uniforms }}

#define ratio getRatio()
#define progress TransitionTime
#define seed Random[0][1]
#define mix(a, b, p) lerp(a, b, p)
#define fract(x) frac(x)
#define atan(y, x) atan2(y, x)

sampler_state textureSampler {
    Filter   = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

float getRatio() {
    return ViewSize.x / ViewSize.y;
}

float4 getFromColor(float2 uv) {
    uv.y = 1.0 - uv.y;
    return float4(InputA.Sample(textureSampler, uv).rgb, 1.0);
}

float4 getToColor(float2 uv) {
    uv.y = 1.0 - uv.y;
    return float4(InputB.Sample(textureSampler, uv).rgb, 1.0);
}

{{ body }}

struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

VertData mainTransform(VertData vert_in)
{
    VertData vert_out;
    vert_out.pos = mul(float4(vert_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = vert_in.uv;
    return vert_out;
}

float4 mainImage(VertData vert_in) : TARGET
{
    return transition(float2(vert_in.uv.x, 1.0 - vert_in.uv.y));
}

technique Draw
{
    pass
    {
        vertex_shader = mainTransform(vert_in);
        pixel_shader  = mainImage(vert_in);
    }
}
