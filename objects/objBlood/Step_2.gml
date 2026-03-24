/// 

if (disappear) {
	image_alpha -= 0.05
	if (image_alpha <= 0) instance_destroy()
}

coord_on_physics()