using System.Collections;
using System.Collections.Generic;
using Unity.Entities;
using UnityEngine;
using Unity.Transforms;
using Unity.Mathematics;
using Unity.Burst;

 
// -------------------------------------------------------------

public class moveAuthoring : MonoBehaviour
{
    //public float moveSpeed; 
}


struct MoveComponentData : IComponentData {
    public float moveSpeed;
}

[BurstCompile]
class moveBaker : Baker<moveAuthoring>
{
    public override void Bake(moveAuthoring authoring)
    {
        var entity = GetEntity(TransformUsageFlags.None);
        AddComponent<MoveComponentData>(entity, new MoveComponentData
        {
            //moveSpeed = authoring.moveSpeed
        }); 
    }
}


partial struct MoveSystem : ISystem {

    void OnCreate(ref SystemState state) {
        state.RequireForUpdate<MoveComponentData>();
        state.RequireForUpdate<TargetComponent>();
    }

    [BurstCompile]
    void OnUpdate(ref SystemState state)
    {
        float3 targetPosition = float3.zero;

        foreach (var target in SystemAPI.Query<RefRW<TargetComponent>>())
        {
            targetPosition = target.ValueRO.target;
        }
        //Debug.Log("targetPosition");
        foreach (var (transform, move) in SystemAPI.Query<RefRW<LocalTransform>, RefRO<MoveComponentData>>())
        {

            float3 direction = math.normalize(targetPosition - transform.ValueRO.Position);

            float speed = move.ValueRO.moveSpeed * Time.deltaTime;
            transform.ValueRW =  transform.ValueRO.Translate(direction * speed); 
        }
    }
}