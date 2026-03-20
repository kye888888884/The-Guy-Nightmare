function fixture_create_box(_w, _h, _dense = 1.0, _res = 0.5, _fric = 0.5, _ldamp = 0, _adamp = 0) {
    var _fix = physics_fixture_create()
    physics_fixture_set_box_shape(_fix, _w / 2, _h / 2)
    physics_fixture_set_density(_fix, _dense)
    physics_fixture_set_restitution(_fix, _res)
    physics_fixture_set_friction(_fix, _fric)
    physics_fixture_set_linear_damping(_fix, _ldamp)
    physics_fixture_set_angular_damping(_fix, _adamp)
    return _fix
}

function fixture_create_circle(_r, _dense = 1.0, _res = 0.5, _fric = 0.5, _ldamp = 0, _adamp = 0) {
    var _fix = physics_fixture_create()
    physics_fixture_set_circle_shape(_fix, _r)
    physics_fixture_set_density(_fix, _dense)
    physics_fixture_set_restitution(_fix, _res)
    physics_fixture_set_friction(_fix, _fric)
    physics_fixture_set_linear_damping(_fix, _ldamp)
    physics_fixture_set_angular_damping(_fix, _adamp)
    return _fix
}

function fixture_create_polygon(_arr_vec2, _dense = 1.0, _res = 0.5, _fric = 0.5, _ldamp = 0, _adamp = 0, _delete_vec2 = true) {
    var _fix = physics_fixture_create()
    physics_fixture_set_polygon_shape(_fix)

    for (var i = 0; i < array_length(_arr_vec2); i++) {
        physics_fixture_add_point(_fix, _arr_vec2[i].x, _arr_vec2[i].y)
        if (_delete_vec2)
            _arr_vec2[i].free()
    }

    physics_fixture_set_density(_fix, _dense)
    physics_fixture_set_restitution(_fix, _res)
    physics_fixture_set_friction(_fix, _fric)
    physics_fixture_set_linear_damping(_fix, _ldamp)
    physics_fixture_set_angular_damping(_fix, _adamp)
    return _fix
}

function fixture_bind(_fix, _id = id) {
    var _bind = physics_fixture_bind(_fix, _id)
    physics_fixture_delete(_fix)
    return _bind
}

function coord_on_physics(_phy = false, _grav = true) {
    if (_grav)
        vspeed += gravity
    
    if (_phy) {
        phy_position_x += hspeed
        phy_position_y += vspeed
    }
    x += hspeed
    y += vspeed
}