/// @description Handle player movement

// Check left/right button presses
// var L = (scrButtonCheck(global.leftButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.leftButton)));
// var R = (scrButtonCheck(global.rightButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.rightButton)));
var L = scrButtonCheck(global.leftButton)
var R = scrButtonCheck(global.rightButton)
var L_pressed = scrButtonCheckPressed(global.leftButton)
var R_pressed = scrButtonCheckPressed(global.rightButton)

if (!frozen) { // Don't move if frozen
    if (L_pressed) current_move = -1
    else if (R_pressed) current_move = 1

    if (L and !R) current_move = -1
    else if (!L and R) current_move = 1
    else if (!L and !R) current_move = 0
}
else {
    current_move = 0
}

var h = current_move

// Check if on a slip block
var slipBlockTouching = instance_place(x,y+(global.grav),objSlipBlock);

// Vine checks
var notOnBlock = (place_free(x,y+(global.grav)));
if (on_block) notOnBlock = false;
var onVineR = (place_meeting(x+1,y,objWalljumpR) && notOnBlock);
var onVineL = (place_meeting(x-1,y,objWalljumpL) && notOnBlock);

if (h != 0) { // Player is moving
	if (!onVineR && !onVineL) { // Make sure we're not currently on a vine
		xScale = h; // Set the direction the player is facing
	}
	
	if ((h == -1 && !onVineR) || (h == 1 && !onVineL)) { // Make sure we're not moving off a vine (that's handled later)
	    if (slipBlockTouching == noone) { // Not touching a slip block, move immediately at full speed
	        hspeed = maxHSpeed * h;
	    } else { // Touching a slip block, use acceleration
			hspeed += (slipBlockTouching.slip) * h;
		
			if (abs(hspeed) > maxHSpeed) {
				hspeed = maxHSpeed * h;
			}
	    }
	}
	
    sprite_index = sprPlayerRun;
	image_speed = 0.5;
} else { // Player is not moving
    if (slipBlockTouching == noone) { // Not touching a slip block, stop immediately
        hspeed = 0;
    } else { // Touching a slip block, slow down
        if (hspeed > 0) {
            hspeed -= slipBlockTouching.slip;
            
            if (hspeed <= 0) {
                hspeed = 0;
			}
        } else if (hspeed < 0) {
            hspeed += slipBlockTouching.slip;
            
            if (hspeed >= 0) {
                hspeed = 0;
			}
        }
    }
  
    sprite_index = sprPlayerIdle;
	image_speed = 0.2;
}

// Check if standing on a platform
if (!onPlatform) {
    if ((vspeed * global.grav) < -0.5) {
		sprite_index = sprPlayerJump;
    } else if ((vspeed * global.grav) > 0.5) {
		sprite_index = sprPlayerFall;
	}
} else {
    if (!place_meeting(x,y+(4*global.grav),objPlatform)) {
		onPlatform = false;
	}
}

// Check if on a slide block
var slideBlockTouching = instance_place(x,y+(global.grav),objSlideBlock);

if (slideBlockTouching != noone) { // On a slide block, start moving with it
    hspeed += slideBlockTouching.slide;
}

// Check if moving faster vertically than max speed
if (abs(vspeed) > maxVSpeed) {
	vspeed = sign(vspeed) * maxVSpeed;
}

// A/D align
if (global.adAlign && place_meeting(x,y+(global.grav),objBlock) && !frozen) {
    if (scrButtonCheckPressed(global.alignLeftButton)) {
		hspeed -= 1;
	}
    if (scrButtonCheckPressed(global.alignRightButton)) {
		hspeed += 1;
	}
}

// Handle walljumps
if (onVineL || onVineR) {
    if (onVineR) {
        xScale = -1;
    } else {
        xScale = 1;
	}
    
    vspeed = 2 * global.grav;
    sprite_index = sprPlayerSlide;
	image_speed = 0.5;
    
    // Check if moving away from the vine
	if (onVineL && scrButtonCheckPressed(global.rightButton)) || (onVineR && scrButtonCheckPressed(global.leftButton)) {
        if (scrButtonCheck(global.jumpButton)) { // Jumping off vine
            if (onVineR) {
                hspeed = -15;
            } else {
                hspeed = 15;
			}
            
            vspeed = -9 * global.grav;
            audio_play_sound(sndWallJump,0,false);
            sprite_index = sprPlayerJump;
        } else { // Moving off vine
			if (onVineR) {
                hspeed = -3;
            } else {
                hspeed = 3;
			}
            
            sprite_index = sprPlayerFall;
        }
    }
}

