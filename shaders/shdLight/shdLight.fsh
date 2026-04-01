varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_resolution; // 서피스 또는 화면 해상도 (width, height)
uniform vec2 u_center;     // 빛의 중심 픽셀 좌표 (x, y)
uniform vec3 u_color;      // 빛의 색상 (r, g, b)
uniform float u_dist_min;  // 최대 밝기 유지 픽셀 거리
uniform float u_dist_max;  // 빛이 사라지는 픽셀 거리

void main() {
    // 1. 현재 픽셀의 절대 좌표 계산 (UV * 해상도)
    vec2 pixel_pos = v_vTexcoord * u_resolution;

    // 2. 중심점(u_center)으로부터 현재 픽셀까지의 거리(픽셀 단위) 계산
    float dist = distance(pixel_pos, u_center);

    // 3. 픽셀 거리를 기반으로 부드러운 감쇄(Falloff) 계산
    // u_dist_min과 u_dist_max는 이제 0.5 같은 비율이 아니라 100.0, 500.0 같은 픽셀 값입니다.
    float strength = 1.0 - smoothstep(u_dist_min, u_dist_max, dist);

    // 4. 최종 색상 출력
    vec4 base_tex = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(u_color, strength * base_tex.a);
}