using System.Collections;
using System.Collections.Generic;
using Unity.Burst;
using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;
using UnityEngine;

public class EntitiesAuthoring : MonoBehaviour
{
    public GameObject m_Prefab;
    public int m_Row;
    public int m_Col;
    public float m_moveSpeed;
}


//转换为Entity
//创建一个继承自Baker的脚本，用于将Authoring脚本中的参数转接到自定义的ComponentData中[1]。
//示例代码如下：

class EntitiesAuthoringBaker : Baker<EntitiesAuthoring>
{
    public override void Bake(EntitiesAuthoring authoring)
    {
        var entity = GetEntity(TransformUsageFlags.None);
        AddComponent<EntitiesComponentData>(entity, new EntitiesComponentData
        {
            m_PrefabEntity = GetEntity(authoring.m_Prefab, TransformUsageFlags.Dynamic | TransformUsageFlags.Renderable),
            m_Row = authoring.m_Row,
            m_Col = authoring.m_Col,
            m_moveSpeed = authoring.m_moveSpeed,
        });
    }
}

struct EntitiesComponentData : IComponentData
{
    public Entity m_PrefabEntity;
    public int m_Row;
    public int m_Col;
    public float m_moveSpeed;
}


//创建Entity的System脚本
//创建一个System脚本，用于创建Entity并设置其属性[1]。
//示例代码如下：

[BurstCompile]
partial struct SpawnEntitiesSystem : ISystem
{
    void OnCreate(ref SystemState state)
    {
        state.RequireForUpdate<EntitiesComponentData>();
        //state.RequireForUpdate<MoveComponentData>();
    }

    void OnUpdate(ref SystemState state)
    {
        var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
        var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);
        Debug.Log("SpawnEntitiesSystem update ");
        foreach (var data in SystemAPI.Query<EntitiesComponentData>())
        {
            var scale = 0.5f;
            var halfSize = new float2(data.m_Col * scale, data.m_Row * scale);
            for (int i = 0; i < data.m_Row; i++)
            {
                for (int j = 0; j < data.m_Col; j++)
                {
                    var entity = state.EntityManager.Instantiate(data.m_PrefabEntity);
                    ecb.SetComponent(entity, LocalTransform.FromPosition(new float3(j - halfSize.x, 0, i - halfSize.y)));
                    ecb.AddComponent<MoveComponentData>(entity, new MoveComponentData() { moveSpeed = data.m_moveSpeed * UnityEngine.Random.Range(1, 30) });
                    //ecb.AddComponent<TargetComponent>(entity, new TargetComponent() { });
                }
            }
        }
        state.Enabled = false;
    }
}