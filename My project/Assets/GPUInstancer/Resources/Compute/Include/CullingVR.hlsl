﻿#ifndef __cullingVR_hlsl_
#define __cullingVR_hlsl_

#include "Params.hlsl"
#include "Culling.hlsl"
uniform float4x4 mvpMatrix2;

inline bool IsOcclusionCulledVR(in float4x4 instanceMatrix, in float4 BoundingBox[8])
{
    bool isCulled = false;
    
    
    // Hierarchical Z-Buffer Occlusion Culling      
    
    if (!isCulled && isOcclusionCulling)
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

        BoundingRect.x = (min(min(min(BoundingBox[0].x, BoundingBox[1].x),
								     min(BoundingBox[2].x, BoundingBox[3].x)),
							     min(min(BoundingBox[4].x, BoundingBox[5].x),
								     min(BoundingBox[6].x, BoundingBox[7].x))) / 2.0 + 0.5) * 0.5;
        BoundingRect.y = min(min(min(BoundingBox[0].y, BoundingBox[1].y),
								    min(BoundingBox[2].y, BoundingBox[3].y)),
							    min(min(BoundingBox[4].y, BoundingBox[5].y),
								    min(BoundingBox[6].y, BoundingBox[7].y))) / 2.0 + 0.5;
        BoundingRect.z = (max(max(max(BoundingBox[0].x, BoundingBox[1].x),
								     max(BoundingBox[2].x, BoundingBox[3].x)),
							     max(max(BoundingBox[4].x, BoundingBox[5].x),
								     max(BoundingBox[6].x, BoundingBox[7].x))) / 2.0 + 0.5) * 0.5;
        BoundingRect.w = max(max(max(BoundingBox[0].y, BoundingBox[1].y),
								    max(BoundingBox[2].y, BoundingBox[3].y)),
					  		    max(max(BoundingBox[4].y, BoundingBox[5].y),
                                    max(BoundingBox[6].y, BoundingBox[7].y))) / 2.0 + 0.5;

        float InstanceDepth = min(min(min(BoundingBox[0].z, BoundingBox[1].z),
									  min(BoundingBox[2].z, BoundingBox[3].z)),
							      min(min(BoundingBox[4].z, BoundingBox[5].z),
									  min(BoundingBox[6].z, BoundingBox[7].z)));
        
	    // Calculate the bounding rectangle size in viewport coordinates
        float ViewSizeX = (BoundingRect.z - BoundingRect.x) * hiZTxtrSize.x * 0.5;
        float ViewSizeY = (BoundingRect.w - BoundingRect.y) * hiZTxtrSize.y;
        
	    // Calculate the texture LOD used for lookup in the depth buffer texture
        float LOD = ceil(log2(max(ViewSizeX, ViewSizeY) / pow(2, occlusionAccuracy)));
        float MaxDepth = OcclusionSample(BoundingRect, LOD, 0);

        isCulled = InstanceDepth > MaxDepth + occlusionOffset;
        
        if (isCulled)
        {
            float4x4 to_clip_space_mat2 = mul(mvpMatrix2, instanceMatrix); // Calculate clip space matrix
    
            float3 Min = boundsCenter - boundsExtents;
            float3 Max = boundsCenter + boundsExtents;

            float4 BoundingBox2[8];
            BoundingBox2[0] = mul(to_clip_space_mat2, float4(Min.x, Max.y, Min.z, 1.0));
            BoundingBox2[1] = mul(to_clip_space_mat2, float4(Min.x, Max.y, Max.z, 1.0));
            BoundingBox2[2] = mul(to_clip_space_mat2, float4(Max.x, Max.y, Max.z, 1.0));
            BoundingBox2[3] = mul(to_clip_space_mat2, float4(Max.x, Max.y, Min.z, 1.0));
            BoundingBox2[4] = mul(to_clip_space_mat2, float4(Max.x, Min.y, Min.z, 1.0));
            BoundingBox2[5] = mul(to_clip_space_mat2, float4(Max.x, Min.y, Max.z, 1.0));
            BoundingBox2[6] = mul(to_clip_space_mat2, float4(Min.x, Min.y, Max.z, 1.0));
            BoundingBox2[7] = mul(to_clip_space_mat2, float4(Min.x, Min.y, Min.z, 1.0));

            for (int j = 0; j < 8; j++)
            {
                BoundingBox2[j].xyz /= BoundingBox2[j].w; // unscale clip depth to NDC
                BoundingBox2[j].z = BoundingBox2[j].z * 0.5 + 0.5; // map BB depth values back to [0, 1];
            }

            float4 BoundingRect2;

            BoundingRect2.x = (min(min(min(BoundingBox2[0].x, BoundingBox2[1].x),
								          min(BoundingBox2[2].x, BoundingBox2[3].x)),
							          min(min(BoundingBox2[4].x, BoundingBox2[5].x),
								          min(BoundingBox2[6].x, BoundingBox2[7].x))) / 2.0 + 0.5) * 0.5;
            BoundingRect2.y = min(min(min(BoundingBox2[0].y, BoundingBox2[1].y),
								         min(BoundingBox2[2].y, BoundingBox2[3].y)),
							         min(min(BoundingBox2[4].y, BoundingBox2[5].y),
								         min(BoundingBox2[6].y, BoundingBox2[7].y))) / 2.0 + 0.5;
            BoundingRect2.z = (max(max(max(BoundingBox2[0].x, BoundingBox2[1].x),
								          max(BoundingBox2[2].x, BoundingBox2[3].x)),
							          max(max(BoundingBox2[4].x, BoundingBox2[5].x),
								          max(BoundingBox2[6].x, BoundingBox2[7].x))) / 2.0 + 0.5) * 0.5;
            BoundingRect2.w = max(max(max(BoundingBox2[0].y, BoundingBox2[1].y),
								         max(BoundingBox2[2].y, BoundingBox2[3].y)),
							         max(max(BoundingBox2[4].y, BoundingBox2[5].y),
                                         max(BoundingBox2[6].y, BoundingBox2[7].y))) / 2.0 + 0.5;

            InstanceDepth = min(min(min(BoundingBox2[0].z, BoundingBox2[1].z),
									min(BoundingBox2[2].z, BoundingBox2[3].z)),
							    min(min(BoundingBox2[4].z, BoundingBox2[5].z),
									min(BoundingBox2[6].z, BoundingBox2[7].z)));
        
            // Calculate the bounding rectangle size in viewport coordinates
            ViewSizeX = (BoundingRect2.z - BoundingRect2.x) * hiZTxtrSize.x * 0.5;
            ViewSizeY = (BoundingRect2.w - BoundingRect2.y) * hiZTxtrSize.y;
        
	        // Calculate the texture LOD used for lookup in the depth buffer texture
            LOD = ceil(log2(max(ViewSizeX, ViewSizeY) / pow(2, occlusionAccuracy)));
            MaxDepth = OcclusionSample(BoundingRect2, LOD, 0.5);

            isCulled = InstanceDepth > MaxDepth + occlusionOffset;
        }
    
    }

    return isCulled;
}

inline void IsCulledVR(in float4x4 instanceMatrix, in float dist, out bool culled)
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
            culled = IsOcclusionCulledVR(instanceMatrix, BoundingBox);
        }
    }
    
    
}

#endif
