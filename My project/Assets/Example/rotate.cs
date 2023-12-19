using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotate : MonoBehaviour
{
    public bool RotateX;
    public bool RotateY = true;
    public bool RotateZ;
    public float m_speed = 10;
    bool m_speedAdd = true;
    // Start is called before the first frame update
    void Start()
    {
        //InvokeRepeating("autoAdjustSpeed", 0.1f, 0.1f);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonUp(0)) {
            m_speedAdd = !m_speedAdd;
            Debug.Log("m_speedAdd " + m_speedAdd);
        }
        if (Input.GetKey(KeyCode.A)) {

            m_speed *= -1;
        }
        float speed = m_speed * Time.deltaTime;
        float spx = RotateX == true ? speed : 0;
        float spy = RotateY == true ? speed : 0;
        float spz = RotateZ == true ? speed : 0;
        this.transform.Rotate(spx, spy, spz, Space.Self);
    }

    void autoAdjustSpeed() {

        float acc = 10;
        if (m_speedAdd == false) acc = -10;
            m_speed = m_speed +  acc;
        if (m_speed > 720)  m_speed = 720; 

        if(m_speed<0) m_speed = 0;
        
        //Debug.Log("m_speed " + m_speed);
     
    }
}
