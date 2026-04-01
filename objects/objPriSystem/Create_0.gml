// room_goto_live(rPri_01)

#macro PRI_FRONT_COLOR make_color_hsv(0, 0, 0)
#macro PRI_BACK_COLOR make_color_hsv(50, 100, 255)

global.edgeDeath = false
global.softRestart = true

fov = 20
cam_surf = new Camera()
    .set_proj(fov, SCREEN_WIDTH / SCREEN_HEIGHT, 1, 10000)
    .set_view(0, 0, -3000, 0, 0, 0, 0, 1, 0)

try {
    layer_background_visible(layer_background_get_id("Background"), false)
}

start_3d()

moon_tex = sprite_get_texture(sprTextureMoon, 0)
moon_so = new ModelShaderOption()
    .set_light_dir(0, 1, 1)
    .set_light_col(1.5, 1.5, 1.5, 1)
    .set_ambient(0.0)
    .set_normal(0.3, sprite_get_texture(sprTextureMoon, 1))
    .set_ao(0.5, sprite_get_texture(sprTextureMoonMap, 0))
    .set_specular(1.0, sprite_get_texture(sprTextureMoonMap, 1))
moon_scale = 23
moon_mat = new Matrix().set_scale(moon_scale, moon_scale, moon_scale).set_rotation(0, 0, 0)

moon_pos_mat = new Matrix().set_pos(0, 0, 1800)
f_rot = 0.0715 * 0.3
moon_model = new Model("fullmoon", moon_tex, moon_mat, moon_so)

surf_bg = -1
surf_fg_front = -1
surf_fg_back = -1
surf_fg_sphere_front = -1
surf_fg_sphere_back = -1
surf_player = -1
surf_player_mask = -1

cam_scale = 1.8
w = SCREEN_WIDTH * cam_scale
h = SCREEN_WIDTH * cam_scale
cam_x = 0
cam_y = 0
cam_target_margin = 32
cam_pos_offset_x = -(w - SCREEN_WIDTH) / 2
cam_pos_offset_y = -(h - SCREEN_HEIGHT) / 2
cam_offset_mat = new Matrix().set_pos(-cam_pos_offset_x, -cam_pos_offset_y)
cam_trans_mat = new Matrix()

so_fg_front = new ShaderOption(shdPriSphere)
    .set_uniform("u_radius", 640 * 0.5 / 960)
    .set_uniform("iResolution", [SCREEN_WIDTH, SCREEN_WIDTH])
    .set_uniform("u_ambient", 0)
    .set_uniform("u_alpha", 0)
    .set_uniform("u_ref", 0.5)
    .set_uniform("u_zoom", 1.5)
    .set_smooth(true)
so_fg_back = so_fg_front.copy().set_uniform("u_alpha", 1)

bloom_shader = new BloomShader(4)

global.chunk_size = SCREEN_WIDTH / 2
global.current_chunk = new Vec2(0, 0)
list_static_objects = new List([objPriBlock, objPriSpike])
list_draw_objects = new List([
    objPriSpike, 
    objPriSpikeFollowCurve, 
    objPriSlopeDigLeft, 
    objPriSlopeDigRight, 
    objPriBlock, 
    objPriCircle, 
    objPriBicycle
])

draw_option = new DrawOption()
    .set_font(fDefault18)
    .set_align(-1, -1)

function draw_objects() {
    with (objSave) {
        visible = false
        draw_self()
    }
    with (objBullet) {
        visible = false
        draw_self()
    }
    with (objBlood) {
        visible = false
        draw_self()
    }
}

function draw_player(_blend) {
    cam_trans_mat.reset()

    surface_set_target(surf_player)
    draw_clear_alpha(c_white, 0)
    with (objPlayer) {
        draw_sprite_ext(sprite_index, image_index, 16, 16, image_xscale, image_yscale, 0, c_white, 1)
    }
    surface_reset_target()

    surface_set_target(surf_player_mask)
    draw_clear_alpha(c_white, 1)
    gpu_set_blendmode_ext(bm_zero, bm_src_alpha)
    gpu_set_colorwriteenable(false, false, false, true)
    draw_surface(surf_player, 0, 0)
    gpu_set_blendmode(bm_normal)
    gpu_set_colorwriteenable(true, true, true, true)
    surface_reset_target()

    cam_trans_mat.set()
    
    if (instance_exists(objPlayer)) {
        for (var _h = -1; _h <= 1; _h += 2) {
            for (var _v = -1; _v <= 1; _v += 2) {
                draw_surface_ext(surf_player_mask, objPlayer.x - 16 + _h, objPlayer.y - 16 + _v, 1, 1, 0, _blend, 1)
            }
        }
    }

    with (objPlayer) {
        visible = false
        draw()
    }
}

