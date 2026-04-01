function Vec2(_x, _y) constructor {
	x = _x
	y = _y
	
	// In the case that _y is undefined,
	// _x is treated as a Vec2
	static dot = function (_x, _y = undefined) {
		/// @returns {real}
		if (_y == undefined) {
			var _result = x * _x.x + y * _x.y
			return _result
		} else {
			return x * _x + y * _y
		}
	}

	static equals = function (_x, _y = undefined) {
		/// @returns {bool}
		if (_y == undefined) {
			return x == _x.x and y == _x.y
		} else {
			return x == _x and y == _y
		}
	}

	static add = function (_x, _y = undefined) {
		/// @returns {Vec2}
		if (_y == undefined) {
			x += _x.x
			y += _x.y
		} else {
			x += _x
			y += _y
		}
		return self
	}

	static subtract = function (_x, _y = undefined) {
		/// @returns {Vec2}
		if (_y == undefined) {
			x -= _x.x
			y -= _x.y
		} else {
			x -= _x
			y -= _y
		}
		return self
	}

	static multiply = function (_len) {
		/// @returns {Vec2}
		x *= _len
		y *= _len
		return self
	}

	static len = function () {
		/// @returns {real}
		return point_distance(0, 0, x, y)
	}

	static dir = function () {
		/// @returns {real} Angle in degrees
		return point_direction(0, 0, x, y)
	}

	static dist = function (_x, _y = undefined) {
		/// @returns {real}
		if (_y == undefined) {
			return point_distance(x, y, _x.x, _x.y)
		} else {
			return point_distance(x, y, _x, _y)
		}
	}

	static rot = function (_angle) {
		/// @returns {Vec2} Rotate by _angle (in degrees)
		var _len = len()
		var _dir = dir() + _angle
		x = lengthdir_x(_len, _dir)
		y = lengthdir_y(_len, _dir)
		return self
	}

	static normalize = function () {
		/// @returns {Vec2} Normalize the vector (make its length 1)
		var _len = len()
		if (_len != 0) {
			x /= _len
			y /= _len
		}
		return self
	}

	static lerp = function (_target, _t) {
		/// @returns {Vec2} Linear interpolation towards _target by factor _t (0 to 1)
		var _x = lerp(x, _target.x, _t)
		var _y = lerp(y, _target.y, _t)
		return new Vec2(_x, _y)
	}

	static toString = function () {
		/// @returns {string} String representation of the vector
		return "(" + string(x) + ", " + string(y) + ")"
	}

	static str = function () {
		/// @returns {string} String representation of the vector
		return toString()
	}

	static to_array = function () {
		/// @returns {array} An array representation of the vector
		return [x, y]
	}

	static copy = function () {
		/// @returns {Vec2} A copy of this vector
		return new Vec2(x, y)
	}

	static free = function () {
		/// @returns {none} Destroy this struct
		
	}
}

function ShaderOption(_shd) constructor {
	shd = _shd
	uniforms = new Dict()
	textures = new Dict()
	smooth = false
	tex_repeat = false

	static _set = function() {
		shader_set(shd)
		
		uniforms.for_each(function (_k, _v) {
			shader_set_uniform(shd, _k, _v)
		})

		textures.for_each(function (_k, _v) {
			var _u = shader_get_sampler_index(shd, _k)
			texture_set_stage(_u, _v)
		})

		if (smooth) {
			gpu_set_tex_filter(true)
		} else {
			gpu_set_tex_filter(false)
		}

		if (tex_repeat) {
			gpu_set_tex_repeat(true)
		} else {
			gpu_set_tex_repeat(false)
		}
		
		return self
	}

	static set = function() {
		return _set()
	}

	static set_uniform = function(_name, _value) {
		uniforms.set(_name, _value)
		return self
	}

	static set_texture = function(_name, _tex) {
		textures.set(_name, _tex)
		return self
	}

	static set_smooth = function(_smooth) {
		smooth = _smooth
		return self
	}

	static set_repeat = function(_repeat) {
		tex_repeat = _repeat
		return self
	}

	static reset = function() {
		shader_reset()
		gpu_set_tex_filter(false)
		gpu_set_tex_repeat(false)
		return self
	}

	static free = function(_reset = true) {
		/// @returns {none} Destroy this struct
		if (_reset)
			shader_reset()
		delete uniforms
		delete textures
	}

	static copy = function() {
		var _copy = new ShaderOption(shd)
		_copy.uniforms = uniforms.copy()
		_copy.textures = textures.copy()
		_copy.smooth = smooth
		_copy.tex_repeat = tex_repeat
		return _copy
	}
}

