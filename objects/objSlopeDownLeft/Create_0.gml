event_inherited()

function fixture() {
	return fixture_create_polygon(
        [
            vec2(0, 0), 
            vec2(32 * image_xscale, 32 * image_yscale), 
            vec2(0, 32 * image_yscale)
        ],
        0, 1, 1, 1, 1
    )
}