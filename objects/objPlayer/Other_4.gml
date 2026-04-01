/// @description Put into the correct layer

layer = layer_get_id("Player");
if (!instance_exists(objCape))
    instance_create(objCape, x, y)