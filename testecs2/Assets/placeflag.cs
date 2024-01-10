using System.Collections;
using System.Collections.Generic;
using Unity.Burst;
using Unity.Collections;
using Unity.Entities;
using Unity.Mathematics;
using UnityEngine;




public class placeflag : MonoBehaviour
{
    private Ray _ray;
    private RaycastHit _hit;  
    public int number;

    private EntityQuery m_EntityQuery;



    private void LateUpdate()
    {
        // 更新当前的位置到组件targetcomponent
        var entityManager = World.DefaultGameObjectInjectionWorld.EntityManager;
        var entity = entityManager.CreateEntityQuery(typeof(TargetComponent)).GetSingletonEntity();
        var transform = this.gameObject.transform;
        float3 position = new float3(transform.position.x, transform.position.y, transform.position.z);
        var targetComponent = entityManager.GetComponentData<TargetComponent>(entity);
        targetComponent.target = position; 
        entityManager.SetComponentData(entity, targetComponent);
    }
     
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log("update placeflag");
        if (Input.GetMouseButtonDown(0)) {
            _ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(_ray, out _hit, Mathf.Infinity)) {
                this.gameObject.transform.position = _hit.point;
            }
        }
    }
}