vspeed += gravity

with (objPlayerPhysics) {
    phy_position_x = other.x + other.hspeed
    phy_position_y = other.y + other.vspeed + 4
}

// Sliping on slopes
var _on_sliping = false
if (vspeed >= 0 and place_meeting(x, y + vspeed + 1, objSlope)) {
    var _up = vec2(0, 1)
    var _slope = 0
    var _n = vec2(0, 0)
    with (phy) {
        if (nx != undefined) {
            _n.free()
            _n = vec2(nx, ny)
            _slope = radtodeg(arccos(_up.dot(_n)))
        }
    }
    if (_slope > 50) {
        _on_sliping = true

        move_contact(objSlope, 270, abs(vspeed) + 1, 1)

        // test moving outside left or right. If (slope of sloping block > 1), It would be can to move outside on the left / right
        
        var _left_move = move_outside(objSlope, 180, abs(vspeed) + 1, 1, 0, vspeed + 1)
        if (_left_move > 0) {
            y -= vspeed + 3
            // hspeed = min(hspeed, 0)
            hspeed = 0
        }
        
        var _right_move = move_outside(objSlope, 0, abs(vspeed) + 1, 1, 0, vspeed + 1)
        if (_right_move > 0) {
            y -= vspeed + 3
            // hspeed = max(hspeed, 0)
            hspeed = 0
        }
    }
    _up.free()
    _n.free()
}

if (!_on_sliping) {
    with (phy) {
        nx = 0
        ny = 1
    }
}

// Clambing on slopes
if (!_on_sliping and vspeed >= 0 and hspeed != 0) {
    // Clambing down
    if (place_meeting(x, y + vspeed + 1, objSlope)) {
        move_contact(objSlope, 270, abs(vspeed) + 1)
        var _move_down = move_contact(objSlope, 270, maxHSpeed + 1, 1, hspeed, 0)
        if (_move_down > 0) {
            hspeed = 0
            vspeed = 0
        }
    }

    // Clambing up
    if (place_meeting(x + hspeed, y, objSlope)) {
        var _move_up = move_outside(objSlope, 90, maxHSpeed + 1, 1, hspeed, 0)
        if (_move_up > 0) {
            hspeed = 0
            vspeed = 0
        }
    }
}

// Count jumping
if (place_meeting(x, y + 1, objBlock)) {
    if (vspeed >= 0) {
        can_first_jump = true
        rest_jump = 2
    }
}
else {
    can_first_jump = false
}

// Check collisions with blocks
if (place_meeting(x, y + vspeed, objBlock)) {
    if (vspeed > 0)
        move_contact(objBlock, 270, abs(vspeed), 0.1)
    else
        move_contact(objBlock, 90, abs(vspeed), 0.1)
    vspeed = 0
}

if (place_meeting(x + hspeed, y, objBlock)) {
    if (hspeed > 0)
        move_contact(objBlock, 0, abs(hspeed))
    else
        move_contact(objBlock, 180, abs(hspeed))
    hspeed = 0
}

// Check buttons for player actions
if (!frozen) { // Check if frozen before doing anything
    if (scrButtonCheckPressed(global.jumpButton)) {
        scrPlayerJump();
	}
    if (scrButtonCheckReleased(global.jumpButton)) {
        scrPlayerVJump();
	}
    if (scrButtonCheckPressed(global.shootButton)) {
        scrPlayerShoot();
	}
    if (scrButtonCheckPressed(global.suicideButton)) {
        scrKillPlayer();
	}
}

if (_on_sliping) {
    y += 3
}

coord_on_physics(false, false)

if (place_meeting(x, y, objBlock)) {
    move_outside(objBlock, 90, abs(vspeed) + 3, 0.1)
    move_outside(objBlock, 270, abs(vspeed) + 3, 0.1)
    move_outside(objBlock, 0, maxHSpeed, 1)
    move_outside(objBlock, 180, maxHSpeed, 1)
    y = floor(y)
}