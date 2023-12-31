#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uValue;

out vec4 fragColor;

vec3 pallete(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);
    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    vec2 uv = (FlutterFragCoord().xy * 2.0 - uSize.xy) / uSize.x;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);
    for (int i = 0; i < 4; i++) {
        uv = fract(uv * 1.5) - 0.5;
        float d = length(uv) * exp(-length(uv0));
        vec3 col = pallete(length(uv0) + i * 0.4 + uTime * 0.4);
        d = sin(d * (8.0 + uValue) + uTime) / 8.0;
        d = abs(d);
        d = pow(0.01 / d, 1.2);
        finalColor += col * d;
    }
    fragColor = vec4(finalColor, 1.0);
}