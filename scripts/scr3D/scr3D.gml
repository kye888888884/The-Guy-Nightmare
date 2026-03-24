function start_3d() {
	vertex_format_begin()
	vertex_format_add_position_3d() //x,y,z
	vertex_format_add_normal() //nx,ny,nz
	vertex_format_add_color() //color,alpha
	vertex_format_add_texcoord() //xtex,ytex
	global._vformat = vertex_format_end()
    global._vbuffs = ds_map_create()
}

function end_3d() {
	vertex_format_delete(global._vformat)
    var _keys = ds_map_keys_to_array(global._vbuffs)
    for (var k = 0; k < array_length(_keys); k++) {
        vertex_delete_buffer(global._vbuffs[? _keys[k]])
    }
    ds_map_destroy(global._vbuffs)
}

function get_3d_model(_filename, _ext = ".buf") {
    var _b = buffer_load(_filename + _ext)
    var _model = vertex_create_buffer_from_buffer(_b, global._vformat)
    ds_map_add(global._vbuffs, _filename, _model)
    buffer_delete(_b)
    return _model
}

function matrix() {
    return instance_create(_matrix, 0, 0)
}

function pos_on_matrix(_mat, _x, _y, _z) {
    var _pos = matrix_transform_vertex(_mat, _x, _y, _z)
    return {x: _pos[0], y: _pos[1], z: _pos[2]}
}

function v_add(_vb, _x, _y, _z, _nx, _ny, _nz, _u, _v) {
    vertex_position_3d(_vb, _x, _y, _z);
    vertex_normal(_vb, _nx, _ny, _nz);
    vertex_colour(_vb, c_white, 1);
    vertex_texcoord(_vb, _u, _v);
}

function create_vbuff(_name) {
    var _vbuff = global._vbuffs[? _name]

    if (_vbuff == undefined) {
        var _vbuff = vertex_create_buffer()
        ds_map_add(global._vbuffs, _name, _vbuff)
    }

    return _vbuff
}

function get_vbuff(_name) {
    var _vbuff = global._vbuffs[? _name]
    
    if (_vbuff == undefined) {
        return -1
    }
    return _vbuff
}

function draw_cylinder(cx, cy, cz, dx, dy, dz, rx, ry, rz, _r, _steps, _tex, world_mat = matrix_build_identity()) {
    var _vbuff = get_vbuff("cylinder" + string(_steps))
    if (_vbuff == -1) _vbuff = create_model_cylinder(_steps)

    var _dist = sqrt(dx*dx + dy*dy + dz*dz)
    if (_dist == 0) return
    
    var _m_scale = matrix_build(0, 0, 0, 0, 0, 0, _r, _r, _dist / 2);

    var _yaw = point_direction(0, 0, dx, dy)
    var _dist_xy = point_distance(0, 0, dx, dy)
    var _pitch = point_direction(0, 0, _dist_xy, -dz)

    var _m_align = matrix_build(0, 0, 0, 0, -(90 - _pitch), _yaw, 1, 1, 1)
    var _m_rot = matrix_build(0, 0, 0, rx, ry, rz, 1, 1, 1)
    var _m_trans = matrix_build(cx, cy, cz, 0, 0, 0, 1, 1, 1)

    var _m_final = matrix_multiply(_m_scale, _m_align)
    _m_final = matrix_multiply(_m_final, _m_rot)
    _m_final = matrix_multiply(_m_final, _m_trans)
    _m_final = matrix_multiply(_m_final, world_mat)

    matrix_set(matrix_world, _m_final)

    vertex_submit(_vbuff, pr_trianglelist, _tex)

    matrix_set(matrix_world, matrix_build_identity())
}

