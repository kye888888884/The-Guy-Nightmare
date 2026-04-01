/// @description Initialize variables

FLOOR_MAX_ANGLE = 50

frozen = false; // Sets if the player can move or not

max_jump_count = 2
jump = 8 * global.grav; // Sets how fast the player jumps
jump2 = 6.8 * global.grav; // Sets how fast the player double jumps
gravity = 0.4 * global.grav; // Sets the player's gravity
size = 1

can_first_jump = false;
rest_jump = 2; // Allow the player to double jump as soon as he spawns
maxHSpeed = 3; // Max horizontal speed
maxVSpeed = 9; // Max vertical speed
onPlatform = false; // Sets if the player is currently standing on a platform
on_floor = false
on_wall = false
on_sliding = false
move_hspeed = 0
gun_index = 5

on_block = false;

current_move = 0;

fix = noone
alarm[0] = 1

col_normal = new Vec2(0, 1)

// Create the player's bow if on medium mode
if (global.difficulty == 0 && global.gameStarted) {
    instance_create_depth(x,y,depth-1,objBow);
}
if (!instance_exists(objCape))
    instance_create(objCape, x, y)

// Save the game if currently set to autosave
if (global.autosave) {
    scrSaveGame(true);
    global.autosave = false;
}

function draw() {
	with (objCape) { _draw() }
	
	var _gun_y = y
    if (sprite_index == sprPlayerJump)
        _gun_y -= 4 * size
    else if (sprite_index == sprPlayerFall)
        _gun_y += 2 * size
    draw_sprite_ext(sprGun, gun_index, x + 14 * image_xscale * size, _gun_y, image_xscale, global.grav, 0, image_blend, image_alpha)
    gun_index = min(5, gun_index + 1)

    draw_sprite_ext(sprite_index,image_index,x,y,image_xscale*size,image_yscale*global.grav,image_angle,image_blend,image_alpha)
}

function is_on_wall() {
    var _d = col_normal.dir()
    return place_meeting(x, y + 1, objBlock) and _d < 0.7 // 45 degree slope limit
}

function fix_move(_x, _y) {
    phy_position_x = _x
    phy_position_y = _y
    phy_speed_x = 0
    phy_speed_y = 0
}

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
        gun_index = 0
	    instance_create(objBullet,x + image_xscale * 25 * size,y-(global.grav*6),size,size,image_xscale * 16, 0)
	    audio_play_sound(sndShoot,0,false)
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
