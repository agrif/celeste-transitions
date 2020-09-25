uniform float4x4 ViewProj;
uniform texture2d image_0;
uniform texture2d image_1;
uniform float2 uv_pixel_interval;
uniform float transition_percentage;

#define ratio getRatio()
#define progress transition_percentage
#define mix(a, b, p) lerp(a, b, p)
#define fract(x) frac(x)
#define atan(y, x) atan2(y, x)

sampler_state textureSampler {
    Filter   = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

float getRatio() {
    return uv_pixel_interval.y / uv_pixel_interval.x;
}

float4 getFromColor(float2 uv) {
    uv.y = 1.0 - uv.y;
    return float4(image_0.Sample(textureSampler, uv).rgb, 1.0);
}

float4 getToColor(float2 uv) {
    uv.y = 1.0 - uv.y;
    return float4(image_1.Sample(textureSampler, uv).rgb, 1.0);
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
