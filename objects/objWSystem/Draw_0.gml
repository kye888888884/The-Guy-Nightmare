var _m = matrix_build(0, 0, 0, 0, 0, 0, 3, 3, 3)
matrix_set(matrix_world, _m)

so.set_light_dir(0, sin(get_time()), cos(get_time()))
shader_set_3d_model(so)
vertex_submit(model, pr_trianglelist, tex)
matrix_set(matrix_world, matrix_build_identity())
shader_reset()