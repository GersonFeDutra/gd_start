shader_type canvas_item;

void fragment() {
	// Place fragment code here.
	if (COLOR.r + COLOR.g + COLOR.a == 3.0) {
		COLOR.a = 0.0;
	}
}
