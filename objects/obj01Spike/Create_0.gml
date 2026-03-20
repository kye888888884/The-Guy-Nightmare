image_speed = 0
trg = 0
bind_to = -1
alarm[0] = 1
disappear = false
depth = 110

function init(dir) {
	if (dir == UP) {
		image_index = 2
	}
	else if (dir == DOWN) {
		image_index = 1
		image_yscale = -1
	}
	else if (dir == LEFT) {
		image_xscale = -1
		image_angle = 90
	}
	else if (dir == RIGHT) {
		image_xscale = -1
		image_yscale = -1
		image_angle = 90
	}
}

function bind_to_block(_trg) {
	with (obj01BlockTrigger) {
		if (trg == _trg) {
			add(other)
		}
	}
	with (obj01BlockMoving) {
		if (trg == _trg) {
			add(other)
		}
	}
	with (obj01BlockMovingAngular) {
		if (trg == _trg) {
			add(other)
		}
	}
}

function trigger(_trg) {
    if (_trg == trg) {
        return true
    } else
        return false
}