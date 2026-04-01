bloom_shader.set_intensity(0.25)
    .draw(application_surface)

draw_option.set()
draw_text_outline("Chunk: " + string(global.current_chunk), 10, 10)
draw_text_outline("Pos: " + global.player_pos.str(), 10, 50)
draw_text_outline("Num: " + string(instance_number(objPriSpikeFollowCurve)), 10, 90)
var _active_num = 0
with (objPriSpikeFollowCurve) {
    if (active) _active_num++
}
draw_text_outline("Active: " + string(_active_num), 10, 130)
with (objPriCurveMap) debug()
draw_option.reset()