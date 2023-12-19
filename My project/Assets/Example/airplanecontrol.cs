using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class airplanecontrol : MonoBehaviour
{
    Vector3 m_dir = Vector3.zero;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A)) {
            m_dir = Vector3.left * 100;
        } else if (Input.GetKeyDown(KeyCode.D))
        {
            m_dir = Vector3.left * -100;
        } else if (Input.GetKeyDown(KeyCode.W))
        {
            m_dir = Vector3.forward * 100;
        } else if (Input.GetKeyDown(KeyCode.S))
        {
            m_dir = Vector3.forward * -100;
        } 
        else if (Input.GetKeyUp(KeyCode.S) || Input.GetKeyUp(KeyCode.A) || Input.GetKeyUp(KeyCode.D) || Input.GetKeyUp(KeyCode.W))
        {
            m_dir = Vector3.zero;
        }
        this.transform.Translate(m_dir);
    }
}
