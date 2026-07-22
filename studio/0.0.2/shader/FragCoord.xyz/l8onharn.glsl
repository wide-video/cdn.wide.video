uniform sampler2D u_audio; // [mirror nearest]

// Credit: @Xor (https://fragcoord.xyz/u/Xor)
// Original shader: https://fragcoord.xyz/s/laubjpi7

void main()
{
    for(float i;i++<1e2;)
    {
        vec2 c = ((2.*gl_FragCoord.xy-u_resolution)/u_resolution.y*4e1-vec2(0,i-5e1)*.3)*vec2(1,2)*
        mat2(cos(.2*u_time+vec4(0,33,11,0)));
        fragColor += (sqrt(i/1e2)-fragColor)/exp(abs(1e2*texture(u_audio, c/vec2(512,1e2)).b/(1.+abs(c.y)/1e1)-i));
    }
}