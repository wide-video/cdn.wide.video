void main() {
	vec2 I = gl_FragCoord.xy;

	//Time for animation
	float t = u_time,
	//Raymarch loop iterator
	i,
	//Raymarched depth
	z,
	//Raymarch step size and "Turbulence" frequency
	//https://www.shadertoy.com/view/WclSWn
	d;

	//Raymarching loop with 50 iterations
	for (fragColor *= i; i++ < 50.0;
	//Add color and glow attenuation
	fragColor += (sin(z / 3.0 + vec4(7, 2, 3, 0)) + 1.1) / d )
	{
		//Compute raymarch sample point
		vec3 p = z * normalize(vec3(I + I, 0) - u_resolution.xyy);
		//Shift back and animate
		p.z += 5.0 + cos(t);
		//Twist and rotate
		p.xz *= mat2(cos(p.y * 0.5 + vec4(0, 33, 11, 0)))
		//Expand upward
		/ max(p.y * 0.1 + 1.0, 0.1);
		//Turbulence loop (increase frequency)
		for (d = 2.0; d < 15.0; d /= 0.6)
		{
			//Add a turbulence wave
			p += cos((p.yzx - vec3(t / 0.1, t, d) ) * d ) / d;
		}
		//Sample approximate distance to hollow cone
		z += d = 0.01 + abs(length(p.xz) + p.y * 0.3 - 0.5) / 7.0;
	}
	//Tanh tonemapping
	//https://www.shadertoy.com/view/ms3BD7
	fragColor = tanh(fragColor / 1e3);
}