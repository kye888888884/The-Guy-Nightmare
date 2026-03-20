coord_on_physics()

for (var i = 0; i < ds_list_size(objects); i++) {
    var obj = objects[| i]
    var _dis = point_distance(0, 0, obj.xgap, obj.ygap)
    var _dir = point_direction(0, 0, obj.xgap, obj.ygap)
    var _x = lengthdir_x(_dis, _dir + image_angle)
    var _y = lengthdir_y(_dis, _dir + image_angle)
    obj.id.x = x + _x
    obj.id.y = y + _y
    obj.id.image_angle = image_angle + obj.anglegap
}