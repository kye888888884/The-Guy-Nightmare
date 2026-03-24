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

