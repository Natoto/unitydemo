using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class bullet : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

        Debug.Log(" start " + this.name);
    }

    // Update is called once per frame
    void Update()
    {

        //Debug.Log(" update " + this.name + " pos:" + this.gameObject.transform.position.y);
    }

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log(" 发生了碰撞xx");
    }
}
