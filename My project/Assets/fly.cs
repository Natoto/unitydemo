using UnityEngine;
using UnityEngine.AI;	// 导航系统需要的命名空间
using System.Collections;

//小车AI导航demo
public class fly : MonoBehaviour
{

    //public Transform TargetObject = null; //定义空物体
    private NavMeshAgent agent; //导航网格代理组件

    void Start()
    {
        // 移动到空物体所在位置
        //if (TargetObject != null)
        //{
        //    GetComponent<NavMeshAgent>().destination = TargetObject.position;
        //}
        agent = GetComponent<NavMeshAgent>();   //获取组件
    }
    void Update()
    {
        // 单击鼠标右键
        if (Input.GetMouseButtonDown(1))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);    //鼠标指针射线
            RaycastHit hit; //碰撞信息
            bool res = Physics.Raycast(ray, out hit);   //射线碰撞检测
            if (res)
            {
                Vector3 point = hit.point;  //如果检测到碰撞，获取碰撞点
                agent.SetDestination(point);    //将添加了NavMesh的物体移动到碰撞点
                Debug.Log("hit point " + point);
            }
        }
    }
}

