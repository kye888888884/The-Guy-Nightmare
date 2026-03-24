bound = false
fix = -1

alarm[0] = 1

function fixture() { // override this
	return fixture_create_box(32 * image_xscale, 32 * image_yscale, 0, 0.5, 1, 1, 1)
}