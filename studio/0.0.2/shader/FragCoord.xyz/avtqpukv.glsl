// Credit: @MilkDrop2077 (https://fragcoord.xyz/u/MilkDrop2077)
// Original shader: https://fragcoord.xyz/s/ao6dc217

// SPDX-License-Identifier: CC0-1.0
// Copyright (c) Public domain
//[LICENSE] https://creativecommons.org/publicdomain/zero/1.0/

// Random | Dave Hoskins (Shadertoy)
//[SNIPPET] https://fragcoord.xyz/snippet/5e2620d5-6000-4a00-8000-ff8240d536468000

// override uniforms to rotate i.e.: `#define u_drag vec2(0., -150.)`

float rand1(vec2 p)
{
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void main()
{
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution) / u_resolution.y;
    vec2 drag = u_drag / u_resolution;
    vec3 col = vec3(0);

    // Orbit camera: fixed at base angles, drag to offset
    float theta = 1.5 + drag.x * 3.0;
    float phi   = clamp(1.5 + drag.y * 3.0, 0.1, 1.5);
    float r     = max(11.-exp(u_scroll), 4.);

    vec3 ta = vec3(0.0, 0.8, 2.0);
    vec3 ro = ta + r * vec3(sin(phi) * sin(theta),
                            cos(phi),
                           -sin(phi) * cos(theta));

    vec3 ww = normalize(ta - ro),
         uu = normalize(cross(ww, vec3(0, 1, 0))),
         vv = cross(uu, ww),
         rd = normalize(uv.x * uu + uv.y * vv + 2.0 * ww);

    // Jitter starting t by a per-pixel hash to break up banding into noise
    float t = 1.5 + .1*rand1(gl_FragCoord.xy);
    for (float i = 0.; i < 150.; i++) {
         vec3 p = ro + t * rd;

        // Mirror X about 0: both sides sample the same frequency spectrum
        float fx = (abs(p.x)) / 8.0 ,   // x ∈ [-4..4] → freq ∈ [0..1]
              tz = p.z / 13.;
        // Only accumulate glow inside the terrain XZ slab; step fast outside
        if (fx > 1.0 || tz < 0.0 || tz > 1.0) {
            t += 0.12;
        } else {
            float fft = texture(u_audio, vec2(fx, tz)).b;
            float h    = fft * 2.;
            float surf = p.y - h;

            if (surf > .02) {
                // Glow: color / |dist_to_surface|^2 / depth
                col += (cos(h * 4. +1.+ vec3(0, 2, 4))*.5+.5)
                        * (fft + 0.001)
                        / pow(abs(surf) + 0.1, 2.)
                        / (1.+t*1.5);
            }
            t += max(abs(surf) * 0.09, 0.0001);
        }

        if (t > 26.0) break;
    }

    fragColor = vec4(tanh(col / 55.0), 1);    
}