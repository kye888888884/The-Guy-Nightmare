fix = fixture_bind(
    fixture_create_polygon(
        [
            new Vec2(-4.5, -9), 
            new Vec2(-4, -10), 
            new Vec2(4, -10), 
            new Vec2(4.5, -9), 
            new Vec2(4.5, 10), 
            new Vec2(-4.5, 10)
        ],
        5, 0, 0, 0, 0
    ), id
)

phy_fixed_rotation = true