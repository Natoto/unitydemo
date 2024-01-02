
using System.Collections;
using System.Collections.Generic;
using UnityEngine; 
 

public class monster : MonoBehaviour
{
    public GameObject target;
    public int liftTime = 10;
    //public static event Action<GameObject> GameObjectDestroyed;
    public GameObject makeFireControl;

    int changeTime; //几秒变化一下方向，蛇形走位
    int randomZ;
    int randomX;

    // Start is called before the first frame update
    void Start()
    {
        //使用了以下代码 就无法使用gpuinstance 
        //initMonster();        
        //controller = FindObjectOfType<MakeFireV2>();
        //changeTime = Random.Range(1, 3);
        //randomZ = Random.Range(1, 10);
        //randomX = Random.Range(-10, 10);
        //Debug.Log($"create {this.name} changeTime: {changeTime}");
        
    }

    // Update is called once per frame
    void Update()
    {
        //GameObject m = this.gameObject;

        //float currentTime = Time.realtimeSinceStartup;
        ////Debug.Log(currentTime);
        //if ((int)currentTime % changeTime == 0)
        //{
        //    randomZ = Random.Range(1, 10);
        //    randomX = Random.Range(-10, 10);
        //}
        ////frameDur = frameDur + Time.deltaTime;
        //m.transform.Translate(randomZ * Time.deltaTime * Vector3.forward + randomX * Time.deltaTime * Vector3.right);

    }

    private void OnTriggerEnter(Collider other)
    {
        //if (true == other.name.Contains("hero")) {
        //    Debug.Log("OnTriggerEnter  " + this.name);
        //    MakeFireV2 controller = makeFireControl.GetComponent<MakeFireV2>();
        //    controller?.OnGameObjectDestroyed(gameObject);
        //}
    }
        
    private void OnDestroy()
    {
        //Debug.Log("OnDestroy " + this.name); 
    }


    void initMonster()
    { 
            float randomR = Random.Range(1, 255) / 255.0f;
            float randomG = Random.Range(1, 255) / 255.0f;
            float randomB = Random.Range(1, 255) / 255.0f;
            int randomX = Random.Range(-30, 30);
            int randomZ = Random.Range(-30, 30);
            GameObject m =  this.gameObject;
            m.transform.LookAt(target.transform);
            m.transform.position = Vector3.right * randomX + Vector3.forward * randomZ;
       

            Material mt = m.GetComponent<Renderer>().material;
            mt.color = new Color(randomR, randomG, randomB, 1); 
            //Debug.Log("create monster " + m.name);

            StartCoroutine(DestroyAfterDelay(m, liftTime));
            // 调用协程函数，设置延迟时间为10秒 

    }

    IEnumerator DestroyAfterDelay(GameObject obj, float delay)
    {
        yield return new WaitForSeconds(delay);
        if (liftTime > 0) {
            Debug.Log($"DestroyAfterDelay {this.name}");
            MakeFireV2 controller = makeFireControl.GetComponent<MakeFireV2>();
            controller?.OnGameObjectDestroyed(gameObject);
            Destroy(obj);
        }
    }

}
