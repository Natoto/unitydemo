using System.Collections;
using System.Collections.Generic;
using Unity.Entities;
using UnityEngine;
using Unity.Transforms;
using Unity.Mathematics;
using Unity.Burst;



public struct TargetComponent : IComponentData
{
    public float3 target;
}

[BurstCompile]
class TargetComponentBaker : Baker<PlaceAuthoring>
{
    public override void Bake(PlaceAuthoring authoring)
    {
        var entity = GetEntity(TransformUsageFlags.None);
        AddComponent<TargetComponent>(entity, new TargetComponent
        {
            target = default(float3)
        }) ;
    }
}

public class PlaceAuthoring : MonoBehaviour
{
    //public float moveSpeed;  

}
 