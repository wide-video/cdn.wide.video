// https://shaders.paper.design/static-mesh-gradient (Sea)

// u_colors (vec4[]): Up to 10 gradient colors in RGBA
#define u_colors (vec4[10](\
	vec4(0.004, 0.231, 0.396, 1.000),\
	vec4(0.012, 0.451, 0.549, 1.000),\
	vec4(0.639, 0.827, 1.000, 1.000),\
	vec4(0.949, 0.980, 0.937, 1.000),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0)))

// u_colorsCount (float): Number of active colors
#define u_colorsCount 4.

// u_positions (float): Color spots placement seed (0 to 100)
#define u_positions 0.

// u_waveX (float): Strength of sine wave distortion along X axis (0 to 1)
#define u_waveX 0.53

// u_waveXShift (float): Phase offset applied to the X-axis wave (0 to 1)
#define u_waveXShift 0.

// u_waveY (float): Strength of sine wave distortion along Y axis (0 to 1)
#define u_waveY 0.95

// u_waveYShift (float): Phase offset applied to the Y-axis wave (0 to 1)
#define u_waveYShift 0.64

// u_mixing (float): Blending behavior, 0 = hard stripes, 0.5 = smooth, 1 = gradual blend (0 to 1)
#define u_mixing 0.5

// u_grainMixer (float): Strength of grain distortion applied to shape edges (0 to 1)
#define u_grainMixer 0.

// u_grainOverlay (float): Post-processing black/white grain overlay (0 to 1)
#define u_grainOverlay 0.

// u_fit (float): How to fit the rendered shader into the canvas dimensions (0 = none, 1 = contain, 2 = cover)
#define u_fit 1.

// u_rotation (float): Overall rotation angle of the graphics in degrees (0 to 360)
#define u_rotation 0.

// u_scale (float): Overall zoom level of the graphics (0.01 to 4)
#define u_scale 1.

// u_offsetX (float): Horizontal offset of the graphics center (-1 to 1)
#define u_offsetX 0.

// u_offsetY (float): Vertical offset of the graphics center (-1 to 1)
#define u_offsetY 0.

// u_originX (float): Reference point for positioning world width in the canvas (0 to 1)
#define u_originX 0.5

// u_originY (float): Reference point for positioning world height in the canvas (0 to 1)
#define u_originY 0.5

// u_worldWidth (float): Virtual width of the graphic before it's scaled to fit the canvas
#define u_worldWidth 0.

// u_worldHeight (float): Virtual height of the graphic before it's scaled to fit the canvas
#define u_worldHeight 0.

#define u_speed 0.

#define u_frame 0.

#define TWO_PI 6.28318530718
#define PI 3.14159265358979323846


vec2 rotate(vec2 uv, float th) {
  return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;
}


  float hash21(vec2 p) {
    p = fract(p * vec2(0.3183099, 0.3678794)) + 0.1;
    p += dot(p, p + 19.19);
    return fract(p.x * p.y);
  }


float valueNoise(vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);
  float a = hash21(i);
  float b = hash21(i + vec2(1.0, 0.0));
  float c = hash21(i + vec2(0.0, 1.0));
  float d = hash21(i + vec2(1.0, 1.0));
  vec2 u = f * f * (3.0 - 2.0 * f);
  float x1 = mix(a, b, u.x);
  float x2 = mix(c, d, u.x);
  return mix(x1, x2, u.y);
}

float noise(vec2 n, vec2 seedOffset) {
  return valueNoise(n + seedOffset);
}

vec2 getPosition(int i, float t) {
  float a = float(i) * .37;
  float b = .6 + mod(float(i), 3.) * .3;
  float c = .8 + mod(float(i + 1), 4.) * 0.25;

  float x = sin(t * b + a);
  float y = cos(t * c + a * 1.5);

  return .5 + .5 * vec2(x, y);
}

void main() {
  vec2 uv = v_objectUV;
  uv += .5;
  vec2 grainUV = uv * 1000.;

  float grain = noise(grainUV, vec2(0.));
  float mixerGrain = .4 * u_grainMixer * (grain - .5);

  float radius = smoothstep(0., 1., length(uv - .5));
  float center = 1. - radius;
  for (float i = 1.; i <= 2.; i++) {
    uv.x += u_waveX * center / i * cos(TWO_PI * u_waveXShift + i * 2. * smoothstep(.0, 1., uv.y));
    uv.y += u_waveY * center / i * cos(TWO_PI * u_waveYShift + i * 2. * smoothstep(.0, 1., uv.x));
  }

  vec3 color = vec3(0.);
  float opacity = 0.;
  float totalWeight = 0.;
  float positionSeed = 25. + .33 * u_positions;

  for (int i = 0; i < 10; i++) {
    if (i >= int(u_colorsCount)) break;

    vec2 pos = getPosition(i, positionSeed) + mixerGrain;
    float dist = length(uv - pos);
    dist = length(uv - pos);

    vec3 colorFraction = u_colors[i].rgb * u_colors[i].a;
    float opacityFraction = u_colors[i].a;

    float mixing = pow(u_mixing, .7);
    float power = mix(2., 1., mixing);
    dist = pow(dist, power);

    float w = 1. / (dist + 1e-3);
    float baseSharpness = mix(.0, 8., clamp(w, 0., 1.));
    float sharpness = mix(baseSharpness, 1., mixing);
    w = pow(w, sharpness);
    color += colorFraction * w;
    opacity += opacityFraction * w;
    totalWeight += w;
  }

  color /= max(1e-4, totalWeight);
  opacity /= max(1e-4, totalWeight);

  float grainOverlay = valueNoise(rotate(grainUV, 1.) + vec2(3.));
  grainOverlay = mix(grainOverlay, valueNoise(rotate(grainUV, 2.) + vec2(-1.)), .5);
  grainOverlay = pow(grainOverlay, 1.3);

  float grainOverlayV = grainOverlay * 2. - 1.;
  vec3 grainOverlayColor = vec3(step(0., grainOverlayV));
  float grainOverlayStrength = u_grainOverlay * abs(grainOverlayV);
  grainOverlayStrength = pow(grainOverlayStrength, .8);
  color = mix(color, grainOverlayColor, .35 * grainOverlayStrength);

  opacity += .5 * grainOverlayStrength;
  opacity = clamp(opacity, 0., 1.);

  fragColor = vec4(color, opacity);
}