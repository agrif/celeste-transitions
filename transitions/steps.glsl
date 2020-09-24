// Author: Aaron Griffith
// License: MIT

uniform int strips; // = 6
uniform float slope; // = -3.0
uniform float stepfactor; // = 1.0

uniform vec4 background; // = vec4(0.0, 0.0, 0.0, 1.0)
uniform bool twopart; // = true;

vec4 part(vec2 uv, vec4 a, vec4 b, float p) {
  float margin = 1.0 / (ratio * slope) + float(strips - 1) * stepfactor / (ratio * float(strips));
  if (slope * stepfactor < 0.0) {
    float f = 1.0 / (slope * float(strips) * ratio);
    margin -= 2.0 * f;
    uv.x += f;
  }
  if (slope < 0.0) {
    vec4 tmp = a;
    a = b;
    b = tmp;
  }
  float start = min(0.0, -margin);
  float end = max(1.0, 1.0 - margin);
  float offset = stepfactor * floor(uv.y * float(strips)) / (ratio * float(strips));
  if ((uv.x - mix(start, end, p) - offset) * slope < uv.y / ratio) {
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
