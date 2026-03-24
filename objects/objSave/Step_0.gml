if (place_meeting(x, y, objBullet)) {
    save()
}

if (place_meeting(x,y,objPlayer)) {
	if (scrButtonCheckPressed(global.shootButton)) {
	    save()
	}
}