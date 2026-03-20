t = 0
target = noone

start_angle = 0
lx = random(1)
ly = random(1)
size = 0
_sizes = [30, 45, 64, 96]

pt = noone 

alarm[0] = 1

colors = [make_color_rgb(66, 193, 14), make_color_rgb(255, 192, 0), make_color_rgb(250, 140, 58), make_color_rgb(226, 81, 98), 0]

function particle_create(_s) {
    //ParticleSystem1
    var _ps = part_system_create();
    part_system_draw_order(_ps, true);
    part_system_depth(_ps, depth + 1);

    var _scale = _sizes[_s] / 96

    //GM_Warp_Center
    var _ptype1 = part_type_create();
    part_type_sprite(_ptype1, spr01MelonGameObjectsEffect, false, true, false)
    part_type_subimage(_ptype1, image_index)
    part_type_size(_ptype1, 1, 1, -0.06 * _scale, 0);
    part_type_scale(_ptype1, _scale * 3, _scale * 3);
    part_type_speed(_ptype1, 0, 0, 0, 0);
    part_type_direction(_ptype1, 0, 360, 0, 0);
    part_type_gravity(_ptype1, 0, 270);
    part_type_orientation(_ptype1, 0, 0, 0, 0, false);
    part_type_colour3(_ptype1, colors[_s], merge_color(colors[_s], c_white, 0.05), colors[_s]);
    part_type_alpha3(_ptype1, 3/255, 0.2, 20/255);
    part_type_blend(_ptype1, true);
    part_type_life(_ptype1, 50, 50);

    var _pemit1 = part_emitter_create(_ps);

    part_system_position(_ps, 0, 0);

    return {s: _ps, t: _ptype1, e: _pemit1}
}