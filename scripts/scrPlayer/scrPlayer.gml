/// @function scrPlayerJump()
/// @description Makes the player jump
function scrPlayerJump() {
	if (global.infJump || global.debugInfJump) {
		rest_jump = max(1, rest_jump)
	}
	if (rest_jump > 0) {
		if (on_floor) {
			// Single jump
			phy_speed_y = -jump
			audio_play_sound(sndJump,0,false)
		}
		else {
			// Double jump
			phy_speed_y = -jump2
			sprite_index = sprPlayerJump
			audio_play_sound(sndDJump,0,false)
		}
		rest_jump -= 1
	}
}

/// @function scrPlayerVJump()
/// @description Makes the player lose upward vertical momentum
function scrPlayerVJump() {

	if (phy_speed_y * global.grav < 0) {
	    phy_speed_y *= 0.45;
	}
}

/// @function scrPlayerShoot()
/// @description Makes the player shoot a bullet
function scrPlayerShoot() {

	if (instance_number(objBullet) < 4) {
	    instance_create_layer(x,y-(global.grav*2),layer,objBullet);
	    audio_play_sound(sndShoot,0,false);
	}
}

/// @function scrFlipGrav()
/// @description Flips the current gravity
function scrFlipGrav() {

	// Set gravity to go the opposite direction
	global.grav = -global.grav;

	// Flip the player and set his variables accordingly
	with (objPlayer) {
		vspeed = 0;
		djump = 1;
	
		jump = abs(jump) * global.grav;
		jump2 = abs(jump2) * global.grav;
		gravity = abs(gravity) * global.grav;
	
		y += 4 * global.grav;
	}
}

/// @function scrKillPlayer()
/// @description Kills the player
function scrKillPlayer() {

	if (instance_exists(objPlayer) && (!global.noDeath && !global.debugNoDeath)) {
	    if (global.gameStarted) {
	        // Normal death
		
			global.deathSound = audio_play_sound(sndDeath,0,false);
        
			// Play death music
	        if (!global.muteMusic) {
	            if (global.deathMusicMode == 1) { // Instantly pause the current music
	                audio_pause_sound(global.currentMusic);
                
	                global.gameOverMusic = audio_play_sound(musOnDeath,1,false);
	            } else if (global.deathMusicMode == 2) { // Fade out the current music
	                with (objWorld) {
	                    event_user(0); // Fade out and stop the current music
					}
                
	                global.gameOverMusic = audio_play_sound(musOnDeath,1,false);
	            }
	        }
        
	        with (objPlayer) {
	            instance_create_layer(x,y,layer,objBloodEmitter);
	            instance_destroy();
	        }

			with (obj01PlayerOnPipe) instance_destroy()
        
	        instance_create_layer(0,0,"World",objGameOver);
        
	        global.deaths++; // Increment death counter
            
	        scrSaveGame(false); // Save deaths/time
	    } else {
	        // Death in the difficulty select room, restart the room
		
			with (objPlayer) {
	            instance_destroy();
			}
            
	        room_restart();
	    }
	}
}
