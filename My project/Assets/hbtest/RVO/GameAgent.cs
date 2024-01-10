using System;
using System.Collections;
using System.Collections.Generic;
using RVO;
using UnityEngine;
using GPUInstancer;
using GPUInstancer.CrowdAnimations;
using Random = System.Random;
using Vector2 = RVO.Vector2;


public class GameAgent : MonoBehaviour
{
    public GPUICrowdManager crowdManager;
    [Tooltip("Optional parameter to randomize only the given prototypes")]
    public List<GPUICrowdPrototype> crowdPrototypeFilter;
    private bool isMeet = false;

    public Transform targetTrans;
    [HideInInspector] public int sid = -1;

    /** Random number generator. */
    private Random m_random = new Random();
    // Use this for initialization

    void Start()
    {
        Vector2 pos = new Vector2(transform.position.x, transform.position.z);
        sid = Simulator.Instance.addAgent(pos); 
    }

    // Update is called once per frame
    void Update()
    {
        if (sid >= 0)
        {
            Vector2 pos = Simulator.Instance.getAgentPosition(sid);
            Vector2 vel = Simulator.Instance.getAgentPrefVelocity(sid);
            transform.position = new Vector3(pos.x(), transform.position.y, pos.y());
            if (Math.Abs(vel.x()) > 0.01f && Math.Abs(vel.y()) > 0.01f)
                transform.forward = new Vector3(vel.x(), 0, vel.y()).normalized;
        } 
        if (sid >= 0)
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

    private void OnTriggerEnter(Collider other)
    {
        var name = this.name;
        if (name.Contains("Spitter") && other.name.Contains("Ellen") && isMeet == false)
        {
            isMeet = true;
            Simulator.Instance.setAgentPrefVelocity(sid, new Vector2(0, 0));
            Debug.Log(sid + " Spitter meet  Ellen " + other.name);
            RandomizeAnimations();
        }
        else if (name.Contains("Ellen") && other.name.Contains("Spitter") && isMeet == false)
        {
            isMeet = true;
            Simulator.Instance.setAgentPrefVelocity(sid, new Vector2(0, 0)); 
            Debug.Log(sid + " Ellen meet Spitter " + other.name);
            RandomizeAnimations();
        }
    }


    public void RandomizeAnimations()
    {
        if (crowdManager != null)
        {
            bool randomizeClips = true;
            bool randomizeFrame = false;
            bool resetAnimations = false;
            Dictionary<GPUInstancerPrototype, List<GPUInstancerPrefab>> registeredPrefabInstances = crowdManager.GetRegisteredPrefabsRuntimeData();
            GPUIAnimationClipData clipData;
            float startTime;
            if (registeredPrefabInstances != null)
            {
                foreach (GPUICrowdPrototype crowdPrototype in registeredPrefabInstances.Keys)
                {
                    if (crowdPrototypeFilter != null && crowdPrototypeFilter.Count > 0 && !crowdPrototypeFilter.Contains(crowdPrototype))
                        continue;
                    if (crowdPrototype.animationData != null && crowdPrototype.animationData.useCrowdAnimator)
                    {
                        foreach (GPUICrowdPrefab crowdInstance in registeredPrefabInstances[crowdPrototype])
                        {
                            clipData = resetAnimations ? crowdPrototype.animationData.clipDataList[crowdPrototype.animationData.crowdAnimatorDefaultClip] : crowdInstance.crowdAnimator.currentAnimationClipData[0];
                            if (!resetAnimations && randomizeClips)
                                clipData = crowdPrototype.animationData.clipDataList[UnityEngine.Random.Range(0, crowdPrototype.animationData.clipDataList.Count)];
                            startTime = resetAnimations ? 0 : -1;
                            if (!resetAnimations && randomizeFrame)
                                startTime = UnityEngine.Random.Range(0, clipData.length);

                            GPUICrowdAPI.StartAnimation(crowdInstance, clipData, startTime);
                        }
                    }
                }
            }
        }
    }
}