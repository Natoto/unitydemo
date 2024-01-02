using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class dragon : MonoBehaviour
{
    public int hitcount = 5;
    int hitIndex = 4;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        hitIndex++;
        Debug.Log("hitIndex: " + hitIndex);
        if (hitIndex >= 5) Destroy(this.gameObject);
    }
}
