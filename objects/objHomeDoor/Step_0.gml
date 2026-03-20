if (place_meeting(x, y, objPlayer) and scrButtonCheckPressed(global.upButton)) {
    with (objPlayer) instance_destroy()
    room_goto(rWarehouse)
}