﻿#ifndef __culling_hlsl_
#define __culling_hlsl_

#include "Params.hlsl"

inline void CalculateBoundingBox(in float4x4 objectTransformMatrix, inout float4 BoundingBox[8])
{
    // Calculate clip space matrix
    float4x4 to_clip_space_mat = mul(mvpMatrix, objectTransformMatrix);
    
    float3 Min = boundsCenter - boundsExtents;
    float3 Max = boundsCenter + boundsExtents;

	// Transform all 8 corner points of the object bounding box to clip space
    BoundingBox[0] = mul(to_clip_space_mat, float4(Min.x, Max.y, Min.z, 1.0));
    BoundingBox[1] = mul(to_clip_space_mat, float4(Min.x, Max.y, Max.z, 1.0));
    BoundingBox[2] = mul(to_clip_space_mat, float4(Max.x, Max.y, Max.z, 1.0));
    BoundingBox[3] = mul(to_clip_space_mat, float4(Max.x, Max.y, Min.z, 1.0));
    BoundingBox[4] = mul(to_clip_space_mat, float4(Max.x, Min.y, Min.z, 1.0));
    BoundingBox[5] = mul(to_clip_space_mat, float4(Max.x, Min.y, Max.z, 1.0));
    BoundingBox[6] = mul(to_clip_space_mat, float4(Min.x, Min.y, Max.z, 1.0));
    BoundingBox[7] = mul(to_clip_space_mat, float4(Min.x, Min.y, Min.z, 1.0));
}

inline bool IsFrustumCulled(float4 BoundingBox[8])
{
    bool isCulled = false;
    // Test all 8 points with both positive and negative planes
    for (int i = 0; i < 3; i++)
    {
            // cull if outside positive plane:
        isCulled = isCulled ||
			(BoundingBox[0][i] > BoundingBox[0].w + frustumOffset &&
			BoundingBox[1][i] > BoundingBox[1].w + frustumOffset &&
			BoundingBox[2][i] > BoundingBox[2].w + frustumOffset &&
			BoundingBox[3][i] > BoundingBox[3].w + frustumOffset &&
			BoundingBox[4][i] > BoundingBox[4].w + frustumOffset &&
			BoundingBox[5][i] > BoundingBox[5].w + frustumOffset &&
			BoundingBox[6][i] > BoundingBox[6].w + frustumOffset &&
			BoundingBox[7][i] > BoundingBox[7].w + frustumOffset);

            // cull if outside negative plane:
        isCulled = isCulled ||
			(BoundingBox[0][i] < -BoundingBox[0].w - frustumOffset &&
			BoundingBox[1][i] < -BoundingBox[1].w - frustumOffset &&
			BoundingBox[2][i] < -BoundingBox[2].w - frustumOffset &&
			BoundingBox[3][i] < -BoundingBox[3].w - frustumOffset &&
			BoundingBox[4][i] < -BoundingBox[4].w - frustumOffset &&
			BoundingBox[5][i] < -BoundingBox[5].w - frustumOffset &&
			BoundingBox[6][i] < -BoundingBox[6].w - frustumOffset &&
			BoundingBox[7][i] < -BoundingBox[7].w - frustumOffset);
    }

    return isCulled;
}

inline float OcclusionSample(float4 BoundingRect, float LOD, float xOffset)
{ 
    // Fetch the depth texture and sample it with the bounds
    // Middle Point
    float MaxDepth = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(((BoundingRect.z - BoundingRect.x) / 2.0) + BoundingRect.x + xOffset, ((BoundingRect.w - BoundingRect.y) / 2.0) + BoundingRect.y), LOD).r;
    
    // Corner Points
    float4 Samples;
    Samples.x = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(BoundingRect.x + xOffset, BoundingRect.y), LOD).r;
    Samples.y = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(BoundingRect.x + xOffset, BoundingRect.w), LOD).r;
    Samples.z = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(BoundingRect.z + xOffset, BoundingRect.w), LOD).r;
    Samples.w = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(BoundingRect.z + xOffset, BoundingRect.y), LOD).r;
    MaxDepth = max(max(max(Samples.x, Samples.y), max(Samples.z, Samples.w)), MaxDepth);

    if (occlusionAccuracy >= 2)
    {
        // 1/4 Points
        float xShift = (BoundingRect.z - BoundingRect.x) / 4.0;
        float yShift = (BoundingRect.w - BoundingRect.y) / 4.0;
        Samples.x = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift + BoundingRect.x + xOffset, yShift + BoundingRect.y), LOD).r;
        Samples.y = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift * 3 + BoundingRect.x + xOffset, yShift + BoundingRect.y), LOD).r;
        Samples.z = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift + BoundingRect.x + xOffset, yShift * 3 + BoundingRect.y), LOD).r;
        Samples.w = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift * 3 + BoundingRect.x + xOffset, yShift * 3 + BoundingRect.y), LOD).r;
        MaxDepth = max(max(max(Samples.x, Samples.y), max(Samples.z, Samples.w)), MaxDepth);

            
        if (occlusionAccuracy >= 3)
        {
            // 1/8 Points
            xShift = (BoundingRect.z - BoundingRect.x) / 8.0;
            yShift = (BoundingRect.w - BoundingRect.y) / 8.0;
            Samples.x = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift + BoundingRect.x + xOffset, yShift + BoundingRect.y), LOD).r;
            Samples.y = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift * 7 + BoundingRect.x + xOffset, yShift + BoundingRect.y), LOD).r;
            Samples.z = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift + BoundingRect.x + xOffset, yShift * 7 + BoundingRect.y), LOD).r;
            Samples.w = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift * 7 + BoundingRect.x + xOffset, yShift * 7 + BoundingRect.y), LOD).r;
            MaxDepth = max(max(max(Samples.x, Samples.y), max(Samples.z, Samples.w)), MaxDepth);
                
            // 3/8 Points
            Samples.x = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift * 3 + BoundingRect.x + xOffset, yShift * 3 + BoundingRect.y), LOD).r;
            Samples.y = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift * 5 + BoundingRect.x + xOffset, yShift * 3 + BoundingRect.y), LOD).r;
            Samples.z = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift * 3 + BoundingRect.x + xOffset, yShift * 5 + BoundingRect.y), LOD).r;
            Samples.w = 1 - hiZMap.SampleLevel(sampler_hiZMap, float2(xShift * 5 + BoundingRect.x + xOffset, yShift * 5 + BoundingRect.y), LOD).r;
            MaxDepth = max(max(max(Samples.x, Samples.y), max(Samples.z, Samples.w)), MaxDepth);
        }
    }

    return MaxDepth;
}

