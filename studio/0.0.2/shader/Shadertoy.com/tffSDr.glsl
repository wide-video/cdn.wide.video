#define PI 3.14159265

vec3 palette(in float t) {
	vec3 a = vec3(0.5, 0.5, 0.5);
	vec3 b = vec3(0.5, 0.5, 0.5);
	vec3 c = vec3(1.0, 1.0, 1.0);
	vec3 d = vec3(0.1, 0.4, 0.5);
	return a + b * cos(2.0 * PI * (c * t + d));
}

vec4 wave(vec2 uv, vec4 color, float amp, float freq, float phase, float thick, vec3 hue) {
	float x = uv.x - phase;
	float y = uv.y + amp * sin(freq * x);
	float bright = smoothstep(0.0, 1.0, 1.0 - abs(y) / thick);
	return vec4(vec3(bright) * hue, 1.0);
}

void mainImage(out vec4 color, in vec2 coord) {
	vec2 uv = (2.0 * coord - iResolution.xy) / iResolution.y;

	color = vec4(0.0, 0.0, 0.0, 1.0);

	for (float layer = 0.0; layer < 1.0; layer += 0.1) {
		float amp = 0.25 + 0.25 * sin(iTime + layer) * (1.0 - layer);
		float freq = 2.0;
		float phase = iTime * (1.0 - layer);
		float thick = 0.01 + 0.001 * pow(abs(uv.x), 8.0);
		vec3 hue = palette(0.5 * uv.x + 1.0 * layer - 0.5 * iTime);
		color += wave(uv, color, amp, freq, phase, thick, hue);
	}
}