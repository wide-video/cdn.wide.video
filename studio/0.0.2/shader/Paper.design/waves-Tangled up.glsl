// https://shaders.paper.design/waves (Tangled up)

// u_colorFront (vec4): Foreground color in RGBA
#define u_colorFront (vec4(0.075, 0.227, 0.255, 1.000))

// u_colorBack (vec4): Background color in RGBA
#define u_colorBack (vec4(0.761, 0.847, 0.714, 1.000))

// u_shape (float): Line shape, 0 = zigzag, 1 = sine, 2-3 = irregular waves, fractional values morph between shapes (0 to 3)
#define u_shape 2.07

// u_frequency (float): Wave frequency (0 to 2)
#define u_frequency 0.44

// u_amplitude (float): Wave amplitude (0 to 1)
#define u_amplitude 0.57

// u_spacing (float): Space between every two wavy lines (0 to 2)
#define u_spacing 1.05

// u_proportion (float): Blend point between front and back colors, 0.5 = equal distribution (0 to 1)
#define u_proportion 0.75

// u_softness (float): Color transition sharpness, 0 = hard edge, 1 = smooth gradient (0 to 1)
#define u_softness 0.

// u_fit (float): How to fit the rendered shader into the canvas dimensions (0 = none, 1 = contain, 2 = cover)
#define u_fit 0.

// u_scale (float): Overall zoom level of the graphics (0.01 to 4)
#define u_scale 0.5

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

#define TWO_PI 6.28318530718
#define PI 3.14159265358979323846


void main() {
  vec2 shape_uv = v_patternUV;
  shape_uv *= 4.;

  float wave = .5 * cos(shape_uv.x * u_frequency * TWO_PI);
  float zigzag = 2. * abs(fract(shape_uv.x * u_frequency) - .5);
  float irregular = sin(shape_uv.x * .25 * u_frequency * TWO_PI) * cos(shape_uv.x * u_frequency * TWO_PI);
  float irregular2 = .75 * (sin(shape_uv.x * u_frequency * TWO_PI) + .5 * cos(shape_uv.x * .5 * u_frequency * TWO_PI));

  float offset = mix(zigzag, wave, smoothstep(0., 1., u_shape));
  offset = mix(offset, irregular, smoothstep(1., 2., u_shape));
  offset = mix(offset, irregular2, smoothstep(2., 3., u_shape));
  offset *= 2. * u_amplitude;

  float spacing = (.001 + u_spacing);
  float shape = .5 + .5 * sin((shape_uv.y + offset) * PI / spacing);

  float aa = .0001 + fwidth(shape);
  float dc = 1. - clamp(u_proportion, 0., 1.);
  float e0 = dc - u_softness - aa;
  float e1 = dc + u_softness + aa;
  float res = smoothstep(min(e0, e1), max(e0, e1), shape);

  vec3 fgColor = u_colorFront.rgb * u_colorFront.a;
  float fgOpacity = u_colorFront.a;
  vec3 bgColor = u_colorBack.rgb * u_colorBack.a;
  float bgOpacity = u_colorBack.a;

  vec3 color = fgColor * res;
  float opacity = fgOpacity * res;

  color += bgColor * (1. - opacity);
  opacity += bgOpacity * (1. - opacity);

  fragColor = vec4(color, opacity);
}