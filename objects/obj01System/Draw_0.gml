if (instance_exists(objPlayer)) {
    for (var _h = -1; _h <= 1; _h += 2) {
        for (var _v = -1; _v <= 1; _v += 2) {
            with (obj01PlayerOnPipe) {
                with (objPlayer) {
                    x = other.x
                    y = other.y
                }
            }
            _x = objPlayer.x - 17 + _h
            _y = objPlayer.y - 22 + _v
            draw_surface_ext(surf_player, _x, _y, 1, 1, 0, make_color_rgb(40, 120, 40), 1)
        }
    }
}
with (objPlayer) { if (visible) draw() }
with (obj01PlayerOnPipe) { draw_self() }
with (obj01Handle) {
    if (on_handle)
        draw_player(x, y)
}

draw_surface(surf_fore, get_x(), global.cam_anchor_y)

gpu_set_blendmode(bm_add)
draw_surface(surf_light, get_x(), global.cam_anchor_y)
gpu_set_blendmode(bm_normal)