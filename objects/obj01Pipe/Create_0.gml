plant = false
changed = false
disappear = false

plate = -1
new_index = 0
new_plate = -1

on_rotate = false
rot_t = 0
cx = x
cy = y
sx = x
sy = y
sdir = 0

depth = 120

function change_to_plant() {
	if (!changed) {
		changed = true
		alarm[0] = 10
		instance_create(obj01PipePlant, x, y, 1, image_yscale)
		disappear = true
	}
}

function rotate_init(_cx, _cy, _new_plate) {
	if (plate != -1) {
		cx = _cx
		cy = _cy
		sx = x
		sy = y
		on_rotate = true
		new_index = image_index
		new_plate = _new_plate
		if (new_index == 4) new_index = 7
		else if (new_index == 7) new_index = 4
		else if (new_index == 5) new_index = 6
		else if (new_index == 6) new_index = 5
	}
}