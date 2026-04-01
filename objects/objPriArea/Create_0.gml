trg = -1

list = new List()
mat = new Matrix().set_pos(-x, -y)
mat_i = new Matrix()
surf_front = -1
surf_back = -1
surf = -1
shd = new DistortCircularShader()
    .set_resolution(sprite_width, sprite_height)
    .set_intensity(1)
    .set_strength(1)
    .set_frequency(1.5)
touched = false
t = 0

function add_object(obj) {
    var _l = ds_list_create()
    if (instance_place_list(x, y, obj, _l, false) > 0) {
        for (var i = 0; i < ds_list_size(_l); i++) {
            var inst = _l[| i]
            inst.visible = false
            list.add(inst)
        }
    }
    ds_list_destroy(_l)
}

add_object(objPriBlock)
add_object(objPriSpike)

function touch() {
    touched = true
    var pos = global.player_pos.copy().subtract(new Vec2(x, y))
    shd.set_center(pos)
    t = 0.3
}

function draw_objects(is_front = true) {
    if (is_front) {
        list.for_each(
            function(inst) {
                inst._draw_front()
            }
        )
    }
    else {
        list.for_each(
            function(inst) {
                inst._draw_back()
            }
        )
    }
}

function draw(is_front = true) {
    if (!surface_exists(surf)) {
        surf = surface_create(sprite_width, sprite_height)
    }

    mat_i.set()
    surface_set_target(surf)
    draw_clear_alpha(c_white, 0)
    shd.set()
    if (is_front) draw_surface(surf_front, 0, 0)
    else draw_surface(surf_back, 0, 0)
    shd.reset()
    surface_reset_target()
    mat_i.reset()

    draw_surface(surf, x, y)
}

function draw_front() {
    if (!surface_exists(surf_front)) {
        surf_front = surface_create(sprite_width, sprite_height)
        
        surface_set_target(surf_front)
        draw_clear_alpha(c_black, 0)
        mat.set()
        draw_objects()
        mat.reset()
        surface_reset_target()
    }
    
    draw(true)
}

function draw_back() {
    if (!surface_exists(surf_back)) {
        surf_back = surface_create(sprite_width, sprite_height)
        
        surface_set_target(surf_back)
        draw_clear_alpha(c_black, 0)
        mat.set()
        draw_objects(false)
        mat.reset()
        surface_reset_target()
    }

    draw(false)
}