function ModelShaderOption(_shd = shd3DModel) : ShaderOption(_shd) constructor {
	shd = _shd

	light_dir = [0, 0, 1]
	light_col = [1, 1, 1, 1]
	ambient = 0

	normal = 0
	sample_normal = noone

	roughness = 0
	sample_roughness = noone

	ao = 0
	sample_ao = noone

	specular = 0
	sample_specular = noone

	static init = function() {
		uniforms.set("u_light_dir", light_dir)
		uniforms.set("u_light_col", light_col)
		uniforms.set("u_ambient", ambient)
		uniforms.set("u_normal", normal)
		uniforms.set("u_roughness", roughness)
		uniforms.set("u_ao", ao)
		uniforms.set("u_specular", specular)
	}
	init()

	static set_light_dir = function(_xdir, _ydir, _zdir) {
		light_dir = [_xdir, _ydir, _zdir]
		uniforms.set("u_light_dir", light_dir)
		return self
	}

	static set_light_col = function(_r, _g, _b, _a) {
		light_col = [_r, _g, _b, _a]
		uniforms.set("u_light_col", light_col)
		return self
	}

	static set_ambient = function(_ambient) {
		ambient = _ambient
		uniforms.set("u_ambient", ambient)
		return self
	}

	static set_normal = function(_normal_strength, _tex_normal = noone) {
		normal = _normal_strength
		if (normal == 0) sample_normal = noone
		else if (_tex_normal != noone)
			sample_normal = _tex_normal
		uniforms.set("u_normal", normal)
		return self
	}

	static set_roughness = function(_roughness_strength, _tex_roughness = noone) {
		roughness = _roughness_strength
		if (roughness == 0) sample_roughness = noone
		else if (_tex_roughness != noone)
			sample_roughness = _tex_roughness
		uniforms.set("u_roughness", roughness)
		return self
	}

	static set_ao = function(_ao_strength, _tex_ao = noone) {
		ao = _ao_strength
		if (ao == 0) sample_ao = noone
		else if (_tex_ao != noone)
			sample_ao = _tex_ao
		uniforms.set("u_ao", ao)
		return self
	}

	static set_specular = function(_specular_strength, _tex_specular = noone) {
		specular = _specular_strength
		if (specular == 0) sample_specular = noone
		else if (_tex_specular != noone)
			sample_specular = _tex_specular
		uniforms.set("u_specular", specular)
		return self
	}

	static set = function(_smooth = true, _cull = cull_clockwise) {
		_set()

		if (normal > 0.0)
			shader_set_texture(shd, "u_sample_normal", sample_normal)
		if (roughness > 0.0)
			shader_set_texture(shd, "u_sample_roughness", sample_roughness)
		if (ao > 0.0)
			shader_set_texture(shd, "u_sample_ao", sample_ao)
		if (specular > 0.0)
			shader_set_texture(shd, "u_sample_specular", sample_specular)

		gpu_set_tex_filter(_smooth)
		gpu_set_ztestenable(true)
		gpu_set_zwriteenable(true)
		gpu_set_cullmode(_cull)

		return self
	}

	static reset = function() {
		gpu_set_tex_filter(false)
		gpu_set_ztestenable(false)
		gpu_set_zwriteenable(false)
		gpu_set_cullmode(cull_noculling)
		shader_reset()
		return self
	}

	static free = function() {
		/// @returns {none} Destroy this struct
		delete self_id
	}
}

