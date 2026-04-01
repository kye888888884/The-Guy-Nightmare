list = new List()
cape_index = 0
repeat(30) { list.add(new Vec2(0, 0)) }
wind = new Vec2(0, 0)

line = new Line2D(list, 23, sprite_get_texture(sprCape, 0), acPlayer, "cape")

function set_wind(_h, _v) {
    wind.x = _h * 0.3
    wind.y = _v
}

function _draw() {
    x = global.player_pos.x
    y = global.player_pos.y - 4 + wind.y

    var _width = 23 - abs(wind.x) * 5
    cape_index = (cape_index + 0.05 + abs(wind.x)) mod 8
    line.set_texture(sprite_get_texture(sprCape, cape_index))
        .set_pos(x, y)
        .set_width(_width)
        .draw()

    line.points.pop_last()
    for (var i = 0; i < line.points.len(); i++) {
        var p = line.points.get(i)
        p.x -= wind.x * 0.8
        p.y += min(0.8 - abs(wind.x) * 0.8 - wind.y * 0.2, 0.8) * 0.8
    }
    line.points.add(new Vec2(0, 0), 0)
}