function draw_cone(_cx, _cy, _cz, _wx, _wz, _wy, _rx, _ry, _rz, _steps, _tex, _world_mat = matrix_build_identity()) {
    var _vbuff = get_vbuff("cone" + string(_steps))
    if (_vbuff == -1) _vbuff = create_model_cone(_steps)

    var _m_scale = matrix_build(0, 0, 0, 0, 0, 0, _wx, _wy, _wz);
    var _m_rot = matrix_build(0, 0, 0, _rx, _ry, _rz, 1, 1, 1);
    var _m_trans = matrix_build(_cx, _cy, _cz, 0, 0, 0, 1, 1, 1);
    var _m_final = matrix_multiply(matrix_multiply(matrix_multiply(_m_scale, _m_rot), _m_trans), _world_mat);
    
    matrix_set(matrix_world, _m_final);
    vertex_submit(_vbuff, pr_trianglelist, _tex);
    matrix_set(matrix_world, matrix_build_identity());
}

function draw_face(_cx, _cy, _cz, _wx, _wy, _rx, _ry, _rz, _tex, _world_mat = matrix_build_identity()) {
    var _vbuff = get_vbuff("face")
    if (_vbuff == -1) _vbuff = create_model_face()

    // 1. 스케일 적용 (Z스케일은 평면이므로 1)
    var _m_scale = matrix_build(0, 0, 0, 0, 0, 0, _wx, _wy, 1);
    
    // 2. 회전 적용
    var _m_rot = matrix_build(0, 0, 0, _rx, _ry, _rz, 1, 1, 1);
    
    // 3. 위치 이동 적용
    var _m_trans = matrix_build(_cx, _cy, _cz, 0, 0, 0, 1, 1, 1);
    
    // 행렬 결합 순서: Scale -> Rotate -> Translate -> World
    var _m_final = matrix_multiply(_m_scale, _m_rot);
    _m_final = matrix_multiply(_m_final, _m_trans);
    _m_final = matrix_multiply(_m_final, _world_mat);
    
    matrix_set(matrix_world, _m_final);
    
    // 사각형 모델 드로우
    vertex_submit(_vbuff, pr_trianglelist, _tex);
    
    // 월드 행렬 초기화
    matrix_set(matrix_world, matrix_build_identity());
}

function create_model_cylinder(_steps) {
    var _buff = create_vbuff("cylinder" + string(_steps))

    var _cc, _ss
    for (var i = 0; i <= _steps; i++) {
        var _rad = (i * 2.0 * pi) / _steps
        _cc[i] = cos(_rad)
        _ss[i] = sin(_rad)
    }

    vertex_begin(_buff, global._vformat)

    for (var i = 0; i < _steps; i++) {
        // 옆면 (Side) - 두 개의 삼각형으로 사각형 구성
        // 하단(z=-1) p1, p2 / 상단(z=1) p3, p4
        var u1 = i/_steps; var u2 = (i+1)/_steps;
        
        // 삼각형 1
        v_add(_buff, _cc[i],   _ss[i],   -1, _cc[i],   _ss[i],   0, u1, 1)
        v_add(_buff, _cc[i+1], _ss[i+1], -1, _cc[i+1], _ss[i+1], 0, u2, 1)
        v_add(_buff, _cc[i],   _ss[i],    1, _cc[i],   _ss[i],   0, u1, 0)
        // 삼각형 2
        v_add(_buff, _cc[i+1], _ss[i+1], -1, _cc[i+1], _ss[i+1], 0, u2, 1)
        v_add(_buff, _cc[i+1], _ss[i+1],  1, _cc[i+1], _ss[i+1], 0, u2, 0)
        v_add(_buff, _cc[i],   _ss[i],    1, _cc[i],   _ss[i],   0, u1, 0)

        // 윗뚜껑 (Top Cap, z=1)
        v_add(_buff, 0, 0, 1, 0, 0, 1, 0.5, 0.5)
        v_add(_buff, _cc[i],   _ss[i],   1, 0, 0, 1, 0.5 + 0.5*_cc[i], 0.5 + 0.5*_ss[i])
        v_add(_buff, _cc[i+1], _ss[i+1], 1, 0, 0, 1, 0.5 + 0.5*_cc[i+1], 0.5 + 0.5*_ss[i+1])

        // 아랫뚜껑 (Bottom Cap, z=-1)
        v_add(_buff, 0, 0, -1, 0, 0, -1, 0.5, 0.5)
        v_add(_buff, _cc[i+1], _ss[i+1], -1, 0, 0, -1, 0.5 + 0.5*_cc[i+1], 0.5 + 0.5*_ss[i+1])
        v_add(_buff, _cc[i],   _ss[i],   -1, 0, 0, -1, 0.5 + 0.5*_cc[i], 0.5 + 0.5*_ss[i])
    }
    vertex_end(_buff)
    vertex_freeze(_buff)

    return _buff
}

