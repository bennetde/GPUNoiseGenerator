#pragma once
#include "Hash.cginc"

// fade and fbm function adapted from https://adrianb.io/2014/08/09/perlinnoise.html
float fade(float t)
{
    return t * t * t * (t * (t * 6 - 15) + 10); 
}

// grad function from http://riven8192.blogspot.com/2010/08/calculate-perlinnoise-twice-as-fast.html
float grad(uint hash, float2 pos)
{
    switch(hash & 0xF)
    {
        case 0x0: return  pos.x + pos.y;
        case 0x1: return -pos.x + pos.y;
        case 0x2: return  pos.x - pos.y;
        case 0x3: return -pos.x - pos.y;
        case 0x4: return  pos.y + pos.x;
        case 0x5: return  pos.y - pos.x;
        case 0x6: return  pos.x + pos.y;
        case 0x7: return -pos.x + pos.y;
        case 0x8: return  pos.x - pos.y;
        case 0x9: return -pos.x - pos.y;
        case 0xA: return  pos.y + pos.x;
        case 0xB: return  pos.y - pos.x;
        case 0xC: return  pos.x + pos.y;
        case 0xD: return -pos.x + pos.y;
        case 0xE: return  pos.x - pos.y;
        case 0xF: return -pos.x - pos.y;
        default: return 0;
    }
}
// Source: http://riven8192.blogspot.com/2010/08/calculate-perlinnoise-twice-as-fast.html
float grad(uint2 hash, float2 pos)
{
    switch((hash.x ^ hash.y) & 0xF)
    {
        case 0x0: return  pos.x + pos.y;
        case 0x1: return -pos.x + pos.y;
        case 0x2: return  pos.x - pos.y;
        case 0x3: return -pos.x - pos.y;
        case 0x4: return  pos.y + pos.x;
        case 0x5: return  pos.y - pos.x;
        case 0x6: return  pos.x + pos.y;
        case 0x7: return -pos.x + pos.y;
        case 0x8: return  pos.x - pos.y;
        case 0x9: return -pos.x - pos.y;
        case 0xA: return  pos.y + pos.x;
        case 0xB: return  pos.y - pos.x;
        case 0xC: return  pos.x + pos.y;
        case 0xD: return -pos.x + pos.y;
        case 0xE: return  pos.x - pos.y;
        case 0xF: return -pos.x - pos.y;
        default: return 0;
    }
}

float grad3d(int hash, float3 pos)
{
    switch(hash & 0xF)
    {
        case 0x0: return  pos.x + pos.y;
        case 0x1: return -pos.x + pos.y;
        case 0x2: return  pos.x - pos.y;
        case 0x3: return -pos.x - pos.y;
        case 0x4: return  pos.x + pos.z;
        case 0x5: return -pos.x + pos.z;
        case 0x6: return  pos.x - pos.z;
        case 0x7: return -pos.x - pos.z;
        case 0x8: return  pos.y + pos.z;
        case 0x9: return -pos.y + pos.z;
        case 0xA: return  pos.y - pos.z;
        case 0xB: return -pos.y - pos.z;
        case 0xC: return  pos.y + pos.x;
        case 0xD: return -pos.y + pos.z;
        case 0xE: return  pos.y - pos.x;
        case 0xF: return -pos.y - pos.z;
        default: return 0; // never happens
    }
}

float grad3d(int3 hash, float3 pos)
{
    switch((hash.x ^ hash.y ^ hash.z) & 0xF)
    {
        case 0x0: return  pos.x + pos.y;
        case 0x1: return -pos.x + pos.y;
        case 0x2: return  pos.x - pos.y;
        case 0x3: return -pos.x - pos.y;
        case 0x4: return  pos.x + pos.z;
        case 0x5: return -pos.x + pos.z;
        case 0x6: return  pos.x - pos.z;
        case 0x7: return -pos.x - pos.z;
        case 0x8: return  pos.y + pos.z;
        case 0x9: return -pos.y + pos.z;
        case 0xA: return  pos.y - pos.z;
        case 0xB: return -pos.y - pos.z;
        case 0xC: return  pos.y + pos.x;
        case 0xD: return -pos.y + pos.z;
        case 0xE: return  pos.y - pos.x;
        case 0xF: return -pos.y - pos.z;
        default: return 0; // never happens
    }
}

