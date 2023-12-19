using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fire : MonoBehaviour
{
    public GameObject bullet;
    public GameObject target;
    private List<GameObject> bullets = new List<GameObject>();

    public float bulletSpeed = 30f;
    public int bulletCount = 10;
    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < bulletCount; i++) {
            CreateBullet();
        }
        // 获取主摄像机对象
        //Camera mainCamera = FindObjectOfType<Camera>();
        //if (mainCamera != null)
        //{
        //    mainCamera.tag = "mainCamera";
        //}
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0)) {
            CreateBullet();
        }
        if (bullets.Count > 0) {
            // 更新每颗子弹的位置
            float distanceToMove = bulletSpeed * Time.deltaTime; // 每帧移动的距离
            GameObject bt = bullets[0];

            bt.transform.LookAt(target.transform);

            bt.transform.Translate(Vector3.forward * distanceToMove);

            //Vector3 rightScreenPos = new Vector3(Camera.main.pixelWidth, Camera.main.pixelHeight, 0);  //Camera.main.ScreenToWorldPoint(new Vector3(Screen.width, Screen.height, 0));

            //Vector3 worldPos = bt.transform.position;
            //Vector3 screenPos = Camera.main.WorldToScreenPoint(worldPos);
            //Debug.Log("move " + screenPos.ToString() + "  --> " + rightScreenPos.ToString());
            Debug.Log("move " + bt.transform.position.ToString());
            if (Vector3.Distance(bt.transform.position, target.transform.position) <= 1) {
                bullets.RemoveAt(0);
                Destroy(bt);
                Debug.Log("remove ");
            }
        }

    }

    void CreateBullet()
    {
        GameObject bt = Object.Instantiate(bullet);  
        // 获取屏幕左边界的世界坐标
        Vector3 leftScreenPos = new Vector3(0,0,0); //Camera.main.ScreenToWorldPoint(new Vector3(0f, Screen.height / 2f, 10f));
        leftScreenPos.y = bullets.Count * 0.5f;
        //leftScreenPos.z = bt.GetComponent<Renderer>().bounds.size.z;
        bt.transform.position = leftScreenPos;
        bt.transform.Rotate(Vector3.forward, 0f);
        //bt.transform.localEulerAngles = new Vector3(0f, 90f, 0f);
        bullets.Add(bt);
        Debug.Log("add bt" + bt.ToString());

    }
}