function Dict() constructor {
	self_id = self
	dict = ds_map_create()

	static set = function(_key, _value) {
		/// @param {string} _key
		/// @param {any} _value
		/// @returns {Dict} self for chaining
		if (ds_map_exists(dict, _key)) {
			ds_map_replace(dict, _key, _value)
		}
		else {
			ds_map_add(dict, _key, _value)
		}
		return self
	}

	static get = function(_key) {
		/// @param {string} _key
		if (ds_map_exists(dict, _key)) {
			return ds_map_find_value(dict, _key)
		}
		return undefined
	}

	static add_value = function(_key, _value) {
		/// @param {string} _key
		/// @param {real} _value
		/// @returns {Dict} self for chaining
		var _current = get(_key)
		if (_current == undefined) _current = 0
		set(_key, _current + _value)
		return self
	}

	static remove = function(_key) {
		/// @param {string} _key
		/// @returns {Dict} self for chaining
		if (ds_map_exists(dict, _key)) {
			ds_map_delete(dict, _key)
		}
		return self
	}

	static len = function() {
		/// @returns {real} Number of key-value pairs in the dictionary
		return ds_map_size(dict)
	}

	static keys = function() {
		/// @returns {array} An array of keys in the dictionary
		return ds_map_keys_to_array(dict)
	}

	static values = function() {
		/// @returns {array} An array of values in the dictionary
		return ds_map_values_to_array(dict)
	}

	static is_empty = function() {
		/// @returns {bool} true if the dictionary is empty, false otherwise
		return ds_map_size(dict) == 0
	}

	static write = function() {		
		return ds_map_write(dict)
	}

	static save = function(_filename) {
		/// @param {string} _filename
		/// @returns {bool} true if the dictionary was successfully saved, false otherwise
		return ds_map_secure_save(dict, _filename)
	}

	static load = function(_filename) {
		/// @param {string} _filename
		/// @returns {bool} true if the dictionary was successfully loaded, false otherwise
		return ds_map_secure_load(_filename)
	}

	static for_each = function(_func) {
		/// @param {function} _func(_key, _value) function to be called for each key-value pair. It should take two arguments: key and value.
		/// @returns {Dict} self for chaining
		var _keys = ds_map_keys_to_array(dict)
		for (var _i = 0; _i < array_length(_keys); _i++) {
			var _key = _keys[_i]
			var _value = ds_map_find_value(dict, _key)
			_func(_key, _value)
		}
		return self
	}

	static free = function() {
		/// @returns {none} Destroy this struct
		ds_map_destroy(dict)
		delete self_id
	}

	static copy = function() {
		var _copy = new Dict()
		var _keys = keys()
		for (var _i = 0; _i < len(); _i++) {
			var _key = _keys[_i]
			var _value = get(_key)
			_copy.set(_key, _value)
		}
		return _copy
	}

	static toString = function() {
		/// @returns {string} String representation of the dictionary
		var _str = "{"
		var _keys = keys()
		for (var _i = 0; _i < len(); _i++) {
			var _key = _keys[_i]
			var _value = get(_key)
			_str += string(_key) + ": " + string(_value)
			if (_i < len() - 1) {
				_str += ", "
			}
		}
		_str += "}"
		return _str
	}

	static str = function() {
		/// @returns {string} String representation of the dictionary
		return toString()
	}
}

function DataManager() : Dict() constructor {
	static save = function(_filename) {
		var f = file_text_open_write(_filename)
		var _result = file_text_write_string(f,base64_encode(ds_map_write(dict))); // Write map to the save file with base64 encoding
		file_text_close(f);
		return _result
	}

	static load = function(_filename) {
		ds_map_clear(dict)
		var f = file_text_open_read(_filename)
	    var _result = ds_map_read(dict,base64_decode(file_text_read_string(f)))
	    file_text_close(f)
		return self
	}

	static set_from = function(_dm, _key) {
		/// @param {DataManager} _dm
		/// @param {string} _key
		/// @returns {Dict} self for chaining
		var _value = _dm.get(_key)
		if (_value != undefined) {
			set(_key, _value)
		}
		return _value
	}

	static get_dict = function() {
		return dict
	}
}