function update_surface() {
    if (!surface_exists(surf_bg)) {
        create_surface()
    }

    // background surface (moon)
    surface_set_target(surf_bg)
    draw_clear_alpha(c_black, 0)

    cam_surf.apply()

    var _mat_light = moon_mat.get_pos_on_matrix(0, 0, 1)
    var _mat = moon_mat.copy().multiply(moon_pos_mat)
    moon_model.set_matrix(_mat)
    moon_so.set_light_dir(_mat_light.x, _mat_light.y, _mat_light.z).set()
    moon_model.draw()
    _mat.free()

    surface_reset_target()

    // foreground surfaces
    surface_set_target(surf_fg_front)
    draw_clear_alpha(c_black, 0)
    draw_clear_alpha(c_white, 0)
    cam_trans_mat.set()
    draw_objects()
    with (objPriSpike) draw_front()
    with (objPriSpikeFollowCurve) draw_front()
    with (objPriBlock) draw_front()
    with (objPriSlopeDigLeft) draw_front()
    with (objPriSlopeDigRight) draw_front()
    with (objPriArea) draw_front()
    with (objPriCircle) draw_front()
    draw_player(c_white)
    with (objPriBicycle) draw_front()
    cam_trans_mat.reset()
    surface_reset_target()

    surface_set_target(surf_fg_back)
    draw_clear_alpha(c_black, 0)
    draw_clear_alpha(c_white, 0)
    cam_trans_mat.set()
    draw_objects()
    with (objPriSpike) draw_back()
    with (objPriSpikeFollowCurve) draw_back()
    with (objPriBlock) draw_back()
    with (objPriSlopeDigRight) draw_back()
    with (objPriSlopeDigLeft) draw_back()
    with (objPriArea) draw_back()
    with (objPriCircle) draw_back()
    with (objPriCurveMap) draw()
    draw_player(PRI_BACK_COLOR)
    with (objPriBicycle) draw_back()
    cam_trans_mat.reset()
    surface_reset_target()

    surface_set_target(surf_fg_sphere_front)
    draw_clear_alpha(c_black, 0)

    so_fg_front.set_uniform("u_light_dir", [_mat_light.x, _mat_light.y, _mat_light.z]).set()
    draw_surface(surf_fg_front, cam_pos_offset_x, cam_pos_offset_y)
    so_fg_front.reset()
    surface_reset_target()

    surface_set_target(surf_fg_sphere_back)
    draw_clear_alpha(c_black, 0)
    so_fg_back.set_uniform("u_light_dir", [_mat_light.x, -_mat_light.y, -_mat_light.z]).set()
    draw_surface(surf_fg_back, cam_pos_offset_x, cam_pos_offset_y)
    so_fg_back.reset()
    surface_reset_target()
}

function create_surface() {
    surf_bg = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
    surf_fg_front = surface_create(w, h)
    surf_fg_back = surface_create(w, h)
    surf_fg_sphere_front = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
    surf_fg_sphere_back = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
    surf_player = surface_create(32, 32)
    surf_player_mask = surface_create(32, 32)
}

function delete_surface() {
    surface_free(surf_bg)
    surface_free(surf_fg_front)
    surface_free(surf_fg_back)
    surface_free(surf_fg_sphere_front)
    surface_free(surf_fg_sphere_back)
    surface_free(surf_player)
    surface_free(surf_player_mask)
}

function save(_dm) {
    _dm.set("pri_moon_mat", moon_mat.decompose().to_array())
    _dm.set("pri_cam_pos", [cam_x, cam_y])
}

function load() {
    save_mat_array = global.dataManager.get("pri_moon_mat")
    if (save_mat_array != undefined) {
        moon_mat.from_array(save_mat_array)
    }
    save_cam_pos = global.dataManager.get("pri_cam_pos")
    if (save_cam_pos != undefined) {
        cam_x = save_cam_pos[0]
        cam_y = save_cam_pos[1]
    }
}

function update_chunk() {
    list_static_objects.for_each(
        function (_obj) {
            instance_deactivate_object(_obj)
        }
    )

    var _left = global.cam_x - SCREEN_WIDTH * 2
    var _top = global.cam_y - SCREEN_WIDTH * 2
    var _w = SCREEN_WIDTH * 4
    var _h = SCREEN_WIDTH * 4
    instance_activate_region(_left, _top, _w, _h, true)
}