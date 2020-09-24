// Author: Aaron Griffith
// License: MIT

uniform int strips; // = 10;
uniform float seed; // = 0.0;

uniform vec4 background; // = vec4(0.0, 0.0, 0.0, 1.0)
uniform bool twopart; // = true;

// https://stackoverflow.com/a/4275343
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float ease(float p) {
  p = 1.0 - p;
  return 1.0 - p * p;
}

vec4 part(vec2 uv, vec4 a, vec4 b, float p, bool flip) {
  float strip = floor(uv.x * float(strips));
  float pos = 0.6 * rand(vec2(seed + float(flip), strip)) + 0.2;
  float progressstrip = strip / (float(strips) - 1.0);
  if (flip) {
    progressstrip = 1.0 - progressstrip;
    p = 1.0 - p;
    vec4 tmp = a;
    a = b;
    b = tmp;
  }
  float localp = ease(clamp(1.5 * p - 0.5 * progressstrip, 0.0, 1.0));
  float lower = pos * (1.0 - localp);
  float upper = pos + (1.0 - pos) * localp;
  if (uv.y > lower && uv.y < upper) {
    return b;
  }
  return a;
}

vec4 two(vec2 uv, vec4 a, vec4 b, float p) {
  if (p < 0.5) {
    return part(uv, a, background, p * 2.0, true);
  } else {
    return part(uv, background, b, 2.0 * (p - 0.5), false);
  }
}

vec4 transition(vec2 uv) {
  vec4 a = getFromColor(uv);
  vec4 b = getToColor(uv);
  if (twopart) {
    return two(uv, a, b, progress);
  } else {
    return part(uv, a, b, progress, false);
  }
}
