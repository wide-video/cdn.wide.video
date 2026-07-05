// SPDX-License-Identifier: MIT
// Copyright (c) 2026 @diatribes
//[LICENSE] https://opensource.org/licenses/MIT

#define T (sin(u_time*.6)*64.+u_time*2e2)
#define P(z) (vec3(cos((z)*.006)*128.+cos((z) * .01)  *24., \
				cos((z)*.005)*64., (z)))
#define R(a) mat2(cos(a+vec4(0,33,11,0)))
#define N normalize

vec2 shake() {
	return vec2(
		sin(T * 250.),
		cos(T * 270.)
	) * .03;
}

void main() {
vec2 u = gl_FragCoord.xy;

	float i,a,d,s,t=u_time;
	
	vec3  r = vec3(u_resolution, 1.0);
	u = (u+u-r.xy)/r.y;
	if(sin(t/2.) > 0.) u += shake();
	vec3  p = P(T),ro=p,
		Z = N( P(T+4.) - p),
		X = N(vec3(Z.z,0,-Z)),
		D = N(vec3(R(sin(T*.005)*.4)*u, 1) 
			* mat3(-X, cross(X, Z), Z));   
	
	for(fragColor*=i; i++<1e2; ) {
		p = ro + D * d,
		p.xy -= P(p.z).xy,
		D.z += i*.000025,  // https://www.shadertoy.com/view/NcjGDh
		D = N(D),
		p.xy *= mat2(cos(.3*t+p.z/2e2+vec4(0,33,11,0))),
		
		s = mix(128. - abs(p.y),
				abs(2e1*dot(sin(p/7e1), sin(p.yzx/5e1)))
				-abs(4e1*dot(sin(p/1e2), sin(p.yzx/2e1)))
				-abs(3e1*dot(sin(p/8e1), sin(p.zxy/4e1))), .6);
		
		for (a = .01; a < 4.; a += a+a)
			s -= abs(dot(sin(.2*p / a), vec3(a*3.)));
		
		d += s *= .5;
		
		s = max(s, .005);
		
		fragColor += s * i * (1.+cos(i*.5+vec4(2,1,0,0))) * 2.
		+  s * i * vec4(4.+sin(t),2,1,0) * 3.
		+ vec4(5,5,4,0)/s;
	}
	fragColor = tanh(fragColor*fragColor / 9e9 );
}