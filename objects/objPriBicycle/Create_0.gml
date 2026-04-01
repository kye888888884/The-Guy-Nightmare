on_move = false
spin = 0

function draw_front() {
    draw_sprite_ext(sprPriBicyclePedal, 0, x, y, 1, 1, -spin, c_white, 1)
    draw_sprite_ext(sprPriBicycleWheel, 0, x - 33, y + 7, 1, 1, -spin * 4 + 70, c_white, 1)
    draw_sprite_ext(sprPriBicycleWheel, 0, x + 45, y - 1, 1, 1, -spin * 4, c_white, 1)
    draw_self()
}

function draw_back() {
    draw_front()
}

function restart() {
    on_move = false
    x = xstart
    y = ystart
}