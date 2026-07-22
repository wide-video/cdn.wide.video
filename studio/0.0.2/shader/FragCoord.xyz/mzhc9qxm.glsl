// Neon Strands
// By Noztol

#define look smoothstep(-1.,1., sin(u_time*.25+1.))

// Neon Rainbow Palette
vec3 palette(float t){
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.33, 0.67);
    return a + b * cos(6.28318 * (c * t + d));
}

// ACES Tonemapping
vec3 aces(vec3 color) {    
    const mat3 M1 = mat3(
        0.59719, 0.07600, 0.02840,
        0.35458, 0.90834, 0.13383,
        0.04823, 0.01566, 0.83777
    );
    
    const mat3 M2 = mat3(
        1.60475, -0.10208, -0.00327,
       -0.53108,  1.10813, -0.07276,
       -0.07367, -0.00605,  1.07602
    );

    vec3 v = M1 * color;    
    vec3 a = v * (v + 0.0245786) - 0.000090537;
    vec3 b = v * (0.983729 * v + 0.4329510) + 0.238081;
        
    return M2 * (a / b); 
}

#define INTERPOLANT 0

vec3 hash( vec3 p ) 
{
    p = vec3( dot(p,vec3(127.1,311.7, 74.7)),
              dot(p,vec3(269.5,183.3,246.1)),
              dot(p,vec3(113.5,271.9,124.6)));

    return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

float noise( in vec3 p )
{
    vec3 i = floor( p );
    vec3 f = fract( p );

    #if INTERPOLANT==1
    vec3 u = f*f*f*(f*(f*6.0-15.0)+10.0);
    #else
    vec3 u = f*f*(3.0-2.0*f);
    #endif    

    return mix( mix( mix( dot( hash( i + vec3(0.0,0.0,0.0) ), f - vec3(0.0,0.0,0.0) ), 
                          dot( hash( i + vec3(1.0,0.0,0.0) ), f - vec3(1.0,0.0,0.0) ), u.x),
                     mix( dot( hash( i + vec3(0.0,1.0,0.0) ), f - vec3(0.0,1.0,0.0) ), 
                          dot( hash( i + vec3(1.0,1.0,0.0) ), f - vec3(1.0,1.0,0.0) ), u.x), u.y),
                mix( mix( dot( hash( i + vec3(0.0,0.0,1.0) ), f - vec3(0.0,0.0,1.0) ), 
                          dot( hash( i + vec3(1.0,0.0,1.0) ), f - vec3(1.0,0.0,1.0) ), u.x),
                     mix( dot( hash( i + vec3(0.0,1.0,1.0) ), f - vec3(0.0,1.0,1.0) ), 
                          dot( hash( i + vec3(1.0,1.0,1.0) ), f - vec3(1.0,1.0,1.0) ), u.x), u.y), u.z );
}

float pattern(vec3 p){
    float f = noise(p / 12.0) * 12.0;
    return f;
}

void main() {
  vec2 fragCoord = gl_FragCoord.xy;

    fragColor -= fragColor;
    vec2 uv = (fragCoord - 0.5 * u_resolution.xy) / u_resolution.y;
    float d = 0.0, s = 0.0; 
    vec3 p;        

    // Read audio bands outside the loop (row 0.0 is frequency data in Shadertoy)
    // Squared to make the pops sharper and less noisy
    float bass = pow(texture(u_audio, vec2(0.05, 0.0)).x, 2.0);
    float mid  = pow(texture(u_audio, vec2(0.40, 0.0)).x, 2.0);
    float high = pow(texture(u_audio, vec2(0.80, 0.0)).x, 2.0);

    // Map audio bands to RGB impact multipliers
    vec3 audioPop = vec3(bass, mid, high) * 3.5;

    //ray march
    for (float i = 0.0; i < 80.0; i++) {
        
        // Nonlinear stepping
        s = 0.01 + abs(s) * 0.4;
        d += s;
       
        p = vec3(uv * d * 2.0, d + u_time * 2.0);
        
        // Twists and Turns
        vec2 path = vec2(sin(p.z * 0.15) * 2.5, cos(p.z * 0.1) * 2.5);
        p.xy -= path;

        // Rotation
        float a = p.z * 0.05 + 2.0;
        mat2 rot = mat2(cos(a), sin(a), -sin(a), cos(a));
        p.xy *= rot;

        // Density field
        s = abs(sin(p.z + p.y + u_time) * (0.05 + 0.45 * look));
        float density = abs(pattern(p));
        s += density;

        // Tunnel shaping
        float clear = length(p.xy) - 0.4;
        s = max(-clear, s); 

        // Base rainbow palette
        vec3 col = palette(d * 0.1 - u_time * 0.5);
        
        
        vec3 finalCol = col * (audioPop + 0.02);

        // Distance fade acts like black fog so the background stays deep
        float fade = exp(-d * 0.15);

        // Accumulate with tight falloff (preventing whiteouts)
        fragColor.rgb += (finalCol * 0.02 / (s + 0.01)) * fade;
    }

    fragColor.rgb = aces(fragColor.rgb);
    fragColor = pow(fragColor, vec4(0.4545));
}