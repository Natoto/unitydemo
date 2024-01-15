using System.Collections;
using System.Collections.Generic;
using RVO;
using UnityEngine;
using Vector2 = RVO.Vector2;

public class ObstacleCollect : MonoBehaviour
{
    public GameObject[] DebugPoints;
    public float rotationAngle = 0;
    void Awake()
    {
        BoxCollider[] boxColliders = GetComponentsInChildren<BoxCollider>();
        for (int i = 0; i < boxColliders.Length; i++)
        {
            //float rotationAngle = boxColliders[i].transform.localEulerAngles.y;
            Vector3 lossyScale = boxColliders[i].transform.lossyScale;
            Vector3 position = boxColliders[i].transform.position;
            float minX = position.x -
                         boxColliders[i].size.x * lossyScale.x * 0.5f; 
            float minZ = position.z -
                         boxColliders[i].size.z * lossyScale.z * 0.5f;
            float maxX = position.x +
                         boxColliders[i].size.x * lossyScale.x * 0.5f;
            float maxZ = position.z +
                         boxColliders[i].size.z*lossyScale.z*0.5f;

            

            Vector3 p1 = Quaternion.Euler(0, rotationAngle, 0) * new Vector3(minX,0, minZ);
            Vector3 p2 = Quaternion.Euler(0, rotationAngle, 0) * new Vector3(minX, 0, maxZ);
            Vector3 p3 = Quaternion.Euler(0, rotationAngle, 0) * new Vector3(maxX, 0, minZ);
            Vector3 p4 = Quaternion.Euler(0, rotationAngle, 0) * new Vector3(maxX, 0, maxZ);

            IList<Vector2> obstacle = new List<Vector2>();
            obstacle.Add(new Vector2(p1.x, p1.y));
            obstacle.Add(new Vector2(p2.x, p2.y));
            obstacle.Add(new Vector2(p3.x, p3.y));
            obstacle.Add(new Vector2(p4.x, p4.y));
            Simulator.Instance.addObstacle(obstacle);

            DebugPoints[0].transform.position = new Vector3(p1.x, 0, p1.y);
            DebugPoints[1].transform.position = new Vector3(p2.x, 0, p2.y);
            DebugPoints[2].transform.position = new Vector3(p3.x, 0, p3.y);
            DebugPoints[3].transform.position = new Vector3(p4.x, 0, p4.y);
            Debug.Log($"addobstacle {rotationAngle}  I:{i}" + $" minX:{minX} maxX:{maxX} minZ:{minZ} maxZ:{maxZ}");
        }
    }

    // Update is called once per frame
    void Update()
    {

        BoxCollider[] boxColliders = GetComponentsInChildren<BoxCollider>();
        for (int i = 0; i < boxColliders.Length; i++)
        {
            float rotationAngle = boxColliders[i].transform.localEulerAngles.y;
            Vector3 lossyScale = boxColliders[i].transform.lossyScale;
            Vector3 position = boxColliders[i].transform.position;
            //float minX = position.x -
            //             boxColliders[i].size.x * lossyScale.x * 0.5f;
            //float minZ = position.z -
            //             boxColliders[i].size.z * lossyScale.z * 0.5f;
            //float maxX = position.x +
            //             boxColliders[i].size.x * lossyScale.x * 0.5f;
            //float maxZ = position.z +
            //             boxColliders[i].size.z * lossyScale.z * 0.5f;

            float minX = -20;
            float maxX = 20;
            float minZ = -4;
            float maxZ = 4;
            Vector3 p1 = Quaternion.Euler(0, rotationAngle, 0) * new Vector3(minX, 0, minZ);
            Vector3 p2 = Quaternion.Euler(0, rotationAngle, 0) * new Vector3(minX, 0, maxZ);
            Vector3 p3 = Quaternion.Euler(0, rotationAngle, 0) * new Vector3(maxX, 0, minZ);
            Vector3 p4 = Quaternion.Euler(0, rotationAngle, 0) * new Vector3(maxX, 0, maxZ);

            //IList<Vector2> obstacle = new List<Vector2>();
            //obstacle.Add(new Vector2(p1.x, p1.y));
            //obstacle.Add(new Vector2(p2.x, p2.y));
            //obstacle.Add(new Vector2(p3.x, p3.y));
            //obstacle.Add(new Vector2(p4.x, p4.y));
            //Simulator.Instance.addObstacle(obstacle);

            DebugPoints[0].transform.position = new Vector3(p1.x, 0, p1.y);
            DebugPoints[1].transform.position = new Vector3(p2.x, 0, p2.y);
            DebugPoints[2].transform.position = new Vector3(p3.x, 0, p3.y);
            DebugPoints[3].transform.position = new Vector3(p4.x, 0, p4.y);
            Debug.Log($"addobstacle {rotationAngle}  I:{i}" + $" minX:{minX} maxX:{maxX} minZ:{minZ} maxZ:{maxZ}");
        }
    }
}