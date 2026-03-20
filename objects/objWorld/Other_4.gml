/// @description Play current room music and put into the correct layer

scrGetMusic(); // Find and play the proper music for the current room

layer = layer_get_id("World"); // Put into the correct layer

physics_world_create(0.03125)
physics_world_gravity(0, 40)