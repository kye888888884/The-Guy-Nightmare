anchor_x = cx + lengthdir_x(sdis, sdir)
anchor_y = cy + lengthdir_y(sdis, sdir)

gap_x = x - anchor_x
gap_y = y - anchor_y

dir = point_direction(cx, cy, anchor_x, anchor_y)
dis = point_distance(cx, cy, anchor_x, anchor_y)