inline bool IsOcclusionCulled(float4 BoundingBox[8])
{
    // NOTE: for Direct3D, the clipping space z coordinate ranges from 0 to w and for OpenGL, it ranges from -w to w. However, since we use Unity's Projection Matrix directly,
    // there is no need to worry about the difference between platforms. The projection matrix will always be left handed.
    // Also, the reversed depth value between these APIs are taken care of in the blit and compute shaders while creating the hiZ depth texture.
     
    
    for (int i = 0; i < 8; i++)
    {
        BoundingBox[i].xyz /= BoundingBox[i].w; // unscale clip depth to NDC
        BoundingBox[i].z = BoundingBox[i].z * 0.5 + 0.5; // map BB depth values back to [0, 1];
    }

    float4 BoundingRect;

    BoundingRect.x = min(min(min(BoundingBox[0].x, BoundingBox[1].x),
								    min(BoundingBox[2].x, BoundingBox[3].x)),
							    min(min(BoundingBox[4].x, BoundingBox[5].x),
								    min(BoundingBox[6].x, BoundingBox[7].x))) / 2.0 + 0.5;
    BoundingRect.y = min(min(min(BoundingBox[0].y, BoundingBox[1].y),
								    min(BoundingBox[2].y, BoundingBox[3].y)),
						        min(min(BoundingBox[4].y, BoundingBox[5].y),
								    min(BoundingBox[6].y, BoundingBox[7].y))) / 2.0 + 0.5;
    BoundingRect.z = max(max(max(BoundingBox[0].x, BoundingBox[1].x),
								    max(BoundingBox[2].x, BoundingBox[3].x)),
							    max(max(BoundingBox[4].x, BoundingBox[5].x),
								    max(BoundingBox[6].x, BoundingBox[7].x))) / 2.0 + 0.5;
    BoundingRect.w = max(max(max(BoundingBox[0].y, BoundingBox[1].y),
								    max(BoundingBox[2].y, BoundingBox[3].y)),
							    max(max(BoundingBox[4].y, BoundingBox[5].y),
                                    max(BoundingBox[6].y, BoundingBox[7].y))) / 2.0 + 0.5;

    float InstanceDepth = min(min(min(BoundingBox[0].z, BoundingBox[1].z),
									min(BoundingBox[2].z, BoundingBox[3].z)),
							   min(min(BoundingBox[4].z, BoundingBox[5].z),
									min(BoundingBox[6].z, BoundingBox[7].z)));
        // Calculate the bounding rectangle size in viewport coordinates
    float ViewSizeX = (BoundingRect.z - BoundingRect.x) * hiZTxtrSize.x;
    float ViewSizeY = (BoundingRect.w - BoundingRect.y) * hiZTxtrSize.y;
        
	    // Calculate the texture LOD used for lookup in the depth buffer texture
    float LOD = ceil(log2(max(ViewSizeX, ViewSizeY) / pow(2, occlusionAccuracy)));
    float MaxDepth = OcclusionSample(BoundingRect, LOD, 0);

    return InstanceDepth > MaxDepth + occlusionOffset;
}

inline void IsCulled(in float4x4 instanceMatrix, in float dist, out bool culled)
{
    culled = false;
    
    // Distance culling
    if (dist >= maxDistance || dist < minDistance)
    {
        culled = true;
    }

    if (!culled && dist >= minCullingDistance)
    {
        float4 BoundingBox[8];
        CalculateBoundingBox(instanceMatrix, BoundingBox);

        // OBB Frustum Culling
        if (isFrustumCulling)
        {
            culled = IsFrustumCulled(BoundingBox);
        }
    
        // Hierarchical Z-Buffer Occlusion Culling      
        if (!culled && isOcclusionCulling)
        {
            culled = IsOcclusionCulled(BoundingBox);
        }
    }
}

#endif
