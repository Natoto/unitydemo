using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class gun : MonoBehaviour
{
    public GameObject bullet;
    //public GameObject target;
    public Transform paotongTrans;
    private List<GameObject> bullets = new List<GameObject>();

    public float bulletSpeed = 30f;
    public float bulletForword = 0f;
    public int bulletCount = 30;
    public float bulletFlyMaxDistance = 50f;
    public float bulletScale = 1.0f;
    // Start is called before the first frame update
    void Start()
    {
        Application.targetFrameRate = 60;
        //for (int i = 0; i < bulletCount; i++)
        //{
        //    CreateBullet();
        //}

        //2s后触发，每隔1s调用一次CreateBullet
        InvokeRepeating("CreateBullet", 2, 0.1f);
         
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            CreateBullet();
        }
        if (bullets.Count > 0)
        {
            // 更新每颗子弹的位置
            float distanceToMove = bulletSpeed * Time.deltaTime; // 每帧移动的距离

            int count = bullets.Count;
            for (int idx = 0; idx < count; idx++) {
                GameObject bt = bullets[idx];
                if (bt.transform.position == Vector3.zero) { 
                    bt.transform.localEulerAngles = targetTrans().localEulerAngles;

                    bt.transform.position = paotongTrans.position  + Vector3.forward * bulletForword;
                    bt.SetActive(true);
                }
                bt.transform.Translate(Vector3.forward * distanceToMove); 
                //Debug.Log("move " + bt.transform.position.ToString());
                if (Vector3.Distance(bt.transform.position, targetTrans().position) > bulletFlyMaxDistance)
                {
                    //bullets.RemoveAt(idx);
                    //Destroy(bt);
                    //Debug.Log("remove ");
                    bt.SetActive(false);
                    bt.transform.position = Vector3.zero;
                }
            }
            
        }

    }

    Transform targetTrans() {
        //return paotongTrans.transform.parent.transform;
        return paotongTrans.transform;
    }
    void CreateBullet()
    {
        if (bullets.Count < bulletCount) {
            GameObject bt = Object.Instantiate(bullet, this.gameObject.transform.parent.transform);
            bt.transform.position = Vector3.zero;
            bt.SetActive(false);
            bt.transform.localScale = new Vector3(bulletScale, bulletScale, bulletScale);
            bullets.Add(bt);
            Debug.Log("add bt" + bt.ToString() + "  paotong: " + paotongTrans.position.ToString()); 
        }

    }
}
