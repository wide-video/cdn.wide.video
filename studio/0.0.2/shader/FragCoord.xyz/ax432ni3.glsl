uniform float u_gain;           // 4, [0.5, 10.0]   -- sensitivity / ceiling (higher = red easier)
uniform float u_gamma;          // 1.5, [0.2, 2.0]    -- curve shape (<1 lifts quiet, >1 crushes lows)
uniform float u_hueShift; //0, [-1, 1]
uniform float u_dither; //0.02, [0, 0.1]
uniform float u_floorHeight;   // 0.2, [0.0, 1.0]  -- base height for silent audio

// Jet colourmap with optional hue rotation
vec3 jet(float t, float hueShift) {
    t = clamp(t, 0.0, 1.0);
    vec3 col;
    if (t < 0.125) {
        col = mix(vec3(0.0,0.0,0.5), vec3(0.0,0.0,1.0), t/0.125);
    } else if (t < 0.375) {
        col = mix(vec3(0.0,0.0,1.0), vec3(0.0,1.0,1.0), (t-0.125)/0.25);
    } else if (t < 0.625) {
        col = mix(vec3(0.0,1.0,1.0), vec3(1.0,1.0,0.0), (t-0.375)/0.25);
    } else if (t < 0.875) {
        col = mix(vec3(1.0,1.0,0.0), vec3(1.0,0.0,0.0), (t-0.625)/0.25);
    } else {
        col = mix(vec3(1.0,0.0,0.0), vec3(0.5,0.0,0.0), (t-0.875)/0.125);
    }
    // Hue rotation
    float a = hueShift * 6.2831853; // map to radians
    float c = cos(a);
    float s = sin(a);
    mat3 rot = mat3(
        vec3(0.299+0.701*c+0.168*s, 0.587-0.587*c+0.330*s, 0.114-0.114*c-0.497*s),
        vec3(0.299-0.299*c-0.328*s, 0.587+0.413*c+0.035*s, 0.114-0.114*c+0.292*s),
        vec3(0.299-0.300*c+1.250*s, 0.587-0.588*c-1.050*s, 0.114+0.886*c-0.203*s)
    );
    return clamp(col * rot, 0.0, 1.0);
}

// Pseudo‑random hash for dithering
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void main() {
    // === CAMERA SETTINGS  ===
    float camDist = 30.0;
    float fov = radians(20.0);
    float rotation = radians(0.0);

    // === SETUP ===
    vec2 res = u_resolution.xy;
    float aspect = res.x / res.y;

    vec2 ndc = vec2(
        (2.0 * gl_FragCoord.x / res.x - 1.0) * aspect,
         1.0 - 2.0 * gl_FragCoord.y / res.y
    );

    vec3 rd = normalize(vec3(ndc * tan(fov * 0.5), -1.0));
    vec3 ro = vec3(0.0, 0.0, camDist);

    float cr = cos(rotation);
    float sr = sin(rotation);
    rd = vec3(rd.x * cr - rd.z * sr, rd.y, rd.x * sr + rd.z * cr);

    // === SCENE BOUNDS (time = Y, frequency = X) ===
    float timeHalf = 35.0 * 0.5;
    float freqHalf = 20.0 * 0.5;
    const float ypow_max = log(20.0);

    float tmin = 0.0;
    float tmax = -ro.z / rd.z;
    int steps = 400;
    float dt = (tmax - tmin) / float(steps);
    const float heightScale = 10.0;

    vec3 col = vec3(0.0);
    float t = tmin;
    float prevMag = -1.0;
    float prevT = tmin;
    bool hit = false;
    float hitMag = 0.0;

    for (int i = 0; i < steps; i++) {
        vec3 p = ro + t * rd;

        // Bounds check
        if (abs(p.x) > freqHalf || abs(p.y) > timeHalf) {
            t += dt;
            continue;
        }

        // Map world coordinates to u_audio texture
        float texFreq;
        if (p.x < 11.0) {
            float arg = max(11.0 - p.x, 1.0);
            texFreq = 1.0 - log(arg) / ypow_max;
        } else {
            texFreq = 1.0;
        }
        texFreq = clamp(texFreq, 0.0, 1.0);

        float texTime = (p.y + timeHalf) / (2.0 * timeHalf);
        texTime = clamp(texTime, 0.0, 1.0);

        float mag = texture(u_audio, vec2(texTime, texFreq)).r;

        // Apply gain & gamma (tunable)
        mag = pow(mag, u_gamma);
        mag = min(mag * u_gain, 1.0);

       float h = mag * heightScale + u_floorHeight;

        // ---- Anti‑aliased intersection ----
        if (p.z <= h) {
            if (prevMag >= 0.0) {
                float prevH = prevMag * heightScale;
                float alpha = (prevH - (ro.z + prevT * rd.z)) /
                               ((prevH - (ro.z + prevT * rd.z)) + ((ro.z + t * rd.z) - h));
                float exactT = mix(prevT, t, alpha);
                vec3 exactP = ro + exactT * rd;

                float texFreq2;
                if (exactP.x < 11.0) {
                    float arg2 = max(11.0 - exactP.x, 1.0);
                    texFreq2 = 1.0 - log(arg2) / ypow_max;
                } else {
                    texFreq2 = 1.0;
                }
                texFreq2 = clamp(texFreq2, 0.0, 1.0);
                float texTime2 = (exactP.y + timeHalf) / (2.0 * timeHalf);
                texTime2 = clamp(texTime2, 0.0, 1.0);

                float exactMag = texture(u_audio, vec2(texTime2, texFreq2)).r;
                exactMag = pow(exactMag, u_gamma);
                exactMag = min(exactMag * u_gain, 1.0);
                hitMag = exactMag;
                hit = true;
            } else {
                hitMag = mag;
                hit = true;
            }
            break;
        }

        prevMag = mag;
        prevT = t;
        t += dt;
    }

    if (hit) {
        col = jet(hitMag, u_hueShift);

        // ---- Dithering (tunable) ----
        float dither = hash(gl_FragCoord.xy + fract(u_time) * 100.0) * 2.0 - 1.0;
        dither *= u_dither;
        col += dither;
        col = clamp(col, 0.0, 1.0);
    }

    fragColor = vec4(col, 1.0);
}