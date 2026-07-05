uniform sampler2D u_st_tex0;
void main() {
vec2 I = gl_FragCoord.xy;
	//Resolution for scaling
	vec2 r = u_resolution.xy,
	//Iteration constant (starting at 0)
	//11 is approximately 3.5 * pi, perfect for computing sine and cosine together.
	i = vec2(0,11);
	
	//Clear the output color
	//Loop 200 times
	for(fragColor-=fragColor; i.x<2e2; )
		
		//Bokeh sample (fifth-power)
		fragColor += pow(texture(u_st_tex0,(I+(I+I-r-r*sin(u_time)).y*sin(i)/6e2*sqrt(i++).x)/r), 5.+fragColor-fragColor);
	
	//Compute average with fifth-root.
	//This a gamma transform that makes brighter samples standout.
	fragColor = pow(fragColor/2e2,.2+fragColor-fragColor);
}