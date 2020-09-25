// Author: Aaron Griffith
// License: MIT

const int count = 70;
const float pi = 3.1415926;
uniform float seed; // = 0.0;

uniform vec4 background; // = vec4(0.0, 0.0, 0.0, 1.0)
uniform bool twopart; // = true;

// https://stackoverflow.com/a/4275343
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 position(int i, float s) {
  float x = rand(vec2(s, float(i)));
  float y = rand(vec2(s, float(i) + 0.5));
  return vec2(x * 1.2 - 0.1, y * 1.2 - 0.1);
}

float ease(float p, float maxradius) {
  p = p * p;
  if (p < 0.9) {
    return mix(0.0, maxradius, p);
  } else {
    return mix(maxradius * 0.9, maxradius * 2.0, (p - 0.9) * 10.0);
  }
}

// https://www.shadertoy.com/view/wstXDs
bool inStar(vec2 d, float r, float angle) {
  float inner = 0.5 * r;
  float star = 2.0 * pi / 5.0;
  vec2 p0 = r * vec2(cos(angle), sin(angle));
  vec2 p1 = inner * vec2(cos(angle + star), sin(angle + star));
  float a = fract((atan(d.x, d.y) - angle) / star);
  if (a > 0.5) {
    a = 1.0 - a;
  }
  a *= star;
  vec2 norm = length(d) * vec2(cos(angle + a), sin(angle + a));
  vec2 dir0 = p1 - p0;
  vec2 dir1 = norm - p0;
  vec3 c = cross(vec3(dir0.x, dir0.y, 0.0), vec3(dir1.x, dir1.y, 0.0));
  return c.z > 0.0;
}

vec4 part(vec2 uv, vec4 a, vec4 b, float p, bool flip) {
  float s = seed;
  if (flip) {
    s += 0.5;
  }
  float maxradius = 1.5;
  uv.y /= ratio;
  for (int i = 0; i < count; i++) {
    vec2 c = position(i, s);
    vec2 d = uv - c;
    float rscale = 0.5 - abs(c.y * ratio - 0.5);
    rscale = 1.0 - clamp(4.0 * (0.25 - rscale * rscale), 0.0, 0.9);
    rscale *= clamp(rand(vec2(s, float(i) + 0.25)), 0.2, 1.0);
    float angle = 2.0 * pi * rand(vec2(s, float(i) + 0.75));
    float r = ease(p, maxradius) * rscale;
    if (inStar(d, r, angle)) {
      return b;
    }
  }
  return a;
}

vec4 two(vec2 uv, vec4 a, vec4 b, float p) {
  if (p < 0.5) {
    return part(uv, a, background, p * 2.0, false);
  } else {
    return part(uv, background, b, 2.0 * (p - 0.5), true);
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
