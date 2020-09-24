// Author: Aaron Griffith
// License: MIT

uniform int strips; // = 27
uniform float width; // = 0.5

uniform vec4 background; // = vec4(0.0, 0.0, 0.0, 1.0)
uniform bool twopart; // = true;

vec4 part(vec2 uv, vec4 a, vec4 b, float p) {
  float part = 2.0 * fract(uv.y * float(strips));
  if (part > 1.0) {
    part = 2.0 - part;
  }
  if (uv.x - mix(-width, 1.0, p) - part * width < 0.0) {
    return b;
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
