void main() {
	vec2 I = gl_FragCoord.xy;

	//Raymarch depth
	float z,
	//Step distance
	d,
	//Raymarch iterator
	i,
	//Time for animation
	t = u_time;
	
	//Clear fragColor and raymarch 100 steps
	for(fragColor*=i; i++<2e1; )
	{
		//Sample point (from ray direction)
		vec3 p = z*normalize(vec3(I+I,0)-u_resolution.xyx)+.1;
		
		//Polar coordinates and additional transformations
		p = vec3(atan(p.z+=9.,p.x+.1)*2., .6*p.y+t+t, length(p.xz)-3.);
		
		//Apply turbulence and refraction effect
		for(d=0.; d++<7.;)
			p += sin(p.yzx*d+t+.5*i)/d;
			
		//Distance to cylinder and waves with refraction
		z += d = .4*length(vec4(.3*cos(p)-.3, p.z));
		
		//Coloring and brightness
		fragColor += (1.+cos(p.y+i*.4+vec4(6,1,2,0)))/d;
	}
	//Tanh tonemap
	fragColor = tanh(fragColor*fragColor/6e3);
}