function List(_arr = noone) constructor {
	self_id = self
	list = ds_list_create()
	if (_arr != noone) {
		for (var _i = 0; _i < array_length(_arr); _i++) {
			var _value = _arr[_i]
			ds_list_add(list, _value)
		}
	}
	
	static fill = function(_size, _default_value) {
		/// @param {real} _size
		/// @param {any} _default_value
		/// @returns {List} self for chaining
		for (var _i = 0; _i < _size; _i++) {
			ds_list_add(list, _default_value)
		}
		return self
	}

	static add = function(_value, _index = -1) {
		/// @param {any} _value
		/// @param {real} _index
		/// @returns {List} self for chaining
		if (_index >= 0 && _index <= ds_list_size(list)) {
			ds_list_insert(list, _index, _value)
		}
		else {
			ds_list_add(list, _value)
		}
		return self
	}

	static get = function(_index) {
		/// @param {real} _index
		if (_index >= 0 && _index < ds_list_size(list)) {
			return ds_list_find_value(list, _index)
		}
		return undefined
	}

	static len = function() {
		/// @returns {real} Number of elements in the list
		return ds_list_size(list)
	}

	static is_empty = function() {
		/// @returns {bool} true if the list is empty, false otherwise
		return ds_list_size(list) == 0
	}

	static free = function() {
		/// @returns {none} Destroy this struct
		ds_list_destroy(list)
		delete self_id
	}

	static copy = function() {
		var _copy = new List()
		for (var _i = 0; _i < len(); _i++) {
			var _value = get(_i)
			_copy.add(_value)
		}
		return _copy
	}

	static to_array = function() {
		/// @returns {array} An array representation of the list
		var _array = []
		for (var _i = 0; _i < len(); _i++) {
			var _value = get(_i)
			array_push(_array, _value)
		}
		return _array
	}

	static for_each = function(_func) {
		/// @param {function} _func(_value) function to be called for each element. It should take one argument: the value of the element.
		/// @returns {List} self for chaining
		for (var _i = 0; _i < len(); _i++) {
			var _value = get(_i)
			_func(_value)
		}
		return self
	}

	static pop_last = function() {
		/// @returns {any} The last element in the list, or undefined if the list is empty
		if (len() > 0) {
			var _value = get(len() - 1)
			ds_list_delete(list, len() - 1)
			return _value
		}
		return undefined
	}

	static pop_first = function() {
		/// @returns {any} The first element in the list, or undefined if the list is empty
		if (len() > 0) {
			var _value = get(0)
			ds_list_delete(list, 0)
			return _value
		}
		return undefined
	}

	static shuffle = function() {
		/// @returns {List} self for chaining
		ds_list_shuffle(list)
		return self
	}

	static sort = function(_asc_or_func = true) {
		/// @param {bool|function} _asc_or_func if a boolean is passed, it determines whether the list is sorted in ascending (true) or descending (false) order. If a function is passed, it should take two arguments and return a negative number if the first argument should come before the second, a positive number if the first argument should come after the second, or 0 if they are equal. The function will be used to determine the order of the elements in the list.
		/// @returns {List} self for chaining
		var _arr = to_array()
		array_sort(_arr, _asc_or_func)
		ds_list_clear(list)
		for (var _i = 0; _i < array_length(_arr); _i++) {
			var _value = _arr[_i]
			ds_list_add(list, _value)
		}
		delete _arr
		return self
	}

	static toString = function() {
		/// @returns {string} String representation of the list
		var _str = "["
		for (var _i = 0; _i < len(); _i++) {
			var _value = get(_i)
			_str += string(_value)
			if (_i < len() - 1) {
				_str += ", "
			}
		}
		_str += "]"
		return _str
	}

	static str = function() {
		/// @returns {string} String representation of the list
		return toString()
	}
}

