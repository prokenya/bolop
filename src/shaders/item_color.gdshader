shader_type canvas_item;

uniform vec4 target_collor:source_color;
uniform vec4 set_collor:source_color;
void fragment() {
    if (distance(target_collor, COLOR) <= 0.1) {
        COLOR = set_collor;
    }
}

