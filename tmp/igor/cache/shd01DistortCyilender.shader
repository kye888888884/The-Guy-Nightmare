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
// shdDistortCylinder.fsh
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_res; // 해상도 (width, height)

void main()
{
    // UV 좌표 (0.0 ~ 1.0)
    vec2 uv = v_vTexcoord;
    
    // 중심점 기준 (-0.5 ~ 0.5)
    vec2 p = uv - 0.5;
    
    float d = abs(p.y);
    float r = 0.55; // 원통 반지름 설정
    
    // 원통형 왜곡 효과 (X축 확장)
    if (d < r) {
        // p.x *= 1.0 + 0.5 * (1.0 - d / r);
        
        // 원통 표면 계산 (Normal 및 Light)
        float theta = asin(d / r);
        float z = cos(theta);
        vec3 normal = vec3(0.0, p.y / r, z);

        // 간단한 디퓨즈 라이팅
        vec3 lightDirection = normalize(vec3(1.0, 0.0, 1.0)); 
        float diffuse = max(dot(normal, lightDirection), 0.0);

        // 왜곡된 UV 좌표 계산
        float wdist = theta / (3.141592 / 1.570796); // PI / 2.0
        vec2 uv_distort;
        uv_distort.x = p.x + 0.5;
        uv_distort.y = 0.5 + sign(p.y) * wdist * 0.8;

        // 텍스처 샘플링 (경계 밖 예외 처리 포함)
        if (uv_distort.x >= 0.0 && uv_distort.x <= 1.0 && 
            uv_distort.y >= 0.0 && uv_distort.y <= 1.0) {
            
            vec4 col = texture2D(gm_BaseTexture, uv_distort);
            vec3 result = col.rgb * (-diffuse * 0.8 + 1.0);
            vec3 green = (1.0 - diffuse) * vec3(0.0, 1.0, 0.0) * 0.5;
            result += green * green; // 녹색 Ambient 추가
            gl_FragColor = v_vColour * vec4(result, col.a);
        } else {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
        }
    } else {
        // 원통 영역 밖은 투명하거나 기본 텍스처 출력
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}

