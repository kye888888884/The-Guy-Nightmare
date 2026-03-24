event_inherited()

sprite_index = sprPriSlopeDig
image_index = 0

function fixture() {
	return fixture_create_polygon(
        [
            new Vec2(0, 0.2), 
            new Vec2(32 * image_xscale, 32 * image_yscale), 
            new Vec2(0, 32 * image_yscale)
        ],
        0, 0, 1, 1, 1
    )
}

function draw_front() {
	image_blend = PRI_FRONT_COLOR
	draw_self()
}

function draw_back() {
	image_blend = PRI_BACK_COLOR
	draw_self()
}