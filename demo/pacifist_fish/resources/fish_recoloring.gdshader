shader_type canvas_item;

void fragment() {
	if (COLOR.r > 0.9 && COLOR.g > 0.33) {
		COLOR.b *= 5.;
	}
}