float perlin_noise(float2 pos, uint seed)
{
    uint2 bottomLeft = uint2(pos);                              // aaa
    float2 fPos = frac(pos);
    
    uint2 bottomRight = uint2(bottomLeft.x+1, bottomLeft.y);    // baa
    uint2 topLeft = uint2(bottomLeft.x, bottomLeft.y+1);        // aba
    uint2 topRight = uint2(bottomLeft.x+1, bottomLeft.y+1);     // bba

    float u = fade(fPos.x);
    float v = fade(fPos.y);
    
    uint2 hashBL = pcg2d(bottomLeft, seed);
    uint2 hashBR = pcg2d(bottomRight, seed);
    uint2 hashTL = pcg2d(topLeft, seed);
    uint2 hashTR = pcg2d(topRight, seed);

    float x1 = lerp(grad(hashBL, fPos), grad(hashBR, float2(fPos.x-1, fPos.y)), u);
    float x2 = lerp(grad(hashTL, float2(fPos.x, fPos.y-1)), grad(hashTR, float2(fPos.x-1, fPos.y-1)), u);

    float res = lerp(x1,x2,v);
    
    return res+1.0/2;
}

float perlin_noise3d(float3 pos, float repeat, uint seed)
{
    int3 aaa = uint3(pos);
    // modf(int3(pos), aaa);
    const float3 fPos = frac(pos);
    
    const int3 hashAAA = pcg3d(fmod(aaa, repeat), seed); //aaa
    const int3 hashABA = pcg3d(fmod(int3(aaa.x, aaa.y+1, aaa.z), repeat), seed);
    const int3 hashAAB = pcg3d(fmod(int3(aaa.x, aaa.y, aaa.z+1), repeat), seed);
    const int3 hashABB = pcg3d(fmod(int3(aaa.x, aaa.y+1, aaa.z+1),repeat), seed);
    const int3 hashBAA = pcg3d(fmod(int3(aaa.x+1, aaa.y, aaa.z), repeat), seed);
    const int3 hashBBA = pcg3d(fmod(int3(aaa.x+1, aaa.y+1, aaa.z), repeat), seed);
    const int3 hashBAB = pcg3d(fmod(int3(aaa.x+1, aaa.y, aaa.z+1), repeat), seed);
    const int3 hashBBB = pcg3d(fmod(int3(aaa.x+1, aaa.y+1, aaa.z+1),repeat), seed);

    const float u = fade(fPos.x);
    const float v = fade(fPos.y);
    const float w = fade(fPos.z);

    float x1 = lerp(grad3d(hashAAA, fPos), grad3d(hashBAA, float3(fPos.x-1, fPos.y, fPos.z)), u);
    float x2 = lerp(grad3d(hashABA, float3(fPos.x, fPos.y-1, fPos.z)), grad3d(hashBBA, float3(fPos.x-1, fPos.y-1, fPos.z)), u);
    float y1 = lerp(x1,x2,v);

    x1 = lerp(grad3d(hashAAB, float3(fPos.x, fPos.y, fPos.z-1)), grad3d(hashBAB, float3(fPos.x-1, fPos.y, fPos.z-1)), u);
    x2 = lerp(grad3d(hashABB, float3(fPos.x, fPos.y-1, fPos.z-1)), grad3d(hashBBB, float3(fPos.x-1, fPos.y-1, fPos.z-1)), u);
    float y2 = lerp(x1,x2,v);
    
    return (lerp (y1, y2, w)+1.0)/2.0;
}

float fbm(float2 pos, uint octaves, float persistence, uint seed)
{
    float total = 0;
    float frequency = 1;
    float amplitude = 1;
    float maxValue = 0;
    for(uint i = 0; i < octaves; i++)
    {
        total += perlin_noise(pos * frequency, seed) * amplitude;
        maxValue += amplitude;
        amplitude *= persistence;
        frequency *= 2;
    }

    return total/maxValue;
}

float fbm3d(float3 pos, uint octaves, float persistence, float tiling, uint seed)
{
    float total = 0;
    uint frequency = 1;
    float amplitude = 1;
    float maxValue = 0;
    for(uint i = 0; i < octaves; i++)
    {
        total += perlin_noise3d(pos * frequency, tiling * frequency, seed) * amplitude;
        maxValue += amplitude;
        amplitude *= persistence;
        frequency *= 2;
    }

    return total/maxValue;
}
