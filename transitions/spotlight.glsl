// Author: Aaron Griffith
// License: MIT

uniform float hold; // = 0.4
uniform float radius; // = 0.5
uniform vec2 center; // = vec2(0.5, 0.5)

uniform vec4 background; // = vec4(0.0, 0.0, 0.0, 1.0)
uniform bool twopart; // = true;

float ease(float p) {
  p = 1.0 - p;
  return 1.0 - p * p;
}

vec4 part(vec2 uv, vec4 a, vec4 b, float p) {
  float radius = radius;
  float stop1 = radius * (1.0 - hold);
  float stop2 = stop1 + hold;
  if (p < stop1) {
    radius = mix(0.0, radius, ease(p / stop1));
  } else if (p > stop2) {
    radius = mix(radius, 1.0, (p - stop2) / (1.0 - stop2));
  }
  vec2 normcenter = center;
  normcenter.y /= ratio;
  uv.y /= ratio;
  vec2 dist = normcenter - uv;
  if (dot(dist, dist) < radius * radius) {
    return b;
  }
  return a;
}

vec4 two(vec2 uv, vec4 a, vec4 b, float p) {
  if (p < 0.5) {
    return part(uv, background, a, 1.0 - p * 2.0);
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
