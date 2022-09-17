#pragma once
#include "Hash.cginc"
float2 random(float2 uv) {
	return float2(frac(sin(dot(uv.xy, float2(12.9898,78.233))) * 43758.5453123), frac(sin(dot(uv.xy, float2(12.9898,78.233))) * 43758.5453123));
}

float worley(float2 uv, float columns, float rows, uint seed) {
	
    float2 index_uv = floor(float2(uv.x * columns, uv.y * rows));
    float2 fract_uv = frac(float2(uv.x * columns, uv.y * rows));
	
    float minimum_dist = 1.0;  
	
    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            float2 neighbor = float2(float(x),float(y));
            float2 point2 = prng(index_uv + neighbor, seed);
			
            float2 diff = neighbor + point2 - fract_uv;
            float dist = length(diff);
            minimum_dist = min(minimum_dist, dist);
        }
    }
	
    return minimum_dist;
}

float2 voronoi(float2 uv, float columns, float rows, uint seed) {
	
	float2 index_uv = floor(float2(uv.x * columns, uv.y * rows));
	float2 fract_uv = frac(float2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	float2 minimum_point;

	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			float2 neighbor = float2(float(x),float(y));
			float2 point2 = prng(index_uv + neighbor, seed);

			float2 diff = neighbor + point2 - fract_uv;
			float dist = length(diff);
			
			if(dist < minimum_dist) {
				minimum_dist = dist;
				minimum_point = point2;
			}
		}
	}
	return minimum_point;
}