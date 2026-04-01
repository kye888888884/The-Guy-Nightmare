fix = fixture_bind(
    fixture_create_polygon(
        [
            new Vec2(-8.1, -14), 
            new Vec2(-7.5, -15), 
            new Vec2(7.5, -15), 
            new Vec2(8.1, -14), 
            new Vec2(8.1, 15), 
            new Vec2(-8.1, 15)
        ],
        5, 0, 0, 0, 0
    ), id
)

phy_fixed_rotation = true