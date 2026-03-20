if (create_delay <= 0 and instance_exists(objPlayer)) {
    if (scrButtonCheckPressed(global.shootButton)) {
        
        var _x = objPlayer.x
        _x = clamp(_x, 5200, 5392)
        
        if (abs(objPlayer.x - _x) < 16) {
            keyboard_key_release(global.shootButton[0])
            var _ins = instance_create(obj01MelonGameObject, _x, 64)
            _ins.image_index = current_object_index
            with (_ins) { init() }

            current_object_index = choose(0, 1, 2)
            create_delay = 25

            score_up(0)
        }
    }
}

create_delay = max(0, create_delay - 1)

if (!gameover and score >= goal_score and !completed) {
    completed = true
    with (obj01MelonGameLock) instance_destroy()
}