varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 iResolution; // 화면 또는 그리는 영역의 해상도 (800.0, 608.0 등)

void main() {
    // 1. UV 및 좌표 설정 (v_vTexcoord는 이미 0~1 범위임)
    vec2 uv = v_vTexcoord;
    vec2 p = uv - 0.5;
    
    // 종횡비 보정 (iResolution.x / iResolution.y)
    p.x *= iResolution.x / iResolution.y;

    float radius = 0.32;
    float d = length(p);

    // 구 영역 밖은 검은색 또는 투명 처리
    if (d > radius) {
        if (d < radius + 0.03) {
            gl_FragColor = vec4(0.0, 0.5, 0.0, 1.0);
        }
        else {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
        }
        return;
    }

    // 2. 가짜 Z값 및 법선(Normal) 계산
    float theta = asin(d / radius);
    float z = cos(theta); 
    // 정규화된 법선 벡터 (Sphere Normal)
    vec3 normal = vec3(p / radius, z);

    // 3. 빛의 각도 설정 (월드 좌표 기준이 아닌 뷰 공간 기준)
    vec3 lightDirection = normalize(vec3(1.0, -1.0, 1.0)); 

    // 4. 라이팅 연산
    // 디퓨즈 (Diffuse)
    float diffuse = max(dot(normal, lightDirection), 0.0);
    
    // 스펙큘러 (Specular)
    vec3 viewDir = vec3(0.0, 0.0, 1.0);
    vec3 reflectDir = reflect(-lightDirection, normal);
    float specular = pow(max(dot(viewDir, reflectDir), 0.0), 32.0);

    // 5. UV 왜곡 및 텍스처 샘플링 (삼각함수 기반 구체 매핑)
    vec2 dir = normalize(p);
    float warpedDist = theta / (3.14159265 / 2.0);
    vec2 warpedUV = 0.5 + dir * (warpedDist * 0.5);
    
    // GameMaker에서는 texture2D와 gm_BaseTexture를 사용합니다.
    vec4 texCol = texture2D(gm_BaseTexture, warpedUV);

    // 6. 색상 결합 (앰비언트 + 디퓨즈 + 스펙큘러)
    vec3 ambient = vec3(0.5);
    vec3 finalRGB = texCol.rgb * min((diffuse + ambient), 1.0);
    finalRGB *= (1.0 + specular);
    finalRGB += specular;

    gl_FragColor = v_vColour * vec4(finalRGB, texCol.a);
}