event_inherited()

sprite_index = sprPriBlock

function draw_front() {
	image_blend = PRI_FRONT_COLOR
	draw_self()
}

function draw_back() {
	image_blend = PRI_BACK_COLOR
	draw_self()
}

function fixture() { // override this
	return fixture_create_box(32 * image_xscale, 32 * image_yscale, 0, 0, 1, 1, 1)
}