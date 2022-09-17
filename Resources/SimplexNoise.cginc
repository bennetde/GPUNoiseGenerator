#pragma once


float2 skew (float2 st) {
    float2 r = float2(0.0, 0.0);
    r.x = 1.1547*st.x;
    r.y = st.y+0.5*r.x;
    return r;
}

float3 simplexGrid (float2 st) {
    float3 xyz = float3(0.0, 0.0, 0.0);

    float2 p = frac(skew(st));
    if (p.x > p.y) {
        xyz.xy = 1.0-float2(p.x,p.y-p.x);
        xyz.z = p.y;
    } else {
        xyz.yz = 1.0-float2(p.x-p.y,p.y);
        xyz.x = p.x;
    }

    return frac(xyz);
}

