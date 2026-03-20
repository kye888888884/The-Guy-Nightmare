/// @description Draw the player

draw()

// Draw the player's hitbox
if (global.debugShowHitbox) {
    draw_sprite_ext(mask_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha*0.8);
}