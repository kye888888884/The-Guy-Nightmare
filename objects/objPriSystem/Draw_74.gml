bloom_shader.set_intensity(0.25)
    .draw(application_surface)

draw_option.set()
draw_text_outline("Chunk: " + string(global.current_chunk), 10, 10, c_white, c_black, 1, 1)
draw_text_outline("Pos: " + global.player_pos.str(), 10, 50, c_white, c_black, 1, 1)
// with (objPriCurveMap) debug()
draw_option.reset()