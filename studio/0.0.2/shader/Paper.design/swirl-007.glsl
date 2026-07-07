// https://shaders.paper.design/swirl (007)

// u_colorBack (vec4): Background color in RGBA
#define u_colorBack (vec4(0.914, 0.906, 0.855, 1.000))

// u_colors (vec4[]): Up to 10 stripe colors in RGBA
#define u_colors (vec4[10](\
	vec4(0.000, 0.000, 0.000, 1.000),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0),\
	vec4(0)))

// u_colorsCount (float): Number of active colors
#define u_colorsCount 1.

// u_bandCount (float): Number of color bands, 0 = concentric ripples (0 to 15)
#define u_bandCount 5.

// u_twist (float): Vortex power, 0 = straight sectoral shapes (0 to 1)
#define u_twist 0.3

// u_center (float): How far from the center the swirl colors begin to appear (0 to 1)
#define u_center 0.

// u_proportion (float): Blend point between colors, 0.5 = equal distribution (0 to 1)
#define u_proportion 0.

// u_softness (float): Color transition sharpness, 0 = hard edge, 1 = smooth gradient (0 to 1)
#define u_softness 0.

// u_noiseFrequency (float): Noise frequency, no effect with noise = 0 (0 to 1)
#define u_noiseFrequency 0.5

// u_noise (float): Strength of noise distortion, no effect with noiseFrequency = 0 (0 to 1)
#define u_noise 0.

// u_fit (float): How to fit the rendered shader into the canvas dimensions (0 = none, 1 = contain, 2 = cover)
#define u_fit 1.

// u_scale (float): Overall zoom level of the graphics (0.01 to 4)
#define u_scale 1.

// u_rotation (float): Overall rotation angle of the graphics in degrees (0 to 360)
#define u_rotation 0.

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

#define u_speed 1.

#define u_frame 0.

#define TWO_PI 6.28318530718
#define PI 3.14159265358979323846


vec3 permute(vec3 x) { return mod(((x * 34.0) + 1.0) * x, 289.0); }
float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
    -0.577350269189626, 0.024390243902439);
  vec2 i = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
    + i.x + vec3(0.0, i1.x, 1.0));
  vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy),
      dot(x12.zw, x12.zw)), 0.0);
  m = m * m;
  m = m * m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}


vec2 rotate(vec2 uv, float th) {
  return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;
}


void main() {
  vec2 shape_uv = v_objectUV;

  float l = length(shape_uv);
  l = max(1e-4, l);

  float t = u_time;

  float angle = ceil(u_bandCount) * atan(shape_uv.y, shape_uv.x) + t;
  float angle_norm = angle / TWO_PI;

  float twist = 3. * clamp(u_twist, 0., 1.);
  float offset = pow(l, -twist) + angle_norm;

  float shape = fract(offset);
  shape = 1. - abs(2. * shape - 1.);
  shape += u_noise * snoise(15. * pow(u_noiseFrequency, 2.) * shape_uv);

  float mid = smoothstep(.2, .2 + .8 * u_center, pow(l, twist));
  shape = mix(0., shape, mid);

  float proportion = clamp(u_proportion, 0., 1.);
  float exponent = mix(.25, 1., proportion * 2.);
  exponent = mix(exponent, 10., max(0., proportion * 2. - 1.));
  shape = pow(shape, exponent);

  float mixer = shape * u_colorsCount;
  vec4 gradient = u_colors[0];
  gradient.rgb *= gradient.a;

  float outerShape = 0.;
  for (int i = 1; i < 11; i++) {
    if (i > int(u_colorsCount)) break;

    float m = clamp(mixer - float(i - 1), 0., 1.);
    float aa = fwidth(m);
    m = smoothstep(.5 - .5 * u_softness - aa, .5 + .5 * u_softness + aa, m);

    if (i == 1) {
      outerShape = m;
    }

    vec4 c = u_colors[i - 1];
    c.rgb *= c.a;
    gradient = mix(gradient, c, m);
  }

  float midAA = .1 * fwidth(pow(l, -twist));
  float outerMid = smoothstep(.2, .2 + midAA, pow(l, twist));
  outerShape = mix(0., outerShape, outerMid);

  vec3 color = gradient.rgb * outerShape;
  float opacity = gradient.a * outerShape;

  vec3 bgColor = u_colorBack.rgb * u_colorBack.a;
  color = color + bgColor * (1.0 - opacity);
  opacity = opacity + u_colorBack.a * (1.0 - opacity);

  
  color += 1. / 256. * (fract(sin(dot(.014 * gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453123) - .5);


  fragColor = vec4(color, opacity);
}