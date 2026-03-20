var _hspd = hspeed
var _vspd = vspeed

coord_on_physics()

if (image_xscale == 1) {
    draw_sprite(sprite_index, 0, x, y)
}
else {
    for (var i = 0; i < image_xscale; i++) {
        var _x = (i + 0.5 - image_xscale / 2) * 32
        var _index = 2
        if (i == 0) _index = 1
        else if (i == image_xscale - 1) _index = 3
        draw_sprite_ext(sprite_index, _index, x + _x, y, 1, 1, image_angle, image_blend, image_alpha)
    }
}

for (var i = 0; i < ds_list_size(objects); i++) {
    var obj = objects[| i]
    var _dis = point_distance(0, 0, obj.xgap, obj.ygap)
    var _dir = point_direction(0, 0, obj.xgap, obj.ygap)
    var _x = lengthdir_x(_dis, _dir + image_angle)
    var _y = lengthdir_y(_dis, _dir + image_angle)
    obj.id.x = x + _x
    obj.id.y = y + _y
    obj.id.image_angle = image_angle + obj.anglegap
}

with (objPlayer) {
    var _oy = vspeed + max(0, _vspd) + 1
    if (other.y > y and place_meeting(x, y + _oy, other)) {
        x += _hspd
        with (other) { player_on() }
        if (_vspd > 0) {
            move_contact(other, 270, abs(_vspd) + 2, 0.1)
        }
        else {
            move_outside(other, 90, abs(_vspd) + 2, 0.1)
        }
    }

    if (other.y < y and place_meeting(x, y - _vspd - 1, other)) {
        if (_vspd > 0) {
            move_outside(other, 270, abs(vspeed) + _vspd + 2, 0.1)
            vspeed = max(vspeed, _vspd)
        }
    }
}

if (place_meeting(x, y + vspeed, objBlock)
    or (pulley != noone and vspeed < 0 and y <= pulley.y + 16)) {
    stop()
}