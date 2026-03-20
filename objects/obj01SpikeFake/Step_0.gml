/// 

if (disappear) {
    image_alpha -= 0.02
    if (image_alpha <= 0) instance_destroy()
}

if (place_meeting(x, y, objPlayer)) {
	audio_play_sound(sndBlockChange, 0, false)
	instance_destroy()
}

with (objBullet) {
	if (collision_rectangle(x, y - 2, x + hspeed, y + 2, other, true, true)) {
		with (other) {
			audio_play_sound(sndDeath, 0, false)
			instance_destroy()
		}
		instance_destroy()
	}
}