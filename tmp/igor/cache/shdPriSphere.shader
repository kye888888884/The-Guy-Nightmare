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

uniform float u_radius; // 구의 반지름 (예: 0.5)
uniform vec3 u_light_dir; // 빛의 방향 (예: (1.0, -1.0, 1.0))
uniform float u_ambient;
uniform float u_alpha;
uniform float u_ref; // 굴절률 (1.0 기본)
uniform float u_zoom; // 줌 레벨 (1.0 기본)
uniform vec2 iResolution; // 화면 또는 그리는 영역의 해상도 (800.0, 608.0 등)

void main() {
    // 1. UV 및 좌표 설정 (v_vTexcoord는 이미 0~1 범위임)
    vec2 uv = v_vTexcoord;
    vec2 p = uv - 0.5;
    
    // 종횡비 보정 (iResolution.x / iResolution.y)
    p.x *= iResolution.x / iResolution.y;

    float radius = u_radius;
    float d = length(p) * u_ref;

    // 구 영역 밖은 검은색 또는 투명 처리
    if (d > radius) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    // 2. 가짜 Z값 및 법선(Normal) 계산
    float theta = asin(d / radius);
    float z = cos(theta); 
    // 정규화된 법선 벡터 (Sphere Normal)
    vec3 normal = vec3(p / radius, z);

    // 3. 빛의 각도 설정 (월드 좌표 기준이 아닌 뷰 공간 기준)
    vec3 lightDirection = normalize(u_light_dir);

    // 4. 라이팅 연산
    // 디퓨즈 (Diffuse)
    float diffuse = clamp(dot(normal, lightDirection) + 1.0 - u_alpha * 0.3, 0.0, 1.0);
    
    // 스펙큘러 (Specular)
    vec3 viewDir = vec3(0.0, 0.0, 1.0);
    vec3 reflectDir = reflect(-lightDirection, normal);
    float specular = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);

    // 5. UV 왜곡 및 텍스처 샘플링 (삼각함수 기반 구체 매핑)
    vec2 dir = normalize(p) / (u_ref * u_zoom);
    float warpedDist = theta / (3.14159265 / 2.0);
    vec2 warpedUV = 0.5 + dir * (warpedDist * 0.5);
    
    // GameMaker에서는 texture2D와 gm_BaseTexture를 사용합니다.
    vec4 texCol = texture2D(gm_BaseTexture, warpedUV);

    // 6. 색상 결합 (앰비언트 + 디퓨즈 + 스펙큘러)
    vec3 ambient = vec3(u_ambient);
    vec3 finalRGB = texCol.rgb * min((diffuse + ambient + specular), 1.0);
    finalRGB *= diffuse;

    float alpha = texCol.a;
    if (u_alpha > 0.5) {
        alpha *= diffuse;
    }
    gl_FragColor = v_vColour * vec4(finalRGB, alpha);
}

