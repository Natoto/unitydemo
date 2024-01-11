using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using GPUInstancer;
using GPUInstancer.CrowdAnimations;

public class MeetAndFlight : MonoBehaviour
{
    public GPUICrowdManager crowdManager;
    [Tooltip("Optional parameter to randomize only the given prototypes")]
    public List<GPUICrowdPrototype> crowdPrototypeFilter;
    public int FightClipIndex = 0;
    private bool isMeetOthers = false;
    private int sid = -1;
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
        sid = GetComponent<GameAgent>().sid;
        if (sid < 0) return;
        var name = this.name;
        if (name.Contains("Spitter") && other.name.Contains("Ellen") && isMeetOthers == false)
        {
            isMeetOthers = true;
            GetComponent<GameAgent>().isMeetOthers = isMeetOthers;
            Debug.Log(sid + " Spitter meet  Ellen " + other.name);
            RandomizeAnimations();
        }
        else if (name.Contains("Ellen") && other.name.Contains("Spitter") && isMeetOthers == false)
        {
            isMeetOthers = true;
            GetComponent<GameAgent>().isMeetOthers = isMeetOthers;
            Debug.Log(sid + " Ellen meet Spitter " + other.name);
            RandomizeAnimations();
        }
    }


    public void RandomizeAnimations()
    {
        if (crowdManager != null)
        {
            Dictionary<GPUInstancerPrototype, List<GPUInstancerPrefab>> registeredPrefabInstances = crowdManager.GetRegisteredPrefabsRuntimeData();
            GPUIAnimationClipData clipData;  
            GPUICrowdPrefab crowdInstance = GetComponent<GPUICrowdPrefab>();
            float startTime = 0;
            GPUICrowdPrototype crowdPrototype = (GPUICrowdPrototype)crowdInstance.prefabPrototype;
            clipData = crowdPrototype.animationData.clipDataList[FightClipIndex]; 
            GPUICrowdAPI.StartAnimation(crowdInstance, clipData, startTime);
             
        }
    }
}
