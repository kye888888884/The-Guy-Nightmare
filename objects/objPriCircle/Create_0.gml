t = 0

move_dir = 0
move_speed = 0.1
move_len = 64
move_delay = 0
move_shake = 0
move_add_angle = 180
move_index = 0
shake_offset = random(360)
move_t = 0
prev_x = x
prev_y = y
moves = []

s_dir = 0
s_spd = 0
s_delay = 0
s_add_angle = 0
s_index = 0
s_t = 0

function init(_dir, _spd, _delay, _add_angle = 180, _len = 64, _t = 0) {
	s_dir = _dir
	s_spd = _spd
	s_delay = _delay
	s_add_angle = _add_angle
	s_t = _t
	move_dir = _dir
	move_speed = _spd
	move_delay = _delay
	move_add_angle = _add_angle
	move_len = _len
	image_angle = move_dir
	t = _t
	for (var _ang = 0; _ang < 360; _ang += _add_angle) {
		array_push(moves, make_move(_ang, move_len))
	}
}

function make_move(_dir, _len) {
	return {dir: _dir, len: _len}
}

function restart() {
	move_dir = s_dir
	move_speed = s_spd
	move_delay = s_delay
	move_add_angle = s_add_angle
	image_angle = move_dir
	move_t = 0
	move_shake = 0
	t = s_t
	x = xstart
	y = ystart
	prev_x = x
	prev_y = y
	image_xscale = 1
	image_yscale = 1
}

function draw() {
	var _x = x + lengthdir_x(move_shake * sin(get_time() * 55), 90 + image_angle)
	var _y = y + lengthdir_y(move_shake * sin(get_time() * 55), 90 + image_angle)
	draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
}

function draw_front() {
	image_blend = PRI_FRONT_COLOR
	draw()
}

function draw_back() {
	image_blend = PRI_BACK_COLOR
	draw()
}