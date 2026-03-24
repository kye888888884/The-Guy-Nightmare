step()

if (active) {
	if (place_meeting(x, y, objPlayer)) {
		with (objPlayer) { scrKillPlayer() }
	}
}