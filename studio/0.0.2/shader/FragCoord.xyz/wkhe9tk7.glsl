void main()
{
	vec2 R = u_resolution.xy, 
	U = 2.*gl_FragCoord.xy - R;
	float a = atan(U.y, U.x) / 6.283 ;
	a += ceil( U = 5.*length(U)/R - a ).y;
	U.x = 2.6 * a*a - u_time;
	a = dot( U = 2.*fract( U ) - 1. ,
	cos( .4*a*a * max(0., 1. - length(U) ) - vec2(33, 0) ));
	fragColor = vec4( min(1., a / fwidth(a) + .5) - pow( U.y*U.y, 5.) );
}