/// @description Handle player movement

// Check left/right button presses
// var L = (scrButtonCheck(global.leftButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.leftButton)));
// var R = (scrButtonCheck(global.rightButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.rightButton)));
var L = scrButtonCheck(global.leftButton)
var R = scrButtonCheck(global.rightButton)
var L_pressed = scrButtonCheckPressed(global.leftButton)
var R_pressed = scrButtonCheckPressed(global.rightButton)
var L_released = scrButtonCheckReleased(global.leftButton)
var R_released = scrButtonCheckReleased(global.rightButton)

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

if (h != 0) { // Player is moving
    xScale = h // Set the direction the player is facing
    sprite_index = sprPlayerRun
	image_speed = 0.5
} else { // Player is not moving
    sprite_index = sprPlayerIdle
	image_speed = 0.2
}

// physics_apply_force(0, 0, 0, -phy_mass * 40) // ignore world gravity
// phy_speed_y += gravity // calculate gravity manually

move_hspeed = h * maxHSpeed
if (phy_speed_y > maxVSpeed) {
	phy_speed_y = maxVSpeed
}

if (on_floor) {
    if (phy_speed_y >= 0)
        physics_apply_force(0, 0, 0, -phy_mass * 30.9) // ignore world gravity
    if (L_pressed or R_pressed) {
        if (h == -sign(col_normal.x)) { // downhill
            if (phy_speed_y > -jump2) {
                phy_speed_y = -col_normal.x * move_hspeed
                phy_position_y += phy_speed_y
            }
        }
    }
    if (L_released or R_released) {
        if (phy_speed_y > -jump2)
            phy_speed_y = 0
    }
}

if (on_sliding) {
    if (h == sign(col_normal.x))
        move_hspeed = 0
    if (h == 0)
        move_hspeed = -col_normal.x * maxHSpeed
    physics_apply_force(0, 0, 0, phy_mass * 30.9)
}

phy_speed_x = move_hspeed;

if (!on_floor) {
    if ((phy_speed_y * global.grav) < -0.5) {
        sprite_index = sprPlayerJump
    } else if ((phy_speed_y * global.grav) > 0.5) {
        sprite_index = sprPlayerFall
    }

    rest_jump = min(rest_jump, max_jump_count - 1)
}
else {
    rest_jump = max_jump_count
}

// Check buttons for player actions
if (!frozen) { // Check if frozen before doing anything
    if (scrButtonCheckPressed(global.jumpButton)) {
        scrPlayerJump()
	}
    if (scrButtonCheckReleased(global.jumpButton)) {
        scrPlayerVJump()
	}
    if (scrButtonCheckPressed(global.shootButton)) {
        scrPlayerShoot()
	}
    if (scrButtonCheckPressed(global.suicideButton)) {
        scrKillPlayer()
	}
}

// show_debug_message("On floor: " + string(on_floor) + " | On wall: " + string(on_wall) + " | On sliding: " + string(on_sliding))

on_floor = false
on_wall = false
on_sliding = false

// var _add = 0
// if (mouse_wheel_up()) _add = 1
// else if (mouse_wheel_down()) _add = -1
// if (ALT) _add *= 0.1
// if (mouse_wheel_down() or mouse_wheel_up()) {
//     if (!CTRL) {
//         jump += _add * 0.1
//         show_debug_message("Jump: " + string(jump))
//     }
//     else {
//         jump2 += _add * 0.1
//         show_debug_message("Double Jump: " + string(jump2))
//     }
// }