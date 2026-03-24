varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_resolution; // 서피스 크기
uniform float u_direction; // 0: 가로, 1: 세로

void main() {
    vec2 blurSize = 1.0 / u_resolution;
    vec4 sum = vec4(0.0);
    
    // 단순화된 5-탭 가우시안 샘플링 (실제론 더 많은 샘플을 사용함)
    vec2 offset = (u_direction == 0.0) ? vec2(blurSize.x, 0.0) : vec2(0.0, blurSize.y);

    sum += texture2D(gm_BaseTexture, v_vTexcoord - offset * 2.0) * 0.05;
    sum += texture2D(gm_BaseTexture, v_vTexcoord - offset) * 0.25;
    sum += texture2D(gm_BaseTexture, v_vTexcoord) * 0.4;
    sum += texture2D(gm_BaseTexture, v_vTexcoord + offset) * 0.25;
    sum += texture2D(gm_BaseTexture, v_vTexcoord + offset * 2.0) * 0.05;

    gl_FragColor = v_vColour * sum;
}