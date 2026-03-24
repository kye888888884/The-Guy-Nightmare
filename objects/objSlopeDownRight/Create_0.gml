event_inherited()

function fixture() {
	return fixture_create_polygon(
        [
            new Vec2(32 * image_xscale, 0), 
            new Vec2(32 * image_xscale, 32 * image_yscale), 
            new Vec2(0, 32 * image_yscale)
        ],
        0, 1, 1, 1, 1
    )
}