function Matrix(_x = 0, _y = 0, _z = 0, _rx = 0, _ry = 0, _rz = 0, _sx = 1, _sy = 1, _sz = 1) constructor {
	self_id = self
	x = _x
	y = _y
	z = _z
	rx = _rx
	ry = _ry
	rz = _rz
	sx = _sx
	sy = _sy
	sz = _sz
	mat = matrix_build(x, y, z, rx, ry, rz, sx, sy, sz)
	prev_mat = matrix_build_identity()

	static identify = function() {
		x = 0
		y = 0
		z = 0
		rx = 0
		ry = 0
		rz = 0
		sx = 1
		sy = 1
		sz = 1
		mat = matrix_build_identity()
		return self
	}

	static update = function() {
		mat = matrix_build(x, y, z, rx, ry, rz, sx, sy, sz)
		return self
	}

	static set_pos = function(_x, _y, _z = 0) {
		x = _x
		y = _y
		z = _z
		update()
		return self
	}

	static set_rotation = function(_rx, _ry, _rz) {
		rx = _rx
		ry = _ry
		rz = _rz
		update()
		return self
	}

	static set_scale = function(_sx, _sy, _sz) {
		sx = _sx
		sy = _sy
		sz = _sz
		update()
		return self
	}

	static get_pos_on_matrix = function(_x, _y, _z) {
		/// @returns {Struct} A struct {x, y, z} coordinates of the point (_x, _y, _z) transformed by the matrix
		return pos_on_matrix(mat, _x, _y, _z)
	}

	static multiply = function(_mat) {
		/// @param {Matrix} _mat
		mat = matrix_multiply(mat, _mat.matrix())
		return self
	}

	static move = function(_dx, _dy, _dz) {
		x += _dx
		y += _dy
		z += _dz
		update()
		return self
	}

	static rotate = function(_drx, _dry, _drz) {
		var _m = new Matrix(0, 0, 0, _drx, _dry, _drz, 1, 1, 1)
		multiply(_m)
		return self
	}

	static matrix = function() {
		return mat
	}

	static decompose = function() {
		var M = mat;
    
		// Position
		x = M[12];
		y = M[13];
		z = M[14];
		
		// Scale
		sx = point_distance_3d(0, 0, 0, M[0], M[1], M[2]);
		sy = point_distance_3d(0, 0, 0, M[4], M[5], M[6]);
		sz = point_distance_3d(0, 0, 0, M[8], M[9], M[10]);
		
		// Rotation (YXZ Order)
		var m0 = M[0]/sx, m1 = M[1]/sx, m2 = M[2]/sx;
		var m4 = M[4]/sy, m5 = M[5]/sy, m6 = M[6]/sy;
		var m8 = M[8]/sz, m9 = M[9]/sz, m10 = M[10]/sz;
		
		var _rx = arcsin(clamp(-m6, -1, 1));
		if (abs(cos(_rx)) > 0.0001) {
			ry = radtodeg(arctan2(m2, m10));
			rz = radtodeg(arctan2(m4, m5));
		} else {
			ry = 0;
			rz = radtodeg(arctan2(-m1, m0));
		}
		rx = radtodeg(_rx);
		
		return self;
	}

	static set = function() {
		prev_mat = matrix_get(matrix_world)
		matrix_set(matrix_world, mat)
		return self
	}

	static reset = function() {
		matrix_set(matrix_world, prev_mat)
		return self
	}

	static free = function() {
		delete self_id
	}

	static copy = function() {
		var _mat = new Matrix(x, y, z, rx, ry, rz, sx, sy, sz)
		_mat.mat = mat
		return _mat
	}

	static to_array = function() {
		return [x, y, z, rx, ry, rz, sx, sy, sz]
	}

	static from_array = function(_arr) {
		if (array_length(_arr) >= 9) {
			x = _arr[0]
			y = _arr[1]
			z = _arr[2]
			rx = _arr[3]
			ry = _arr[4]
			rz = _arr[5]
			sx = _arr[6]
			sy = _arr[7]
			sz = _arr[8]
			update()
		}
		return self
	}

	static toString = function() {
		return "Pos: (" + string(x) + ", " + string(y) + ", " + string(z) + "), Rot: (" + string(rx) + ", " + string(ry) + ", " + string(rz) + "), Scale: (" + string(sx) + ", " + string(sy) + ", " + string(sz) + ")"
	}


	static str = function() {
		return toString()
	}
}

