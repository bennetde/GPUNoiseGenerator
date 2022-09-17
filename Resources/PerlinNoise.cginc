#pragma once
#include "Hash.cginc"

int repeat = -1;

float fade(float t)
{
    return t * t * t * (t * (t * 6 - 15) + 10); 
}

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
        default: return 0; // never happens
    }
}

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
    default: return 0; // never happens
    }
}

float perlin_noise(float2 pos, uint seed)
{
    uint2 bottomLeft = uint2(pos); //aaa
    float2 fPos = frac(pos);
    
    uint2 bottomRight = uint2(bottomLeft.x+1, bottomLeft.y); //baa
    uint2 topLeft = uint2(bottomLeft.x, bottomLeft.y+1); // aba
    uint2 topRight = uint2(bottomLeft.x+1, bottomLeft.y+1); // bba

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
