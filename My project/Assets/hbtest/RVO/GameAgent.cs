using System;
using System.Collections;
using System.Collections.Generic;
using RVO;
using UnityEngine;
using Random = System.Random;
using Vector2 = RVO.Vector2;


public class GameAgent : MonoBehaviour
{
 
    public Transform targetTrans;
    [HideInInspector] public int sid = -1;

    /** Random number generator. */
    private Random m_random = new Random();
    // Use this for initialization
    public bool isMeetOthers = false;

    void Start()
    {
        Vector2 pos = new Vector2(transform.position.x, transform.position.z);
        sid = Simulator.Instance.addAgent(pos); 
    }

    // Update is called once per frame
    void Update()
    {
        if (sid < 0) return;

        if (sid >= 0)
        {
            Vector2 pos = Simulator.Instance.getAgentPosition(sid);
            Vector2 vel = Simulator.Instance.getAgentPrefVelocity(sid);
            transform.position = new Vector3(pos.x(), transform.position.y, pos.y());
            if (Math.Abs(vel.x()) > 0.01f && Math.Abs(vel.y()) > 0.01f)
                transform.forward = new Vector3(vel.x(), 0, vel.y()).normalized;
        }

        //遇到其他人了停下来干架
        if (isMeetOthers == true) { 
            Simulator.Instance.setAgentPrefVelocity(sid, new Vector2(0, 0));
            return;
        }

        //没有遇到人继续前进
        if (sid >= 0 && isMeetOthers == false)
        {
            Vector2 targetPositionV2 = GameMainManager.Instance.mousePosition;
            if (targetTrans != null) {
                targetPositionV2 = new Vector2(targetTrans.position.x, targetTrans.position.z); 
            }
            Vector2 goalVector = targetPositionV2 - Simulator.Instance.getAgentPosition(sid);
            if (RVOMath.absSq(goalVector) > 1.0f)
            {
                goalVector = RVOMath.normalize(goalVector);
            } 
            Simulator.Instance.setAgentPrefVelocity(sid, goalVector); 
            /* Perturb a little to avoid deadlocks due to perfect symmetry. */
            float angle = (float)m_random.NextDouble() * 2.0f * (float)Math.PI;
            float dist = (float)m_random.NextDouble() * 0.0001f; 
            Simulator.Instance.setAgentPrefVelocity(sid, Simulator.Instance.getAgentPrefVelocity(sid) +
                                                         dist *
                                                         new Vector2((float)Math.Cos(angle), (float)Math.Sin(angle)));
        }
    }

}