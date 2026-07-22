/*
    "Waveform" by @XorDev
    
    I wish Soundcloud worked on ShaderToy again
*/
void mainImage(out vec4 O, vec2 I)
{
    //Raymarch iterator, step distance, depth and reflection
    float i, d, z, r;
    //Clear fragcolor and raymarch 90 steps
    for(O*= i; i++<9e1;
    //Pick color and attenuate
    O += (cos(z*.5+iTime+vec4(0,2,4,3))+1.3)/d/z)
    {
        //Raymarch sample point
        vec3 p = z * normalize(vec3(I+I,0) - iResolution.xyy);
        //Shift camera and get reflection coordinates
        r = max(-++p, 0.).y;
        //Mirror
        p.y += r+r;
        //Music test
        p.y += -4.*texture(u_audio, vec2(p.x,-10)/2e1+.5,2.).r;
        
        //Sine waves
        for(d=1.; d<3e1; d+=d)
            p.y += cos(p*d+2.*iTime*cos(d)+z).x/d;
            
        //Step forward (reflections are softer)
        z += d = (.1*r+abs(p.y-1.)/ (1.+r+r+r*r) + max(d=p.z+3.,-d*.1))/8.;
    }
    //Tanh tonemapping
    O = tanh(O/9e2);
}