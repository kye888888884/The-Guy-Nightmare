if (place_meeting(x, y, objPlayer)) {
	with (objPlayer) { scrKillPlayer() }
}

function draw_front() {
	image_index = 1
	draw_self()
}

function draw_back() {
	image_index = 0
	draw_self()
}