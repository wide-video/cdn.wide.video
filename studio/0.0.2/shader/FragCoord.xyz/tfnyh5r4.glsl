// Credit: @Frostbyte (https://fragcoord.xyz/u/Frostbyte)
// Original shader: https://fragcoord.xyz/s/tss68cob
//Remix of Old Eclipse fractal like shaders

// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// Copyright (c) 2026 @Frostbyte
//[LICENSE] https://creativecommons.org/licenses/by-nc-sa/4.0/

//fft based on @MilkDrop2077 shader: https://fragcoord.xyz/s/ao6dc217
vec4 fft(){
    vec2 uv = gl_FragCoord.xy / u_resolution;

    float numBars = 64.0;
    float slotW   = u_resolution.x / numBars;
    float gapPx   = 4.0;

    float barIndex = floor(gl_FragCoord.x / slotW);
    float slotX    = mod(gl_FragCoord.x, slotW);
    //Define some variables
    float audioStart;   
    float audioEnd;   
    
    float selectBar;
    float audioX;
    vec4 tex;
    //Sample bar 1 ... This could be done as to only sample tex once I believe
    selectBar = 1.;
    audioStart = 0.0;
    audioEnd   = 0.1;
    barIndex = selectBar;
    audioX   = audioStart + (barIndex / (numBars - 1.0)) * (audioEnd - audioStart);
    tex = texture(u_audio, vec2(audioX, 0.0));
    float ValueofBar1 = tex.x;
    //Sample bar 2 ... This could be done as to only sample tex once I believe
    selectBar = 2.;
    audioStart = 0.0;
    audioEnd   = 0.6;
    barIndex = selectBar;
    audioX   = audioStart + (barIndex / (numBars - 1.0)) * (audioEnd - audioStart);
    tex = texture(u_audio, vec2(audioX, 0.0));
    float ValueofBar2 = tex.x;
    //float visualizeBars = uv.y/tex.x;

    
    
    return vec4(ValueofBar2,ValueofBar1,0,0);
}
void main(){
    
    //Define variables and set r to screenspace
    vec2 R=u_resolution.xy;
    float T=u_time,t,v;
    vec3 p,r=normalize(vec3(gl_FragCoord.xy*2.-R.xy,R.x));
    vec4 O;
    
    //rotate screenspace XY with time
    r.xy*=mat2(cos(T*.2+vec4(0,11,33,0)));
    
    //100 Volumetric Raymarch steps
    for(int i=0;i<100;i++){
        
        //p set to screenspace * accumulated distance (volumetric)
        p=t*r;
        p.xy*=mat2(cos(p.z+vec4(0,11,33,0)));
        
        // Warping p.z with rotation (stylistic blur/warp with accumulated volume)
        p+=vec3(vec2(0.0+.5*smoothstep(.0,.9,fft().y),sin(p.z+T*.5)*.2)*mat2(cos(sin(length(p.xyz))*+vec4(0,11,33,0))),T*.3);
        
        //Repeat space XYZ
        p=fract(p.zxy-.5)-.5;
        
        //Fractal looping of space (Basically iterative mirroring, scaling, and shifting)
        for(int j=0;j<10;j++){
            p=abs(p.zxy);
            p*=1.55;
            p.x--;
        }
        
        //"t" accumulates volume 
        t+=
        
        //"v" is instance of distance at each step
        v=
        
        //Abs allows positive interior and step into shape
        abs(
        
        //union of crossing cylinders that have no radius (crossing lines)
        min(length(p.xz*.5+p.z-1.5*smoothstep(.1,.9,fft().x)),length(p.zy*.5+p.x))
        
        //Adds softness to volumetrics as we force march through surface
        +.04)
        
        //reduce step size (smaller steps)
        /300.;
        
        //Color accumulated
        O.rgb+=
               
               //Palette Function and exp for interesting glow result
               exp(2.5*(vec3(0.9,.8,.5)+vec3(.5,.1,0.0)*
               cos(6.28*(length(p*.01)+.6+p.z*.2))))
               
               //Divide by intanced distance this creates glow as accumulated
               /v;
    }
    
    //Accumulated color divided to be brought into Tonemap range for Tanh and multipled stylistic
    //Try out look from Diatribes: replace line with commented fragColor
    fragColor=tanh(O/3e7)*30.; //fragColor=tanh(O/3e7/pow(length(r.xy), 4.*fft().x));
}