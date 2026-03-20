var _fix = fixture_create_circle(12, 1.0, 0.3, 1.0, 0.3, 5.0)
physics_fixture_bind(_fix, self)
physics_fixture_delete(_fix)

dx = 0
dy = 0

shot_power = 0
shot_count = 0
shot_t = 0
shot = false

ball_visible = true

draw_x = 0
draw_y = 0

frozen = false
frozen_t = 0

start_mx = mouse_x
start_my = mouse_y

arr_pos = []

window_set_cursor(cr_none)