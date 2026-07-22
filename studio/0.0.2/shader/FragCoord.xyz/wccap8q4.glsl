/*
    "Waveform" by @Xor
*/
void main()
{
    vec2 I = gl_FragCoord.xy;

    //Raymarch iterator, step distance, depth and reflection
    float i, d, z, r;
    //Clear fragcolor and raymarch 90 steps
    for (fragColor *= i; i++ < 9e1;
    //Pick color and attenuate
    fragColor += (cos(z * 0.5 + u_time + vec4(0, 2, 4, 3)) + 1.3) / d / z)
    {
        //Raymarch sample point
        vec3 R = u_resolution.xyx,
        p = z * normalize(vec3(I + I, 0) - R);
        //Shift camera and get reflection coordinates
        r = max(-++p, 0.0).y;
        //Mirror and music
        p.y += r+r - 4.0 * texture(u_audio, vec2((p.x+4.5) / 30.0, (-p.z - 3.0) * 7e1 / R.y)).r;
        //Step forward (reflections are softer)
        z += d = 0.1 * (0.1 * r + abs(p.y) / (1.0 + r + r + r * r) + max(d = p.z + 3.0, -d * 0.1));
    }
    //Tanh tonemapping
    fragColor = tanh(fragColor / 9e2);
}