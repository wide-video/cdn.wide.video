void main() {
	vec2 I = gl_FragCoord.xy;

	//Clear fragcolor
	fragColor *= 0.;
	//Resolution for scaling
	vec2 v = u_resolution.xy,
	//Center and scale
	p = (I+I-v)/v.y;

	//Loop through arcs (i=radius, P=pi, l=length)
	for(float i=.2,l; i<1.; 
	//Pick color for each arc
	fragColor+=(cos(i*5.+vec4(0,1,2,3))+1.)*
	//Shade and attenuate light
	(1.+v.y/(l=length(v)+.003))/l)
		//Compute polar coordinate position
		v=vec2(mod(atan(p.y,p.x)+i+i*u_time,6.28)-3.14,1)*length(p)-i,
		//Clamp to light length
		v.x-=clamp(v.x+=i,-i,i),
		//Iterate radius
		i+=.05;

	//Tanh tonemap: shadertoy.com/view/ms3BD7
	fragColor=tanh(fragColor/1e2);
}