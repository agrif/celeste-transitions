// Author: Aaron Griffith
// License: MIT

const int count = 400;
uniform float seed; // = 0.0;

uniform vec4 background; // = vec4(0.0, 0.0, 0.0, 1.0)
uniform bool twopart; // = true;

// https://stackoverflow.com/a/4275343
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 position(int i) {
  float x = rand(vec2(seed, float(i)));
  float y = rand(vec2(seed, float(i) + 0.5));
  return vec2(x * 1.2 - 0.1, y * 1.2 - 0.1);
}

float ease(float p, float maxradius) {
  if (p < 0.9) {
    return mix(0.0, maxradius, p);
  } else {
    return mix(maxradius * 0.9, maxradius * 2.0, (p - 0.9) * 10.0);
  }
}

vec4 part(vec2 uv, vec4 a, vec4 b, float p) {
  float maxradius = 2.0 / sqrt(float(count));
  uv.y /= ratio;
  for (int i = 0; i < count; i++) {
    vec2 c = position(i);
    vec2 d = uv - c;
    float localp = clamp(2.0 * p - c.x, 0.0, 1.0);
    float r = ease(localp, maxradius);
    if (dot(d, d) < r * r) {
      return b;
    }
  }
  return a;
}

vec4 two(vec2 uv, vec4 a, vec4 b, float p) {
  if (p < 0.5) {
    return part(uv, a, background, p * 2.0);
  } else {
    return part(uv, background, b, 2.0 * (p - 0.5));
  }
}

vec4 transition(vec2 uv) {
  vec4 a = getFromColor(uv);
  vec4 b = getToColor(uv);
  if (twopart) {
    return two(uv, a, b, progress);
  } else {
    return part(uv, a, b, progress);
  }
}
