// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Copyright (c) 2026 @Frostbyte
//[LICENSE] https://creativecommons.org/licenses/by-nc-sa/4.0/

// Credit: @Frostbyte (https://fragcoord.xyz/u/Frostbyte)
// Original shader: https://fragcoord.xyz/s/sw3qqd9w

//Density inspired by some fractals by yonatan found on https://jbaker.graphics/writings/DEC.html

//fft based on @MilkDrop2077 shader: https://fragcoord.xyz/s/ao6dc217
vec4 fft(){
    return vec4(texture(u_audio, vec2(0.8015873, 0)).x,
                texture(u_audio, vec2(0.0095238, 0)).x,
                texture(u_audio, vec2(0.015873, 0)).x,
                texture(u_audio, vec2(0.0205873, 0)).x );
}

void main(){
    
    //Define variables and set r to screenspace
    vec2 R=u_resolution.xy;
    float T=u_time,t,v;
    vec3 p,r=normalize(vec3(gl_FragCoord.xy*2.-R.xy,R.x));
    vec4 O;
    
    //rotate screenspace XY with time
    r.xy*=mat2(cos(T*.2+vec4(0,11,33,0)));

    //150 Volumetric Raymarch steps
    for(int i=0;i<150;i++){
        
        //p set to screenspace * accumulated distance (volumetric)
        p=t*r;

        //Rotate along z
        p.xy*=mat2(cos(p.z*1.+vec4(0,11,33,0)));
        
        // Warping p.z with rotation (stylistic blur/warp with accumulated volume)
        p+=vec3(vec2(0.05,sin(p.z*.01+10.)*.5)*mat2(cos(10.*sin(T*.2+length(vec3(p.xy*.25,p.z*.5)))*.3*+vec4(0,11,33,0))),T*.4);
        
        //Shift Slightly
        p.x-=T*.1;
        p.y+=2.5;
        //Repeat space XYZ
        p=fract(p.zxy-.5)-.5;
        
        //Fractal looping of space (Basically iterative mirroring, scaling, and shifting)
        for(int j=0;j<10;j++){
            p=abs(p.xzy);
            p*=1.7;
            p.x-=1.5;
        }
        
        //"t" accumulates volume 
        t+=
        
        //"v" is instance of distance at each step
        v=
        
        //Abs allows positive interior and step into shape
        abs(
        
        //union of crossing cylinders that have no radius (crossing lines)
        min(length(p.xz*.5+.8+p.x*.1),length(p.zy*.1+p.y*.5))
        
        //Adds softness to volumetrics as we force march through surface
        +.05)
        
        //reduce step size (smaller steps)
        /400.;
        
        //Color accumulated
        O.rgb+=
               
               //Palette Function and exp for interesting glow result
               exp(3.*(vec3(0.5,.11,.1)+3.*vec3(.1,.1,.1)*
               cos(6.28*(sin(length(p*.01)+T*.5)+r))))
               
               //Divide by intanced distance this creates glow as accumulated
               /v;
    }
    //Glow orbs inspired by Diatribes
    //Accumulated color divided to be brough into Tonemap range for Tanh and * for stylistic
    fragColor=tanh(O/5e6/pow(length(sin(r.xy*5.+T*.75)*.2), 2.*fft().z));
}