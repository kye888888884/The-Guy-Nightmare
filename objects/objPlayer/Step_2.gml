/// @description Handle player collision

// Check killer collision
if (place_meeting(x,y,objPlayerKiller)) {
	scrKillPlayer();
}

// Check in block
if (position_meeting(x, y, objBlock)) {
	// scrKillPlayer();
}

// Check if player left the room and update player sprite (if set to)
if ((x < 0 || x > room_width || y < 0 || y > room_height) && global.edgeDeath) {
    scrKillPlayer();
}

// Update player sprite
if (PLAYER_ANIMATION_FIX) {
	// Block/vine checks
	var notOnBlock = (place_free(x,y+(global.grav)));
	var onVineR = (place_meeting(x+1,y,objWalljumpR) && notOnBlock);
	var onVineL = (place_meeting(x-1,y,objWalljumpL) && notOnBlock);
	
	if (!onVineR && !onVineL) { // Not touching any vines
		if (onPlatform || !notOnBlock) { // Standing on something
			// Check if moving left/right
			var L = (scrButtonCheck(global.leftButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.leftButton)));
			var R = (scrButtonCheck(global.rightButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.rightButton)));
			
			if ((L || R) && !frozen) {
				sprite_index = sprPlayerRun;
				image_speed = 0.5;
			} else {
				sprite_index = sprPlayerIdle;
				image_speed = 0.2;
			}
		} else { // In the air
			if ((vspeed * global.grav) < 0) {
				sprite_index = sprPlayerJump;
				image_speed = 0.5;
			} else {
				sprite_index = sprPlayerFall;
				image_speed = 0.5;
			}
		}
	} else { // Touching a vine
		sprite_index = sprPlayerSlide;
		image_speed = 0.5;
	}
}