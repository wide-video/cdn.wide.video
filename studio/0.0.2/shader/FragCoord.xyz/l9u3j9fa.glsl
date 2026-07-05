void main()
{
	vec4 O;
	vec2 I=gl_FragCoord.xy;
	float i, t, v, s, j;
	// Raymarching loop
	for (O*=i; i++<60.;t+=v/4.){
	vec3 p=t*normalize(vec3(I+I,0) - u_resolution.xyy);
	// Move camera back and rotate around origin
	p.z+=5.;
	p=reflect(p, normalize(sin(u_time*.1+vec3(0,2,4))));
	// Fractal from repeated scaling, folding and translations
		p=(p.x<p.z?p.zyx:p);
		s=1.;
		for(j=0.;j++<20.;){
			p*=1.4;
			s*=1.4;
			p=(p.y>p.z?p.xzy:p);
			p.y+=3.;
			p.xz=vec2(p.z,-p.x-sin(p.y+u_time+i*.01)); // Sine wave is doing all the magic here
		}
	// Density from straight line
	v=length(p.xz)/s;
	// Color accumulation based on density and iteration count
	O+=exp(cos(i*.08-vec4(0,1,2,0)))/v;
	}
	// Tone mapping
	O = tanh(O/8e2);
	fragColor=O*O;
}