with (objPlayer) {
	if (place_meeting(x + hspeed, y + vspeed, other)) {
		audio_stop_sound(sndBlockChange)
		audio_play_sound(sndBlockChange, 0, false)
		with (other) instance_destroy()
	}
}