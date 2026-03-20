/// 

coord_on_physics()

for (var i = 0; i < ds_list_size(objects); i++) {
    var obj = objects[| i]
    obj.id.x = x + obj.xgap
    obj.id.y = y + obj.ygap
}