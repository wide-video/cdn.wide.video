// Created by inigo quilez - iq/2013
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org/


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // create pixel coordinates
	vec2 uv = fragCoord.xy / iResolution.xy;

    // the sound texture is 512x2
    int tx = int(uv.x*512.0);
    
	// first row is frequency data (48Khz/4 in 512 texels, meaning 23 Hz per texel)
	float fft  = texelFetch( u_audio, ivec2(tx,0), 0 ).x; 

    // second row is the sound wave, one texel is one mono sample
    float wave = texelFetch( u_audio, ivec2(tx,1), 0 ).x;
	
	// convert frequency to colors
	vec3 col = vec3( fft, 4.0*fft*(1.0-fft), 1.0-fft ) * fft;

    // add wave form on top	
	col += 1.0 -  smoothstep( 0.0, 0.15, abs(wave - uv.y) );
	
	// output final color
	fragColor = vec4(col,1.0);
}