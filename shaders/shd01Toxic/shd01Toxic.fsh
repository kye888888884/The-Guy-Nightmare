varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_y;      // 수면의 y좌표 (픽셀 단위)
uniform float u_wave;   // 파도의 강도
uniform float u_num;    // 파도의 수
uniform float u_line;   // 수면 선의 두께
uniform float u_time;   // 시간 값
uniform float u_is_light; // 빛 효과 활성화 여부 (0.0 또는 1.0)
uniform vec2 u_res;     // 해상도 (width, height)
uniform vec2 u_pos;

uniform sampler2D u_tex_noise; // iChannel1 대신 사용할 노이즈 샘플러

void main()
{
    float _y = 1.0 - (u_y / u_res.y);
    vec2 uv = (gl_FragCoord.xy + u_pos) / u_res.xy;
    uv.y = -uv.y + 1.0;
    vec2 uv_wave = uv;
    uv.x *= u_num;
    
    // 수면 효과 (파도처럼 보이도록)
    uv_wave.y += u_wave * 0.1 * sin(uv.x * 20.0 + u_time);
    uv_wave.y += u_wave * 0.05 * sin(uv.x * 50.0 + u_time * -1.0);
    
    vec4 final_col;

    float green = texture2D(gm_BaseTexture, uv).g;
    uv.y *= u_num;

    if (u_is_light < 0.5) {
        if (uv_wave.y < _y) {
            float dist = _y - uv_wave.y;
            
            // 거리 기반 색 단계 계산
            float green_base = smoothstep(0.0, 1.0, dist * 2.0 + 0.4);
            
            if (dist < u_line) {
                green_base = 0.5;
            }
            else {
                // 샘플러(u_tex_noise)를 사용한 노이즈 효과
                float noise_val = texture2D(u_tex_noise, uv + u_pos.x * 0.000315 + u_time * 0.01).r;
                float green_effect = 0.3 + 0.3 * sin(u_time + 6.28 * noise_val);
                
                // Floor 연산을 이용한 색상 단계화 (포스터라이즈)
                // float steps = 4.0;
                // green_base = floor((green_base + green_effect) * steps) / steps;
                green_base += green_effect;
                green_base += 0.3 * smoothstep(1.0, 0.0, dist / 0.05);
            }
            
            final_col = vec4(0.0, green_base * green, 0.0, 1.0);
        }
        else {
            discard;
        }
    }
    else {
        if (uv_wave.y > _y) {
            float dist = uv_wave.y - _y;
            float green_base = smoothstep(1.0, 0.0, (dist / 0.2));
            final_col = vec4(0.0, green_base * 0.5, 0.0, green_base * green_base);
        }
    }

    gl_FragColor = v_vColour * final_col;
}