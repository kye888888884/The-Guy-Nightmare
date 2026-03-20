depth = floor(y / 16) - 100

if (place_meeting(x, y + phy_speed_y + 1, obj01PhysicsBlock)) {
    phy_speed_y *= 0.8
}

if (size < 3) {
    with (ins_mask) {
        instance_place_list(x + other.phy_speed_x, y + other.phy_speed_y + 1, obj01MelonGameObjectMask, other.meet_list, false)
    }
    for (var i = 0; i < ds_list_size(meet_list); i++) {
        var _obj = ds_list_find_value(meet_list, i).anchor
        if (_obj != noone) {
            if (id > _obj.id and size == _obj.size and image_index == _obj.image_index) {
                if (!size_change and !_obj.size_change) {
                    ready = false
                    var _ins = instance_create(obj01MelonGameMoving, x, y)
                    _ins.sprite_index = sprite_index
                    _ins.image_index = image_index
                    _ins.image_angle = image_angle
                    _ins.start_angle = image_angle
                    _ins.target = _obj.id
                    _ins.size = size
                    _ins.depth = depth - 50
                    with (_ins) { ready = false }
                    instance_destroy()
                    break
                }
            }
        }
    }
    ds_list_clear(meet_list)
}

if (ready and size_change) {
    var _pre_size = _sizes[size - 1]
    var _cur_size = _sizes[size]
    
    size_t = min(1, size_t + 0.1)
    var _scale = lerp(_pre_size / _cur_size, 1, size_t)
    var _s = lerp(_pre_size / 96, _cur_size / 96, size_t)

    physics_remove_fixture(id, fix_id)
    var _fix = get_fixture(_s)
    fix_id = physics_fixture_bind(_fix, id)
    physics_fixture_delete(_fix)

    mask_scale = lerp(_pre_size / 96, _cur_size / 96, size_t)
    
    image_xscale = _scale
    image_yscale = _scale

    if (size_t == 1) {
        ready = true
        size_change = false
        size_t = 0
    }
}