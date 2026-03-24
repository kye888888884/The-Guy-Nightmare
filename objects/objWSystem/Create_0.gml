proj = matrix_build_projection_perspective_fov(60, SCREEN_WIDTH / SCREEN_HEIGHT, 1, 10000)
view = matrix_build_lookat(0, 0, -500, 0, 0, 0, 0, 1, 0)

camera_set_proj_mat(view_camera[0], proj)
camera_set_view_mat(view_camera[0], view)
camera_apply(view_camera[0])

start_3d()

z = 0
r = 0
m = matrix_build_identity()