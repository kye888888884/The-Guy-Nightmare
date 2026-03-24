/// @description Initialize variables

frozen = false; // Sets if the player can move or not

max_jump_count = 2
jump = 8.5 * global.grav; // Sets how fast the player jumps
jump2 = 7 * global.grav; // Sets how fast the player double jumps
gravity = 0.4 * global.grav; // Sets the player's gravity

can_first_jump = false;
rest_jump = 2; // Allow the player to double jump as soon as he spawns
maxHSpeed = 3; // Max horizontal speed
maxVSpeed = 9; // Max vertical speed
image_speed = 0.2; // Initial speed of animation
onPlatform = false; // Sets if the player is currently standing on a platform

xScale = 1; // Sets the direction the player is facing (1 is facing right, -1 is facing left)
on_block = false;

current_move = 0;

phy = noone
alarm[0] = 1

fix = fixture_bind(
    fixture_create_polygon(
        [
            new Vec2(-6, -11), 
            new Vec2(5, -11), 
            new Vec2(5, 8), 
            new Vec2(-6, 8)
        ],
        1, 1, 1, 1, 1
    )
)

phy_fixed_rotation = true

nx = 0
ny = 1

// Set the player's hitbox depending on gravity direction
if (global.grav == 1) {
	mask_index = sprPlayerMask;
} else {
	mask_index = sprPlayerMaskFlip;
}

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