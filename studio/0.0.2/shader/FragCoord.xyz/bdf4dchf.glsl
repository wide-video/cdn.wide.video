void main()
{
	fragColor = vec4(0.0);
	vec2 p = (gl_FragCoord.xy * 2.0 - u_resolution) / u_resolution.y / 0.7, d = vec2(-1, 1), c = p * mat2(1, 1, d / (0.1 + 5.0 / dot(5.0 * p - d, 5.0 * p - d))), v = c;
	v *= mat2(cos(log(length(v)) + u_time * 0.2 + vec4(0, 33, 11, 0))) * 5.0;
	for (float i;i++ < 9.0;fragColor += sin(v.xyyx) + 1.0)
	{
		v += 0.7 * sin(v.yx * i + u_time) / i + 0.5;
	}
	fragColor = 1.0 - exp(-exp(c.x * vec4(0.6, -0.4, -1, 0)) / fragColor / (0.1 + 0.1 * pow(length(sin(v / 0.3) * 0.2 + c * vec2(1, 2)) - 1.0, 2.0)) / (1.0 + 7.0 * exp(0.3 * c.y - dot(c, c))) / (0.03 + abs(length(p) - 0.7)) * 0.2);
}