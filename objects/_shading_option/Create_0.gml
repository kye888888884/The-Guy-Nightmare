light_dir = [0, 0, 1]
light_col = [1, 1, 1, 1]
ambient = 0.5

normal = 0
sample_normal = noone

roughness = 0
sample_roughness = noone

ao = 0
sample_ao = noone

specular = 0
sample_specular = noone

function set_light_dir(_xdir, _ydir, _zdir) {
    light_dir = [_xdir, _ydir, _zdir]
    return id
}

function set_light_col(_r, _g, _b, _a) {
    light_col = [_r, _g, _b, _a]
    return id
}

function set_ambient(_ambient) {
    ambient = _ambient
    return id
}

function set_normal(_normal_strength, _tex_normal = noone) {
    normal = _normal_strength
    if (normal == 0) sample_normal = noone
    else if (_tex_normal != noone)
        sample_normal = _tex_normal
    return id
}

function set_roughness(_roughness_strength, _tex_roughness = noone) {
    roughness = _roughness_strength
    if (roughness == 0) sample_roughness = noone
    else if (_tex_roughness != noone)
        sample_roughness = _tex_roughness
    return id
}

function set_ao(_ao_strength, _tex_ao = noone) {
    ao = _ao_strength
    if (ao == 0) sample_ao = noone
    else if (_tex_ao != noone)
        sample_ao = _tex_ao
    return id
}

function set_specular(_specular_strength, _tex_specular = noone) {
    specular = _specular_strength
    if (specular == 0) sample_specular = noone
    else if (_tex_specular != noone)
        sample_specular = _tex_specular
    return id
}

function get_option() {
    return {
        light_dir: light_dir,
        light_col: light_col,
        ambient: ambient,
        normal: normal,
        roughness: roughness,
        ao: ao,
        specular: specular,
        sample_normal: sample_normal,
        sample_roughness: sample_roughness,
        sample_ao: sample_ao,
        sample_specular: sample_specular
    }    
}

function free() {
    instance_destroy()
}