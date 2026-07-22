// SPDX-License-Identifier: CC0-1.0
// Copyright (c) Public domain
//[LICENSE] https://creativecommons.org/publicdomain/zero/1.0/

void main() {
    // Normalized screen uvs [0, 1]
    vec2 uv = gl_FragCoord.xy / u_resolution;

    // Black background
    fragColor = vec4(0.0, 0.0, 0.0, 1.0);

    float numBars = 64.0;
    float slotW   = u_resolution.x / numBars;
    float gapPx   = 4.0;

    float barIndex = floor(gl_FragCoord.x / slotW);
    float slotX    = mod(gl_FragCoord.x, slotW);

    if (slotX >= slotW - gapPx) return;

    // Edge-to-edge bars : the empty right portion is just the audio texture having no data there
    float audioStart = 0.0;   
    float audioEnd   = 0.6;   

    float audioX   = audioStart + (barIndex / (numBars - 1.0)) * (audioEnd - audioStart);
    float amplitude = texture(u_audio, vec2(audioX, 0.0)).r;

    if (uv.y < amplitude) {
        vec3 barColor = mix(
            vec3(0.1, 0.9, 0.3),
            vec3(1.0, 0.2, 0.1),
            uv.y / amplitude
        );
        fragColor = vec4(barColor, 1.0);
    }
}