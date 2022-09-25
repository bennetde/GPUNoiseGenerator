#pragma once

uint pcg(const uint input, uint seed = 2891336453u)
{
    const uint state = input * 747796405u + seed;
    const uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    return (word >> 22u) ^ word;
}

uint2 pcg2d(uint2 v, uint seed = 1013904223u)
{
    v = v * 1664525u + seed;

    v.x += v.y * 1664525u;
    v.y += v.x * 1664525u;

    v = v ^ (v>>16u);

    v.x += v.y * 1664525u;
    v.y += v.x * 1664525u;

    v = v ^ (v>>16u);

    return v;
}

// // http://www.jcgt.org/published/0009/03/02/
// uint3 pcg3d(uint3 v, uint seed = 1013904223u) {
//
//     v = v * 1664525u + seed;
//
//     v.x += v.y*v.z;
//     v.y += v.z*v.x;
//     v.z += v.x*v.y;
//
//     v ^= v >> 16u;
//
//     v.x += v.y*v.z;
//     v.y += v.z*v.x;
//     v.z += v.x*v.y;
//
//     return v;
// }

// http://www.jcgt.org/published/0009/03/02/
int3 pcg3d(int3 v, uint seed = 1013904223u) {

    v = v * 1664525u + seed;

    v.x += v.y*v.z;
    v.y += v.z*v.x;
    v.z += v.x*v.y;

    v ^= v >> 16u;

    v.x += v.y*v.z;
    v.y += v.z*v.x;
    v.z += v.x*v.y;

    return v;
}

float3 prng(float3 p, uint seed = 1013904223u)
{
    return pcg3d(asint(p), seed) * (1.0/float(0xffffffffu));
}

float2 prng(float2 p, uint seed = 1013904223u)
{
    return pcg2d(asuint(p), seed) * (1.0/float(0xffffffffu));
}