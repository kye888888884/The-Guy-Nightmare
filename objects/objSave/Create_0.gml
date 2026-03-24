/// @description Initialize variables

canSave = true; // Sets whether the player can currently use this save

grav = 1; // Sets which way the gravity has to be for this save to work
maxDifficulty = 1; // Sets the max difficulty that this save exists on

function save() {
    if (canSave && instance_exists(objPlayer) && global.grav == grav) {
        // Make sure the player isn't saving outside the room to prevent save locking
        if (!((objPlayer.x < 0 || objPlayer.x > room_width || objPlayer.y < 0 || objPlayer.y > room_height) && global.edgeDeath)) {
            canSave = false; // Set it so that the player can't save again immediately
            alarm[0] = 30; // Set alarm so the player can save again
            image_index = 1; //Set the sprite to green
            alarm[1] = 58; // Set alarm to reset image_index
            scrSaveGame(true); // Save the game
        }
    }
}