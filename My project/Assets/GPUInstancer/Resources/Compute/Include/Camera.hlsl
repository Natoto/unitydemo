﻿#ifndef __camera_hlsl_
#define __camera_hlsl_

#include "Params.hlsl"

inline void CalculateDistanceAndSize(float4x4 instanceMatrix, out float dist, out float maxViewSize)
{
    dist = 0;
    maxViewSize = 0;
    
    float3 scale = float3(length(instanceMatrix._11_12_13), length(instanceMatrix._21_22_23), length(instanceMatrix._31_32_33));
    dist = abs(distance(instanceMatrix._14_24_34, camPos));
    maxViewSize = max(max(boundsExtents.x * scale.x, boundsExtents.y * scale.y), boundsExtents.z * scale.z) / (dist * halfAngle * 2);
}

inline void CalculateLODNo(float size, float distance, bool isCulled, out uint lodNo, out uint shadowLodNo)
{
    lodNo = 9;
    shadowLodNo = 9;
    for (uint i = 0; i < lodCount; i++)
    {
        if (size > lodSizes[i / 4][i % 4])
        {
            if (!isCulled)
                lodNo = i;
            if (distance < shadowDistance && (!cullShadows || !isCulled))
                shadowLodNo = shadowLODMap[i / 4][i % 4];
            break;
        }
    }
}

inline void CalculateCFLODNo(float size, uint lodNo, out uint cfLodNo, out uint fadeLevel)
{
    cfLodNo = 9;
    fadeLevel = 0;

    uint row = lodNo / 4 + 2;
    uint column = lodNo % 4;
    float fadeAmount;
    
    if (size < lodSizes[row][column])
    {
        fadeAmount = (lodSizes[row][column] - size) / (lodSizes[row][column] - lodSizes[row - 2][column]);
        fadeLevel = 15 - floor(fadeAmount * fadeAmount * 15.0f);
        if (fadeLevel == 8)
            fadeLevel++;
        if (fadeLevel < 15)
            cfLodNo = lodNo + 1;
    }
}

inline void CalculateCFLODNoAnimate(uint oldLodNo, uint lodNo, inout uint cfLodNo, inout uint fadeLevel)
{
    if (oldLodNo < 9 && lodNo < 9 && oldLodNo != lodNo)
    {
        fadeLevel = 100;
        cfLodNo = oldLodNo;
    }
    else if (fadeLevel > 0)
    {
        fadeLevel += uint(deltaTime * 2500) + 1;
    }

    if (fadeLevel < 100 || fadeLevel >= 1500)
    {
        cfLodNo = 9;
        fadeLevel = 0;
    }
}
#endif
