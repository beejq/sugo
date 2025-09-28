/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/god-rays

Feel free to use, improve and change this shader according to your needs
and consider sharing the modified result on godotshaders.com.
*/

shader_type canvas_item;

uniform int blend_mode : hint_range(1, 13) = 1;

uniform float angle : hint_range(0.0, 360.0) = 30;
uniform float position : hint_range(-1.0, 1.0) = -0.2;
uniform float spread : hint_range(0.0, 1.0) = 0.5;
uniform float cutoff : hint_range(-1.0, 1.0) = 0.1;
uniform float falloff : hint_range(0.0, 1.0) = 0.2;
uniform float edge_fade : hint_range(0.0, 1.0) = 0.15;

uniform float speed : hint_range(0.0, 20.0) = 1.0;
uniform float ray1_density : hint_range(0.0, 20.0) = 8.0;
uniform float ray2_density : hint_range(0.0, 50.0) = 30.0;
uniform float ray2_intensity : hint_range(0.0, 1.0) = 0.3;

uniform vec4 color : source_color = vec4(1.0, 0.9, 0.65, 0.8);

uniform bool hdr = false;
uniform float seed = 5.0;

// Backward compatibility
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Random and noise functions from Book of Shader's chapter on Noise.
float random(vec2 _uv) {
    _uv += min(TIME,0.0);
    return fract(sin(dot(_uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise (in vec2 uv) {
   vec2 i = floor(uv);
   vec2 f = fract(uv);

   // Four corners in 2D of a tile
   float a = random(i);
   float b = random(i + vec2(1.0, 0.0));
   float c = random(i + vec2(0.0, 1.0));
   float d = random(i + vec2(1.0, 1.0));

   // Smooth Interpolation
   // Cubic Hermine Curve. Same as SmoothStep()
   vec2 u = f * f * (3.0-2.0 * f);

   // Mix 4 coorners percentages
   return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

mat2 rotate(float _angle){
   _angle = radians(_angle);
   return mat2(vec2(cos(_angle), -sin(_angle)),
               vec2(sin(_angle), cos(_angle)));
}

vec4 blend(vec4 base, vec4 blend, int mode) {
    switch (mode) {
        case 1: //Screen
            return 1.0 - (1.0 - base) * (1.0 - blend);
        case 2: //Multiply
            return base * blend;
        case 3: //Darken
            return min(base, blend);
        case 4: //Lighten
            return max(base, blend);
        case 5: //Difference
            return abs(base - blend);
        case 6: //Exclusion
            return base + blend - 2.0 * base * blend;
        case 7: //Overlay
            vec4 limit = step(0.5, base);
            return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
        case 8: //Hard light
            vec4 limit = step(0.5, blend);
            return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
        case 9: //Soft light
            vec4 limit = step(0.5, blend);
            return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
        case 10: //Color dodge
            return base / (1.0 - blend);
        case 11: //Linear dodge
            return base + blend;
        case 12: //Color burn
            return 1.0 - (1.0 - base) / blend;
        case 13: //Linear burn
            return base + blend - 1.0;
    }
}

void fragment()
{
   // Rotate, skew and move the UVs
   vec2 transformed_uv = ( rotate(angle) * (UV - position) ) / ( (UV.y + spread) - (UV.y * spread) );

   // Animate the ray according the the new transformed UVs
   vec2 ray1 = vec2(transformed_uv.x * ray1_density + sin(TIME * 0.1 * speed) * (ray1_density * 0.2) + seed, 1.0);
   vec2 ray2 = vec2(transformed_uv.x * ray2_density + sin(TIME * 0.2 * speed) * (ray1_density * 0.2) + seed, 1.0);

   // Cut off the ray's edges
   float cut = step(cutoff, transformed_uv.x) * step(cutoff, 1.0 - transformed_uv.x);
   ray1 *= cut;
   ray2 *= cut;

   // Apply the noise pattern (i.e. create the rays)
   float rays;

   if (hdr){
      // This is not really HDR, but check this to not clamp the two merged rays making
      // their values go over 1.0. Can make for some nice effect
      rays = noise(ray1) + (noise(ray2) * ray2_intensity);
   }
   else{
      rays = clamp(noise(ray1) + (noise(ray2) * ray2_intensity), 0., 1.);
   }

   // Fade out edges
   rays *= smoothstep(0.0, falloff, (1.0 - UV.y)); // Bottom
   rays *= smoothstep(0.0 + cutoff, edge_fade + cutoff, transformed_uv.x); // Left
   rays *= smoothstep(0.0 + cutoff, edge_fade + cutoff, 1.0 - transformed_uv.x); // Right

   // Color to the rays
   vec3 shine = vec3(rays) * color.rgb;

   // Try different blending modes for a nicer effect. "Screen" is included in the code,
   // but take a look at https://godotshaders.com/snippet/blending-modes/ for more.
   // With "Screen" blend mode:
   shine = blend(texture(SCREEN_TEXTURE, SCREEN_UV), vec4(color), blend_mode).rgb;

   COLOR = vec4(shine, rays * color.a);
}