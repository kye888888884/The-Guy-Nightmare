on_handle = false
handle_delay = 0
handle_angle = 0
image_index = 1
type = 0

function draw() {
    draw_self()
    draw_sprite_ext(sprite_index, 2, x, y, 1, 1, handle_angle, c_white, 1)
}