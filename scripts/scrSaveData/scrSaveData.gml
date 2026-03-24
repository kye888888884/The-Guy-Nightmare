/// @function scrSaveGame(savePosition)
/// @description Saves the game
/// @param savePosition sets whether the game should save the player's current location or just save the deaths/time
function scrSaveGame(savePosition) {
	// Save the player's current location variables if the script is currently set to (we don't want to save the player's location if we're just updating death/time)
	var _dm = global.dataManager
	if (savePosition) {
		_dm.set("room", room_get_name(room))
	    _dm.set("grav", global.grav)
		var _px = objPlayer.x
		var _py = objPlayer.y
	    // Check if the player is saving inside of a wall or in the ceiling when the player's position is floored to prevent save locking
	    with (objPlayer) {
	        if (!place_free(floor(_px),_py))
	            _px += 1
        
	        if (!place_free(_px,floor(_py)))
	            _py += 1
        
	        if (!place_free(floor(_px),floor(_py))) {
	            _px += 1
	            _py += 1
	        }
	    }
    
	    // Floor the player's position to match standard engine behavior
	    _dm.set("player_x", floor(_px))
	    _dm.set("player_y", floor(_py))
    
		_dm.set("secret_item", global.secretItem.to_array())
		_dm.set("boss_item", global.bossItem.to_array())
		_dm.set("trigger", global.trigger.to_array())
    
		_dm.set("game_clear", global.gameClear)

		with (objPriSystem) { save(_dm) }
	}

	// Create a map for save data
	var saveMap = ds_map_create();

	_dm.set("deaths", global.deaths)
	_dm.set("time", global.time)
	_dm.set("time_micro", global.timeMicro)
	_dm.set("difficulty", global.difficulty)

	// Add MD5 hash to verify saves and make them harder to hack
	var _check_str = string(global.deaths) + string(global.time) + string(global.timeMicro)
	_dm.set("map_md5",md5_string_unicode(_check_str+MD5_STR_ADD))

	// Save the map to a file
	_dm.save("Data\\save"+string(global.saveNum))
}

/// @function scrLoadGame(loadFile)
/// @description Loads the game
/// @param loadFile sets whether or not to read the save file when loading the game
function scrLoadGame(loadFile) {
	var _dm = global.dataManager
	// Only load save data from the save file if the script is currently set to (we should only need to read the save file on first load because the game stores them afterwards)
	if (loadFile) {
	    // Load the save map
    
	    var _load_dm = new DataManager().load("Data\\save"+string(global.saveNum))
    
	    var saveValid = true; // Keeps track of whether or not the save being loaded is valid
    
	    if (_load_dm.get_dict() != -1) { // Check if the save map loaded properly
	        global.deaths = _load_dm.get("deaths")
	        global.time = _load_dm.get("time")
	        global.timeMicro = _load_dm.get("time_micro")
        
	        global.difficulty = _load_dm.get("difficulty");
	        _dm.set_from(_load_dm, "room");
	        _dm.set_from(_load_dm, "player_x");
	        _dm.set_from(_load_dm, "player_y");
	        global.grav = _dm.set_from(_load_dm, "grav");
			
			var _room_name = _dm.get("room")
	        if (is_string(_room_name)) { // Check if the saved room string loaded properly
	            if (!room_exists(asset_get_index(_room_name))) { // Check if the room index in the save is valid
	                saveValid = false;
				}
	        } else {
	            saveValid = false;
	        }
        
			global.secretItem = new List(_load_dm.get("secret_item"))
			_dm.set("secret_item", global.secretItem.to_array())
			global.bossItem = new List(_load_dm.get("boss_item"))
			_dm.set("boss_item", global.bossItem.to_array())
			global.trigger = new List(_load_dm.get("trigger"))
			_dm.set("trigger", global.trigger.to_array())
	        global.gameClear = _dm.set_from(_load_dm, "game_clear")

			_dm.set_from(_load_dm, "pri_moon_mat")
			_dm.set_from(_load_dm, "pri_cam_pos")
        
	        // Load MD5 string from the save map
	        var mapMd5 = _load_dm.get("map_md5")
        
	        // Check if MD5 is not a string in case the save was messed with or got corrupted
	        if (!is_string(mapMd5)) {
	            saveValid = false; // MD5 is not a string, save is invalid
			} else {
		        // Generate MD5 string to compare with
		        _load_dm.remove("map_md5")
				var _check_str = string(global.deaths) + string(global.time) + string(global.timeMicro)
		        var genMd5 = md5_string_unicode(_check_str+MD5_STR_ADD);
        
				// Check if MD5 hash is invalid
		        if (mapMd5 != genMd5) {
		            saveValid = false
				}
			}
	    } else {
	        // Save map didn't load correctly, set the save to invalid
	        saveValid = false
	    }
    
	    if (!saveValid) { // Check if the save is invalid
	        // Save is invalid, restart the game
	        show_message("Save invalid!")
			game_restart()
	        exit
	    }
	}

	// Set game variables and the player's position

	with (objPlayer) { // Destroy the player if it exists
	    instance_destroy()
	}

	global.gameStarted = true // Sets game in progress (enables saving, restarting, etc.)
	global.noPause = false // Disable no pause mode
	global.autosave = false // Disable autosaving since we're loading the game

	// Check if the player's layer exists, if it doesn't then create a temporary layer
	var spawnLayer = (layer_exists("Player")) ? layer_get_id("Player") : layer_create(0)
	instance_create_layer(_dm.get("player_x"),_dm.get("player_y"),spawnLayer,objPlayer)

	if (!global.softRestart)
		room_goto(asset_get_index(_dm.get("room")))
	else {
		with (objGameOver) instance_destroy()
	}
}

