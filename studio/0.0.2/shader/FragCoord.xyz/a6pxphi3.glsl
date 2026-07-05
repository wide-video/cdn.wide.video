void main() {
	vec2 I = gl_FragCoord.xy;

	//Raymarch depth
	float z,
	//Step distance
	d,
	//Raymarch iterator
	i;
	//Clear fragColor and raymarch 20 steps
	for(fragColor*=i; i++<2e1; )
	{
		//Sample point (from ray direction)
		vec3 p = z*normalize(vec3(I+I,0)-u_resolution.xyx)+.1;
		
		//Polar coordinates and additional transformations
		p = vec3(atan(p.y/.2,p.x)*2., p.z/3., length(p.xy)-5.-z*.2);
		
		//Apply turbulence and refraction effect
		for(d=0.; d++<7.;)
			p += sin(p.yzx*d+u_time+.3*i)/d;
			
		//Distance to cylinder and waves with refraction
		z += d = length(vec4(.4*cos(p)-.4, p.z));
		
		//Coloring and brightness
		fragColor += (1.+cos(p.x+i*.4+z+vec4(6,1,2,0)))/d;
	}
	//Tanh tonemap
	fragColor = tanh(fragColor*fragColor/4e2);
}