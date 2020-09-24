// Author: Aaron Griffith
// License: MIT

uniform bool down; // = false

uniform vec4 background; // = vec4(0.0, 0.0, 0.0, 1.0)
uniform bool twopart; // = true;

vec4 part(vec2 uv, vec4 a, vec4 b, float p) {
  float margin = 0.5 * ratio;
  float arrow = abs(uv.x - 0.5);
  if (!down && uv.y - mix(0.0, 1.0 + margin, p) + arrow * ratio < 0.0) {
    return b;
  }
  if (down && uv.y - mix(1.0, 0.0 - margin, p) - arrow * ratio > 0.0) {
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
