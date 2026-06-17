shader_type canvas_item;

uniform bool active = false;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(flash_color.rgb, previous_color.a);
	
	if (active == true) {
		COLOR = white_color;
	} else {
		COLOR = previous_color;
	}
}
