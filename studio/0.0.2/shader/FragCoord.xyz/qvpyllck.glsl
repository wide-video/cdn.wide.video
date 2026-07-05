void main()
{
	fragColor = vec4(0.0);
	for(float i, z, d, s; i++ < 7e1; fragColor += vec4(z, 2, s, 1) / s/d)
	{
		vec3 p = z * normalize(gl_FragCoord.rgb * 2.0 - vec3(u_resolution, 1.0).xyy),
		a;
		p.z += 9.0;
		a = mix(dot(a -= 0.57, p) * a, p, cos(s -= u_time)) - sin(s) * cross(a, p);
		s = sqrt(length(a.xz - a.y));
		for(d = 1.0; d++ < 9.0; a += sin(a * d - u_time).yzx / d);
		z += d = length(sin(a) + dot(a, a / a) * 0.2) * s / 2e1;
	}
	fragColor = tanh(fragColor / 2e3);
}