// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Copyright (c) 2026 @Frostbyte
//[LICENSE] https://creativecommons.org/licenses/by-nc-sa/4.0/

// Credit: @Frostbyte (https://fragcoord.xyz/u/Frostbyte)
// Original shader: https://fragcoord.xyz/s/sw3qqd9w

//Remix of Shader "Neon Shells" by Old Eclipse: https://www.shadertoy.com/view/scjSRt
//Density inspired by some fractals by yonatan found on https://jbaker.graphics/writings/DEC.html

void main(){
    
    //Define variables and set r to screenspace
    vec2 R=u_resolution.xy;
    float T=u_time,t,v;
    vec3 p,r=normalize(vec3(gl_FragCoord.xy*2.-R.xy,R.x));
    vec4 O;
    
    //rotate screenspace XY with time
    r.xy*=mat2(cos(T*.2+vec4(0,11,33,0)));
    for(int i=0;i<100;i++){
        p=t*r;
        p.xy*=mat2(cos(p.z*2.-T*.1+vec4(0,11,33,0)));
        
        // Warping p.z with rotation (stylistic blur/warp with accumulated volume)
        p+=vec3(vec2(0.1+.075*texture(u_audio, vec2(0.1150873, 8)).x,sin(0.)*.1)*mat2(cos(15.*sin(T*.02+sin(p.x*.1))*.5*+vec4(0,11,33,0))),T*.02);

        //Repeat space XYZ
        p=fract(p.zxy-.5)-.5;
        
        //Fractal looping of space (Basically iterative mirroring, scaling, and shifting)
        for(int j=0;j<10;j++){
            p=abs(p.yzx);
            p*=1.55;
            p.x-=1.5;
        }
        
        //"t" accumulates volume 
        t+=
        
        //"v" is instance of distance at each step
        v=
        
        //Abs allows positive interior and step into shape
        abs(
        
        //union of crossing cylinders that have no radius (crossing lines)
        min(length(p.xz*.5+p.y*.75),length(p.zy*.1+p.y*.5))
        
        //Adds softness to volumetrics as we force march through surface
        +.01)
        
        //reduce step size (smaller steps)
        /500.;
        
        //Color accumulated
        O.rgb+=
               
               //Palette Function and exp for interesting glow result
               exp(2.*(vec3(0.5,.4,.5)+vec3(.9,.2,0.5+texture(u_audio, vec2(0.05873, 0)).x)*
               cos(6.28*(sin(length(p*.030+T))+p.z*.9+r*.5))))
               
               //Divide by intanced distance this creates glow as accumulated
               /v;
    } 
    //Accumulated color divided to be brough into Tonemap range for Tanh and *25 stylistic
    fragColor=tanh(O/4e7)*30.;
}