function create_model_cone(_steps) {
    var _buff = create_vbuff("cone" + string(_steps))
    vertex_begin(_buff, global._vformat)

    var _h = 1.0  // 높이 가이드
    var _r = 1.0  // 반지름 가이드
    var _ang_step = 360 / _steps

    for (var i = 0; i < _steps; i++) {
        var _ang1 = i * _ang_step
        var _ang2 = (i + 1) * _ang_step

        var _x1 = lengthdir_x(_r, _ang1)
        var _y1 = lengthdir_y(_r, _ang1)
        var _x2 = lengthdir_x(_r, _ang2)
        var _y2 = lengthdir_y(_r, _ang2)

        // --- 측면 (Side Face) ---
        // 꼭짓점 (Apex)
        vertex_position_3d(_buff, 0, 0, _h)
        vertex_normal(_buff, 0, 0, 1)
        vertex_colour(_buff, c_white, 1)
        vertex_texcoord(_buff, 0.5, 0)

        // 하단 외곽점 2
        vertex_position_3d(_buff, _x2, _y2, 0)
        vertex_normal(_buff, _x2 / _r, _y2 / _r, 0.5)
        vertex_colour(_buff, c_white, 1)
        vertex_texcoord(_buff, (i + 1) / _steps, 1)

        // 하단 외곽점 1
        vertex_position_3d(_buff, _x1, _y1, 0)
        vertex_normal(_buff, _x1 / _r, _y1 / _r, 0.5)
        vertex_colour(_buff, c_white, 1)
        vertex_texcoord(_buff, i / _steps, 1)

        // --- 바닥면 (Base Cap) ---
        // 바닥 중심
        vertex_position_3d(_buff, 0, 0, 0)
        vertex_normal(_buff, 0, 0, -1)
        vertex_colour(_buff, c_white, 1)
        vertex_texcoord(_buff, 0.5, 0.5)

        // 바닥 외곽점 1
        vertex_position_3d(_buff, _x1, _y1, 0)
        vertex_normal(_buff, 0, 0, -1)
        vertex_colour(_buff, c_white, 1)
        vertex_texcoord(_buff, 0.5 + _x1 / (2 * _r), 0.5 + _y1 / (2 * _r))

        // 바닥 외곽점 2
        vertex_position_3d(_buff, _x2, _y2, 0)
        vertex_normal(_buff, 0, 0, -1)
        vertex_colour(_buff, c_white, 1)
        vertex_texcoord(_buff, 0.5 + _x2 / (2 * _r), 0.5 + _y2 / (2 * _r))
    }

    vertex_end(_buff)
    vertex_freeze(_buff)

    return _buff
}

function create_model_face() {
    var _buff = create_vbuff("face")
    vertex_begin(_buff, global._vformat)
    
    v_add(_buff, -0.5, -0.5, 0,  0, 0, -1,  0, 0)
    v_add(_buff,  0.5, -0.5, 0,  0, 0, -1,  1, 0)
    v_add(_buff,  0.5,  0.5, 0,  0, 0, -1,  1, 1)
    
    v_add(_buff, -0.5, -0.5, 0,  0, 0, -1,  0, 0)
    v_add(_buff,  0.5,  0.5, 0,  0, 0, -1,  1, 1)
    v_add(_buff, -0.5,  0.5, 0,  0, 0, -1,  0, 1)
    
    vertex_end(_buff)
    vertex_freeze(_buff)

    return _buff
}