/// 

var _scale = shot_power
if (mouse_check_button(mb_left) and shot_power > 0)
    draw_sprite_ext(spr01GolfPower, frozen ? 1 : 0, x + draw_x, y + draw_y, _scale, _scale, 0, c_white, 1)