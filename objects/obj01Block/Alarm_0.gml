if (!created) {
    for (var i = 0; i < image_xscale; i++) {
        for (var j = 0; j < image_yscale; j++) {
            var _ins = instance_create_depth(x + i * 32, y + j * 32, depth, object_index)
            _ins.created = true
        }
    }
    instance_destroy()
}
else {
    if (!place_meeting(x, y + 1, objBlock)) {
        image_index += 2
    }
}