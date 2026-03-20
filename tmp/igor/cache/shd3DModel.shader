//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vWorldNormal;
varying vec3 v_vWorldPosition;

void main()
{
    vec4 object_space_pos = vec4(in_Position, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    // 월드 공간 위치 및 노멀 계산
    v_vWorldPosition = (gm_Matrices[MATRIX_WORLD] * object_space_pos).xyz;
    v_vWorldNormal = normalize(mat3(gm_Matrices[MATRIX_WORLD]) * in_Normal);
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~
#extension GL_OES_standard_derivatives : enable

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vWorldNormal;
varying vec3 v_vWorldPosition;

uniform vec3 u_light_dir;
uniform vec4 u_light_col;
uniform float u_ambient;

// 강도 조절 유니폼 (0: 미사용, 0~1: 세기 조절)
uniform float u_normal;
uniform float u_roughness;
uniform float u_ao;
uniform float u_specular;

// 텍스처 샘플러 유니폼
uniform sampler2D u_sample_normal;
uniform sampler2D u_sample_roughness;
uniform sampler2D u_sample_ao;
uniform sampler2D u_sample_specular;

// 노멀 맵 적용 함수
vec3 getNormalFromMap()
{
    if (u_normal <= 0.0) return normalize(v_vWorldNormal);

    vec3 tangentNormal = texture2D(u_sample_normal, v_vTexcoord).xyz * 2.0 - 1.0;
    tangentNormal = mix(vec3(0.0, 0.0, 1.0), tangentNormal, u_normal);

    vec3 Q1  = dFdx(v_vWorldPosition);
    vec3 Q2  = dFdy(v_vWorldPosition);
    vec2 st1 = dFdx(v_vTexcoord);
    vec2 st2 = dFdy(v_vTexcoord);

    vec3 N   = normalize(v_vWorldNormal);
    vec3 T   = normalize(Q1 * st2.t - Q2 * st1.t);
    vec3 B   = -normalize(cross(N, T));
    mat3 TBN = mat3(T, B, N);

    return normalize(TBN * tangentNormal);
}

void main()
{
    vec4 tex_base = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // 러프니스 계산 (u_roughness가 0이면 기본값 0.5)
    float roughness_map = texture2D(u_sample_roughness, v_vTexcoord).r;
    float roughness = (u_roughness <= 0.0) ? 0.5 : mix(0.5, roughness_map, u_roughness);

    // AO 계산 (u_ao가 0이면 기본값 1.0)
    float ao_map = texture2D(u_sample_ao, v_vTexcoord).r;
    float ao = (u_ao <= 0.0) ? 1.0 : mix(1.0, ao_map, u_ao);

    // 스펙큘러 강도 계산 (u_specular가 0이면 기본값 0.5)
    float spec_map = texture2D(u_sample_specular, v_vTexcoord).r;
    float spec_strength = (u_specular <= 0.0) ? 0.0 : mix(0.5, spec_map, u_specular);

    // 최종 노멀 계산
    vec3 worldNormal = getNormalFromMap();

    // 조명 계산
    vec3 L = normalize(-u_light_dir);
    float diff = max(dot(worldNormal, L), 0.0);
    
    // 시선 방향 및 하프-벡터 (Specular용)
    // gm_Matrices[MATRIX_WORLD_VIEW]의 역행렬에서 카메라 위치를 가져오는 것이 정확하나, 
    // 여기서는 기본적으로 원점을 향하는 시선 혹은 전달받은 위치를 기반으로 계산합니다.
    vec3 V = normalize(-v_vWorldPosition); 
    vec3 H = normalize(L + V);
    
    // 스펙큘러 계산 (Blinn-Phong)
    float spec_power = mix(128.0, 2.0, roughness);
    float spec_val = pow(max(dot(worldNormal, H), 0.0), spec_power) * (1.0 - roughness);
    float spec = spec_val * spec_strength;

    // 최종 색상 조합
    vec3 ambient_final  = u_light_col.rgb * u_ambient * ao;
    vec3 diffuse_final  = u_light_col.rgb * diff * ao;
    vec3 specular_final = u_light_col.rgb * spec;

    // 텍스처 색상 및 버텍스 컬러 적용
    vec3 final_rgb = (ambient_final + diffuse_final) * tex_base.rgb * v_vColour.rgb + specular_final;

    gl_FragColor = vec4(final_rgb, tex_base.a * v_vColour.a);
}

