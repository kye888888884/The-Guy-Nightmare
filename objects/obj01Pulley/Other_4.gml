for (var i = 0; i < 19; i++) {
	if (!place_meeting(x, y - i * 32, objBlock)) {
		up_empty = i + 1
	}
	else {
		break
	}
}

with (obj01BlockPulley) {
	if (index == other.left_index) {
		other.left = self
		pulley = other
		is_left = true
	}
	else if (index == other.right_index) {
		other.right = self
		pulley = other
	}
}