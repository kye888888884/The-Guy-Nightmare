proj = matrix_build_projection_perspective_fov(60, SCREEN_WIDTH / SCREEN_HEIGHT, 1, 10000)
view = matrix_build_lookat(0, 0, -500, 0, 0, 0, 0, 1, 0)

try {
    layer_background_visible(layer_background_get_id("Background"), false)
}

start_3d()

model = get_3d_model("fullmoon")
tex = sprite_get_texture(sprTextureMoon, 0)
so = shading_option()
    .set_light_dir(0, 1, 1)
    .set_light_col(1.5, 1.5, 1.5, 1)
    .set_ambient(0.0)
    .set_normal(0.3, sprite_get_texture(sprTextureMoonMap, 1))
    .set_ao(0.5, sprite_get_texture(sprTextureMoonMap, 0))
    .set_specular(1.0, sprite_get_texture(sprTextureMoonMap, 2))

surf_bg = -1

var _scale = 8
moon_mat = matrix().set_scale(_scale, _scale, _scale)
moon_pos_mat = matrix().set_pos(0, 0, 800)

function update_surface() {
    if (!surface_exists(surf_bg)) {
        create_surface()
    }

    surface_set_target(surf_bg)
    draw_clear_alpha(c_black, 0)

    gpu_set_ztestenable(true)
    gpu_set_zwriteenable(true)
    gpu_set_cullmode(cull_clockwise)

    camera_set_proj_mat(view_camera[0], proj)
    camera_set_view_mat(view_camera[0], view)
    camera_apply(view_camera[0])

    var _mat = moon_mat.multiply(moon_pos_mat.matrix())
    matrix_set(matrix_world, _mat)

    gpu_set_tex_filter(true)

    var _mat_light = moon_mat.get_pos_on_matrix(0, 0, 1)
    so.set_light_dir(_mat_light.x, _mat_light.y, _mat_light.z)
    shader_set_3d_model(so)
    vertex_submit(model, pr_trianglelist, tex)
    shader_reset()

    matrix_set(matrix_world, matrix_build_identity())
    gpu_set_ztestenable(false)
    gpu_set_zwriteenable(false)
    gpu_set_cullmode(cull_noculling)

    gpu_set_tex_filter(false)

    surface_reset_target()
}

function create_surface() {
    surf_bg = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
}

function delete_surface() {
    surface_free(surf_bg)
}
