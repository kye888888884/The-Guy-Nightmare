/// 

#macro RIGHT 1
#macro UP 2
#macro DOWN 3
#macro LEFT 4

#macro CAMMODE_SNAP 0
#macro CAMMODE_FOLLOW 1
#macro CAMMODE_AREA 2

#macro EF_RING sprEffectRing
#macro EF_TRINKLE sprEffectTrinkle

function get_time() {
    return current_time / 1000
}

function instance_create(_obj, _x, _y, _xs = 1, _ys = 1, _hspd = 0, _vspd = 0, _angle = 0, _blend = c_white, _depth = depth) {
    var _inst = instance_create_depth(_x, _y, _depth, _obj)
    with (_inst) {
        image_xscale = _xs
        image_yscale = _ys
        hspeed = _hspd
        vspeed = _vspd
        image_angle = _angle
        image_blend = _blend
    }
    return _inst
}

function dir_to_hv(_spd, _dir) {
    return {x: lengthdir_x(_spd, _dir), y: lengthdir_y(_spd, _dir)}
}

function effect_create(_spr, _idx, _x, _y, _depth = depth, _xs = 1, _ys = 1, _hspd = 0, _vspd = 0, _angle = 0) {
    var _inst = instance_create(objEffectBasic, _x, _y, _xs, _ys, _hspd, _vspd, _angle)
    _inst.depth = _depth
    with (_inst) {
        sprite_index = _spr
        image_index = _idx
        image_angle = _angle
    }
    return _inst
}

function particle_emit(_p, _x, _y, _n) {
    part_emitter_region(_p.s, _p.e, _x, _x, _y, _y, ps_shape_ellipse, ps_distr_linear);
    part_emitter_burst(_p.s, _p.e, _p.t, _n)
}

function particle_delete(_p) {
    part_emitter_destroy(_p.s, _p.e)
    part_type_destroy(_p.t)
    part_system_destroy(_p.s)
}

function shader_set_uniform(_shader, _name, _value) {
    var _loc = shader_get_uniform(_shader, _name)
    if (_loc != -1) {
        if (is_real(_value)) {
            shader_set_uniform_f(_loc, _value)
        }
        else if (is_array(_value)) {
            switch (array_length(_value)) {
                case 2: shader_set_uniform_f(_loc, _value[0], _value[1]); break
                case 3: shader_set_uniform_f(_loc, _value[0], _value[1], _value[2]); break
                case 4: shader_set_uniform_f(_loc, _value[0], _value[1], _value[2], _value[3]); break
            }
        }
    }
}

function shader_set_texture(_shader, _name, _texture) {
    var _loc = shader_get_sampler_index(_shader, _name)
    if (_loc != -1) {
        texture_set_stage(_loc, _texture)
    }
}

function curve_value(_curve, _channel, _t) {
    var _c = animcurve_get_channel(_curve, _channel)
    if (_c != -1) {
        return animcurve_channel_evaluate(_c, _t)
    }
    else
        return 0
}

function get_bezier(_t, _x1, _y1, _x2, _y2, _x3, _y3, _x4 = noone, _y4 = noone, _x5 = noone, _y5 = noone) {
    var _rx = 0;
    var _ry = 0;
    var _it = 1 - _t;

    // 5개의 점 (4차 베지어)
    if (_x5 != noone && _y5 != noone) {
        var _it2 = _it * _it;
        var _it3 = _it2 * _it;
        var _it4 = _it3 * _it;
        var _t2 = _t * _t;
        var _t3 = _t2 * _t;
        var _t4 = _t3 * _t;
        
        _rx = _it4 * _x1 + 4 * _it3 * _t * _x2 + 6 * _it2 * _t2 * _x3 + 4 * _it * _t3 * _x4 + _t4 * _x5;
        _ry = _it4 * _y1 + 4 * _it3 * _t * _y2 + 6 * _it2 * _t2 * _y3 + 4 * _it * _t3 * _y4 + _t4 * _y5;
    }
    // 4개의 점 (3차 베지어)
    else if (_x4 != noone && _y4 != noone) {
        var _it2 = _it * _it;
        var _it3 = _it2 * _it;
        var _t2 = _t * _t;
        var _t3 = _t2 * _t;
        
        _rx = _it3 * _x1 + 3 * _it2 * _t * _x2 + 3 * _it * _t2 * _x3 + _t3 * _x4;
        _ry = _it3 * _y1 + 3 * _it2 * _t * _y2 + 3 * _it * _t2 * _y3 + _t3 * _y4;
    }
    // 3개의 점 (2차 베지어)
    else {
        var _it2 = _it * _it;
        var _t2 = _t * _t;
        
        _rx = _it2 * _x1 + 2 * _it * _t * _x2 + _t2 * _x3;
        _ry = _it2 * _y1 + 2 * _it * _t * _y2 + _t2 * _y3;
    }

    return { x: _rx, y: _ry };
}

function move_contact(obj, dir, max_dis, unit = 1, ox = 0, oy = 0, move = true) {
    if (place_meeting(x + ox, y + oy, obj)) return 0
    if (unit <= 0) return -1

    var _dis = unit
    var _prev_x = x + ox
    var _prev_y = y + oy
    while (true) {
        var _x = x + ox + lengthdir_x(_dis, dir)
        var _y = y + oy + lengthdir_y(_dis, dir)
        if (place_meeting(_x, _y, obj)) {
            if (move) {
                x = _prev_x
                y = _prev_y
            }
            return _dis
        }
        else {
            _prev_x = _x
            _prev_y = _y
            _dis += unit
            if (_dis > max_dis) return -1
        }
    }
}

function move_outside(obj, dir, max_dis, unit = 1, ox = 0, oy = 0, move = true) {
    if (!place_meeting(x + ox, y + oy, obj)) return 0
    if (unit <= 0) return -1

    var _dis = unit
    var _prev_x = x + ox
    var _prev_y = y + oy
    while (true) {
        var _x = x + ox + lengthdir_x(_dis, dir)
        var _y = y + oy + lengthdir_y(_dis, dir)
        if (!place_meeting(_x, _y, obj)) {
            if (move) {
                x = _x
                y = _y
            }
            return _dis
        }
        else {
            _prev_x = _x
            _prev_y = _y
            _dis += unit
            if (_dis > max_dis) return -1
        }
    }
}

function is_in_camera(margin = 0, ox = 0, oy = 0) {
    return (
        x + ox > global.cam_x - margin
        and x + ox < global.cam_x + global.cam_w + margin 
        and y + oy > global.cam_y - margin 
        and y + oy < global.cam_y + global.cam_h + margin
    )
}

function cam() {
    var _id = -1
    if (instance_exists(objCamera)) {
        with (objCamera) {
            _id = id
        }
    }
    return _id
}

function vec2(_x, _y) {
    return instance_create(_vec2, _x, _y)
}