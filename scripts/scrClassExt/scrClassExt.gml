function BloomShader(_downsampling = 2) constructor {
	shd = shdBloom
	surf_h = -1
	surf_v = -1
	downsampling = _downsampling
	so = new ShaderOption(shd)
		.set_smooth(true)
	intensity = 1

	static set_downsampling = function(_downsampling) {
		downsampling = _downsampling
		return self
	}

	static set_intensity = function(_intensity) {
		intensity = _intensity
		return self
	}
	
	static draw = function(_surf) {
		var _w = surface_get_width(_surf) / downsampling
		var _h = surface_get_height(_surf) / downsampling
		var _scale = 1 / downsampling
		so.set_uniform("u_resolution", [_w, _h])

		if (surf_h != -1) {
			surface_free(surf_h)
		}
		surf_h = surface_create(_w, _h)

		surface_set_target(surf_h)
		draw_clear_alpha(c_black, 0)
		so.set_uniform("u_direction", 0).set()
		draw_surface_ext(_surf, 0, 0, _scale, _scale, 0, c_white, 1)
		so.reset()
		surface_reset_target()

		if (surf_v != -1) {
			surface_free(surf_v)
		}
		surf_v = surface_create(_w, _h)

		surface_set_target(surf_v)
		draw_clear_alpha(c_black, 0)
		so.set_uniform("u_direction", 1).set()
		draw_surface(surf_h, 0, 0)
		so.reset()
		surface_reset_target()

		gpu_set_blendmode(bm_add)
		draw_surface_ext(surf_v, 0, 0, downsampling, downsampling, 0, c_white, intensity)
		gpu_set_blendmode(bm_normal)
	}

	static free = function() {
		if (surf_h != -1) {
			surface_free(surf_h)
		}
		if (surf_v != -1) {
			surface_free(surf_v)
		}
		so.free()
	}
}

function DistortCircularShader() constructor {
	shd = shdDistortCircular
	so = new ShaderOption(shd)
		.set_smooth(false)
		.set_uniform("u_frequency", 5.0)
		.set_uniform("u_strength", 5.0)

	static set_resolution = function(_width, _height) {
		so.set_uniform("u_resolution", [_width, _height])
		return self
	}

	static set_center = function(_center = new Vec2(0, 0)) {
		so.set_uniform("u_center", _center.to_array())
		return self
	}

	static set_intensity = function(_intensity) {
		so.set_uniform("u_intensity", _intensity)
		return self
	}

	static set_frequency = function(_frequency) {
		so.set_uniform("u_frequency", _frequency)
		return self
	}

	static set_strength = function(_strength) {
		so.set_uniform("u_strength", _strength)
		return self
	}
	
	static set = function() {
		so.set_uniform("u_time", get_time())
		so.set()
	}

	static reset = function() {
		so.reset()
	}

	static free = function() {
		so.free()
	}
}

function DrawOption() constructor {
	self_id = self
	col = noone
	alpha = noone
	h_align = noone
	v_align = noone
	font = noone

	static set_color = function(_color) {
		col = _color
		return self
	}
	
	static set_alpha = function(_alpha) {
		alpha = _alpha
		return self
	}

	static set_align = function(_h_align = -1, _v_align = -1) {
		if (_h_align < 0) h_align = fa_left
		else if (_h_align == 0) h_align = fa_center
		else h_align = fa_right

		if (_v_align < 0) v_align = fa_top
		else if (_v_align == 0) v_align = fa_middle
		else v_align = fa_bottom

		return self
	}

	static set_font = function(_font) {
		font = _font
		return self
	}

	static set = function() {
		if (col != noone) draw_set_color(col)
		if (alpha != noone) draw_set_alpha(alpha)
		if (h_align != noone || v_align != noone) draw_set_halign(h_align); draw_set_valign(v_align)
		if (font != noone) draw_set_font(font)
		return self
	}

	static reset = function() {
		if (col != noone) draw_set_color(c_white)
		if (alpha != noone) draw_set_alpha(1)
		if (h_align != noone) draw_set_halign(fa_left)
		if (v_align != noone) draw_set_valign(fa_top)
		if (font != noone) draw_set_font(fDefault12)
		return self
	}

	static free = function() {
		col = noone
		alpha = noone
		h_align = noone
		v_align = noone
		font = noone
		return self_id
	}
}