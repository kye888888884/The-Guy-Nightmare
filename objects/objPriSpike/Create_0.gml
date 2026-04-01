function draw_front() {
	if (visible) {
		_draw_front()
	}
}

function draw_back() {
	if (visible) {
		_draw_back()
	}
}

function _draw_front() {
	image_index = 1
	draw_self()
}

function _draw_back() {
	image_index = 0
	draw_self()
}