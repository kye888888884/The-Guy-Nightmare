/// @description Initialize variables

FLOOR_MAX_ANGLE = 50

frozen = false; // Sets if the player can move or not

max_jump_count = 2
jump = 8 * global.grav; // Sets how fast the player jumps
jump2 = 6.8 * global.grav; // Sets how fast the player double jumps
gravity = 0.4 * global.grav; // Sets the player's gravity

can_first_jump = false;
rest_jump = 2; // Allow the player to double jump as soon as he spawns
maxHSpeed = 3; // Max horizontal speed
maxVSpeed = 9; // Max vertical speed
image_speed = 0.2; // Initial speed of animation
onPlatform = false; // Sets if the player is currently standing on a platform
on_floor = false
on_wall = false
on_sliding = false
move_hspeed = 0

xScale = 1; // Sets the direction the player is facing (1 is facing right, -1 is facing left)
on_block = false;

fix = noone

current_move = 0;

alarm[0] = 1

col_normal = new Vec2(0, 1)

// Create the player's bow if on medium mode
if (global.difficulty == 0 && global.gameStarted) {
    instance_create_depth(x,y,depth-1,objBow);
}

// Save the game if currently set to autosave
if (global.autosave) {
    scrSaveGame(true);
    global.autosave = false;
}

function draw() {
    var drawX = x;
    var drawY = y;

    if (global.grav == -1)
        drawY += 1;

    draw_sprite_ext(sprite_index,image_index,drawX,drawY,image_xscale*xScale,image_yscale*global.grav,image_angle,image_blend,image_alpha);
}

function is_on_wall() {
    var _d = col_normal.dir()
    return place_meeting(x, y + 1, objBlock) and _d < 0.7 // 45 degree slope limit
}