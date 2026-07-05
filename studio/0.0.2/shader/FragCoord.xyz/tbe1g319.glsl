// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Copyright (c) 2026 @Frostbyte
//[LICENSE] https://creativecommons.org/licenses/by-nc-sa/4.0/

#define T u_time*.5

//Path
#define P(z) (vec3(cos((z) * .1) * 5., cos((z) * .05) * 3.+.0, (z)))

// 2d rotation matrix golfed
#define R(a) mat2(cos(a+vec4(0,33,11,0)))

//Xor's Dot Noise golfed by Fabrice: https://fragcoord.xyz/s/pf29h2wz
mat3 G = mat3(-.57,.81,.1, -.28,-.3,.9, .77, .49, .4);
#define n(p) dot( cos(G*(p)), sin(1.6*(p)*G) )

// Inigo Quilez (MIT) https://www.shadertoy.com/view/ll2GD3
vec3 cosPalette(float t) {
	vec3 brightness = vec3(0.455, 0.322, 0.216);
	vec3 contrast = vec3(-0.073, 0.119, 0.150);
	vec3 frequency = vec3(1.000, 1.000, 1.000);
	vec3 phase = vec3(0.100, -0.256, -0.231);

	vec3 color = brightness + contrast * cos(6.28318 * (frequency * t + phase));
	return clamp(color, 0.0, 1.0); // sRGB
}

void main() {
	float i,y,d,s;
	
	vec3  g,
		p = P(T*1e1),
		Z = normalize( P(T*1e1+1.) - p), 
		X = normalize(vec3(Z.z,0,-Z)),
		rd = vec3((gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y, 2) * mat3(-X, cross(X, Z), Z);

	vec4 o;

	for (;i++ < 150.;) {
		s = 0.0005 + abs(s) * 0.1;
		d += s;
		o += cosPalette(p.z*.1+i).rgbr / s ;
		p = rd*d+P(T*1e1);
		g = p;
		p.xy *= R(cos(P(T).y * 0.5));
		s =(sin(p.z + (p.y)) * 0.2);
		y = abs(n(p));
		s += y+y*.2;
		s = max(1.5+sin(p.z*.2+p.y*.4)-length((g-P(p.z)).xy), s);
	}
	fragColor = tanh(o * o /4e8);
}