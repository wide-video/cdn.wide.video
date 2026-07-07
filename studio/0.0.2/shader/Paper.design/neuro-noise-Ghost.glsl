// https://shaders.paper.design/neuro-noise (Ghost)

// u_colorFront (vec4): Graphics highlight color in RGBA
#define u_colorFront (vec4(1.000, 1.000, 1.000, 1.000))

// u_colorMid (vec4): Graphics main color in RGBA
#define u_colorMid (vec4(0.000, 0.000, 0.000, 1.000))

// u_colorBack (vec4): Background color in RGBA
#define u_colorBack (vec4(1.000, 1.000, 1.000, 1.000))

// u_brightness (float): Luminosity of the crossing points (0 to 1)
#define u_brightness 0.

// u_contrast (float): Sharpness of the bright-dark transition (0 to 1)
#define u_contrast 1.

// u_fit (float): How to fit the rendered shader into the canvas dimensions (0 = none, 1 = contain, 2 = cover)
#define u_fit 0.

// u_scale (float): Overall zoom level of the graphics (0.01 to 4)
#define u_scale 0.55

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

vec2 rotate(vec2 uv, float th) {
  return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;
}


float neuroShape(vec2 uv, float t) {
  vec2 sine_acc = vec2(0.);
  vec2 res = vec2(0.);
  float scale = 8.;

  for (int j = 0; j < 15; j++) {
    uv = rotate(uv, 1.);
    sine_acc = rotate(sine_acc, 1.);
    vec2 layer = uv * scale + float(j) + sine_acc - t;
    sine_acc += sin(layer);
    res += (.5 + .5 * cos(layer)) / scale;
    scale *= (1.2);
  }
  return res.x + res.y;
}

void main() {
  vec2 shape_uv = v_patternUV;
  shape_uv *= .13;

  float t = .5 * u_time;

  float noise = neuroShape(shape_uv, t);

  noise = (1. + u_brightness) * noise * noise;
  noise = pow(noise, .7 + 6. * u_contrast);
  noise = min(1.4, noise);

  float blend = smoothstep(0.7, 1.4, noise);

  vec4 frontC = u_colorFront;
  frontC.rgb *= frontC.a;
  vec4 midC = u_colorMid;
  midC.rgb *= midC.a;
  vec4 blendFront = mix(midC, frontC, blend);

  float safeNoise = max(noise, 0.0);
  vec3 color = blendFront.rgb * safeNoise;
  float opacity = clamp(blendFront.a * safeNoise, 0., 1.);

  vec3 bgColor = u_colorBack.rgb * u_colorBack.a;
  color = color + bgColor * (1. - opacity);
  opacity = opacity + u_colorBack.a * (1. - opacity);

  
  color += 1. / 256. * (fract(sin(dot(.014 * gl_FragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453123) - .5);


  fragColor = vec4(color, opacity);
}