function Model(_filename, _tex, _mat = new Matrix(), _model_shader_option = new ModelShaderOption()) constructor {
	self_id = self
	model = get_3d_model("Models/" + _filename)
	tex = _tex
	mat = _mat
	shader_option = _model_shader_option

	function draw(options = true) {
		if (options) {
			shader_option.set()
			mat.set()
		}
		vertex_submit(model, pr_trianglelist, tex)
		if (options) {
			shader_option.reset()
			mat.reset()
		}
	}

	function set_shader_option(_model_shader_option) {
		shader_option = _model_shader_option
	}

	function set_matrix(_mat) {
		mat = _mat
	}

	function set_texture(_tex) {
		tex = _tex
	}
}

function Camera(_index = 0) constructor {
	index = _index
	proj = noone
	view = noone

	static set_proj = function(fov, aspect, znear, zfar) {
		proj = matrix_build_projection_perspective_fov(fov, aspect, znear, zfar)
		return self
	}

	static set_proj_ortho = function(w, h, znear, zfar) {
		proj = matrix_build_projection_ortho(w, h, znear, zfar)
		return self
	}

	static set_view = function(_xfrom, _yfrom, _zfrom, _xto, _yto, _zto, _xup, _yup, _zup) {
		view = matrix_build_lookat(_xfrom, _yfrom, _zfrom, _xto, _yto, _zto, _xup, _yup, _zup)
		return self
	}

	static apply = function() {
		camera_set_proj_mat(view_camera[index], proj)
		camera_set_view_mat(view_camera[index], view)
		camera_apply(view_camera[index])
		return self
	}
}

function Path(_path) constructor {
	path = _path
	poses = new Dict()
	dirs = new Dict()

	static len = function() {
		/// @returns {real} Length of the path
		return path_get_length(path)
	}

	static get_pos = function(_ratio) {
		/// @param {real} _ratio between 0 and 1 representing the position along the path
		/// @returns {Struct} A struct {x, y} coordinates of the point at position _ratio along the path
		var _dist = _ratio * len()
		if (poses.get(_dist) == undefined) {
			var _v = new Vec2(path_get_x(path, _ratio), path_get_y(path, _ratio))
			poses.set(_dist, _v)
			return _v
		}
		else {
			return poses.get(_dist)
		}
	}

	static get_pos_dist = function(_dist) {
		/// @param {real} _dist distance along the path
		/// @returns {Struct} A struct {x, y} coordinates of the point at distance _dist along the path
		var _pos = _dist / len()
		return get_pos(_pos)
	}

	static get_dir = function(_ratio, _delta = 0.5) {
		/// @param {real} _ratio between 0 and 1 representing the position along the path
		/// @returns {Struct} A struct {x, y} representing the velocity vector at position _ratio along the path
		var _dist = _ratio * len()
		if (dirs.get(_dist) == undefined) {
			 var _dist1 = max(_dist - _delta, 0)
			var _dist2 = min(_dist + _delta, len())
			var _pos1 = get_pos_dist(_dist1)
			var _pos2 = get_pos_dist(_dist2)
			var _dir = point_direction(_pos1.x, _pos1.y, _pos2.x, _pos2.y)
			dirs.set(_dist, _dir)
			return _dir
		}
		else {
			return dirs.get(_dist)
		}
	}

	static get_dir_dist = function(_dist, _delta = 0.5) {
		/// @param {real} _dist distance along the path
		/// @returns {Struct} A struct {x, y} representing the velocity vector at distance _dist along the path
		var _pos = _dist / len()
		return get_dir(_pos, _delta)
	}

	static free = function() {
		delete poses
		delete dirs
	}
}

