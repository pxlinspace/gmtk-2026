shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_opaque, cull_back;

uniform sampler2D base_texture : source_color, filter_nearest;
uniform vec2 direction = vec2(.0, .5);
uniform float offset : hint_range(0., 10.);
uniform float fade : hint_range(0., 10.);
uniform float strip = 4.;

void fragment() {
	vec2 norm = normalize(direction);
	
	// Calculate screen-space pixels in 3D
	vec2 pixels = SCREEN_UV * VIEWPORT_SIZE;
	
	vec2 pdir = vec2(norm.y, -norm.x);
	vec2 corrected_uv = UV + ((float(int(dot(pdir, pixels) / strip) & 0x1) * 2.) - 1.) * offset * pdir;
	
	// Sample using the spatial texture sampler
	vec4 color = texture(base_texture, corrected_uv);
	color.a *= clamp(1. - offset/fade, 0., 1.);
	
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
