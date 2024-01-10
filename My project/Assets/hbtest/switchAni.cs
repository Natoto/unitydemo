using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class switchAni : MonoBehaviour
{ 

    private int speedID = Animator.StringToHash("Forward");
    //private int speedID = Animator.StringToHash("ForwardSpeed");
    private int isSpeedID = Animator.StringToHash("IsSpeedUp");
    private int horizontalID = Animator.StringToHash("Horizontal");
    private Animator anim;
    // Start is called before the first frame update
    void Start()
    {
        anim = gameObject.GetComponent<Animator>(); 
        anim.applyRootMotion = true;
        anim.SetFloat(speedID, 5);
    }

    // Update is called once per frame

    void Update()
    { 
    }
}
