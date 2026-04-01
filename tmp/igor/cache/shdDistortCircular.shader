//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// 게임메이커에서 넘겨줄 Uniform 변수들
uniform vec2 u_resolution; // (width, height)
uniform float u_time;      // iTime
uniform vec2 u_center;      // 왜곡의 중심
uniform float u_intensity; // 효과의 강도 (0.0 ~ 1.0)
uniform float u_frequency; // 거리에 따른 왜곡의 주기
uniform float u_strength; // 왜곡의 강도

// 선형 보간 함수
vec2 lerp(vec2 v1, vec2 v2, float t) {
    return v1 + t * (v2 - v1);
}

void main()
{
    // 1. 기본 UV (v_vTexcoord는 이미 0.0 ~ 1.0 범위입니다)
    vec2 uv = v_vTexcoord;
    
    // 2. 화면 비율 계산
    float aspect = u_resolution.x / u_resolution.y;
    
    // 3. 마우스 좌표 (GML에서 좌표를 넘길 때 0~1 범위로 보정해서 넘기거나 여기서 계산)
    vec2 m_pos = u_center.xy / u_resolution.xy;

    // 4. 비율이 보정된 상대 좌표 계산
    vec2 rel = uv - m_pos;
    rel.x *= aspect; 
    
    // 보정된 거리 계산
    float d = length(rel);
    
    // 투명도
    float alpha = clamp(3.0 - d - u_intensity * 3.0, 0.0, 1.0);

    // 5. 회전 로직
    float percent = (1.0 + d * 1.0) * u_intensity;
    float theta = percent * percent * u_strength * sin(d * 10.0 * u_frequency);

    float s = sin(theta);
    float c = cos(theta);

    // 회전 행렬 적용
    vec2 rotated_rel = vec2(rel.x * c - rel.y * s, rel.x * s + rel.y * c);
    
    // 6. 다시 원래의 UV 공간으로 복구
    rotated_rel.x /= aspect;
    vec2 uv_distort = rotated_rel + m_pos;
    
    // 7. 효과 적용
    float lerp_factor = 1.0; 
    vec2 final_uv = lerp(uv, uv_distort, lerp_factor);

    // 게임메이커는 texture2D를 사용합니다.
    vec4 tex = texture2D(gm_BaseTexture, final_uv);

    gl_FragColor = v_vColour * vec4(tex.rgb, tex.a * alpha);
}