function Curve(_curve = undefined, _channel = "default") constructor {
	curve = _curve
	default_channel = _channel
	if (curve == undefined) {
		curve = animcurve_create()
		curve.channels = array_create(0)
		add_channel()
	}

	static get = function(_t = 0, _channel = default_channel) {
		var _c = animcurve_get_channel(curve, _channel)
		if (_c != -1) {
			return animcurve_channel_evaluate(_c, _t)
		}
		else
			return 0
	}

	static get_channel = function(_channel) {
		var _c = animcurve_get_channel(curve, _channel)
		if (_c != -1) {
			return _c
		}
		else
			return undefined
	}

	static add_channel = function(_channel_name = default_channel, _type = animcurvetype_catmullrom, _iter = 8) {
		_c = animcurve_channel_new()
		_c.name = _channel_name
		_c.type = _type
		_c.iterations = _iter
		_c.points = array_create(0)
		array_push(curve.channels, _c)
		return self
	}

	static add_point = function(_channel = default_channel, _t = 0, _value = 0) {
		var _c = get_channel(_channel)
		if (_c == undefined) {
			add_channel(_channel)
			_c = get_channel(_channel)
		}

		var _p = animcurve_point_new()
		_p.posx = _t
		_p.value = _value
		array_push(_c.points, _p)

		return self
	}
}

function Line2D(_list_points, _width = 1, _tex = undefined, _curve = undefined, _channel = "default") constructor {
	x = 0
	y = 0
	width = _width
	points = _list_points
	tex = _tex
	curve = new Curve(_curve, _channel)

	static set_pos = function(_x, _y) {
		x = _x
		y = _y
		return self
	}

	static set_texture = function(_tex) {
		tex = _tex
		return self
	}

	static set_width = function(_width) {
		width = _width
		return self
	}

	static draw = function() {
		draw_set_color(c_white)
		draw_primitive_begin_texture(pr_trianglestrip, tex)

		var _count = points.len()
		var _total_dist = 0
		var _distances = array_create(_count, 0)
		
		// 1. 전체 거리 계산 (UV 및 Curve 샘플링용)
		for (var i = 1; i < _count; i++) {
			_total_dist += points.get(i-1).dist(points.get(i))
			_distances[i] = _total_dist
		}

		for (var i = 0; i < _count; i++) {
			var _p = points.get(i)
			var _dir = 0

			// 2. 방향 벡터 계산 (시작, 끝, 중간점 처리)
			if (i == 0) {
				_dir = point_direction(_p.x, _p.y, points.get(i+1).x, points.get(i+1).y)
			} else if (i == _count - 1) {
				_dir = point_direction(points.get(i-1).x, points.get(i-1).y, _p.x, _p.y)
			} else {
				// 중간점은 이전 점과 다음 점의 평균 각도 사용
				var _d1 = point_direction(points.get(i-1).x, points.get(i-1).y, _p.x, _p.y)
				var _d2 = point_direction(_p.x, _p.y, points.get(i+1).x, points.get(i+1).y)
				_dir = _d1 + angle_difference(_d2, _d1) * 0.5
			}

			// 3. 법선 벡터(90도 회전) 및 너비 계산
			var _nx = lengthdir_x(1, _dir + 90)
			var _ny = lengthdir_y(1, _dir + 90)
			
			var _progress = _distances[i] / _total_dist // 0.0 ~ 1.0
			var _curve_val = curve.get(_progress)
			var _half_w = (width * _curve_val) * 0.5

			// 4. 정점 추가 (Triangle Strip)
			// 왼쪽 정점 (V = 0)
			draw_vertex_texture(x + _p.x + _nx * _half_w, y + _p.y + _ny * _half_w, _progress, 0)
			// 오른쪽 정점 (V = 1)
			draw_vertex_texture(x + _p.x - _nx * _half_w, y + _p.y - _ny * _half_w, _progress, 1)
		}

		draw_primitive_end()
	}
}