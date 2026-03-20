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
