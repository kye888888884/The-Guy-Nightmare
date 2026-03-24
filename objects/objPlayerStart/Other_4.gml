/// @description Spawn the player

if (!instance_exists(objPlayer)) {
	instance_create_layer(x,y+6,"Player",objPlayer);
}