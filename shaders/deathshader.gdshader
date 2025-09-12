shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0); // animate this

uniform vec2 block_size = vec2(16.0, 16.0); // size of pixel blocks

void fragment() {
    // turn screen coords into blocky grid
    vec2 uv = floor(FRAGCOORD.xy / block_size);

    // generate pseudo-random per-block value
    float rnd = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);

    // compare random value to progress
    if (rnd < progress) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // block visible
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0); // transparent
    }
}
