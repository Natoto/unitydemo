using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GPUInstancer;
using UnityEngine.UI;
using GPUInstancer.CrowdAnimations;
using UnityEngine.AI;

public class TestGPUIAni : MonoBehaviour
{

    // The reference to the Prototype (the prefab itself can be assigned here since the GPUI Prototype component lives on the Prefab).
    public GPUICrowdPrefab prefab;

    // The reference to the active Prefab Manager in the scene.
    public GPUICrowdManager prefabManager;
     
    public GameObject _hero;

    public GameObject _tipsObject;
    // The count of instances that will be generated.
    public int instances = 1000;

    // The name of the buffer. Must be the same with the StructuredBuffer in the shader that the Mateiral will use. See: "ColorVariationShader_GPUI.shader".
    public string bufferName = "colorBuffer";

    // The List to hold the instances that will be generated.
    private List<GPUInstancerPrefab> goList;
    private NavMeshHit _navMeshHit;
    // Start is called before the first frame update


    private int _rowCount = 30;
    private int _collumnCount = 30;
    private float _space = 1.5f;

    void Start()
    {
        Debug.Log("fightv2 start ");
        goList = new List<GPUInstancerPrefab>();

        // Define the buffer to the Prefab Manager.
        if (prefabManager != null && prefabManager.isActiveAndEnabled)
        {
            GPUInstancerAPI.DefinePrototypeVariationBuffer<Vector4>(prefabManager, prefab.prefabPrototype, bufferName);
        }
        prefabManager.enabled = false;
        //设置群组proptotype
        GPUICrowdPrototype crowdprototype = (GPUICrowdPrototype)prefab.prefabPrototype;
        crowdprototype.animationData.useCrowdAnimator = true;
        crowdprototype.enableRuntimeModifications = true;
        crowdprototype.addRemoveInstancesAtRuntime = true;
        crowdprototype.extraBufferSize = 10000;

        // Generate instances inside a radius.
        //for (int i = 0; i < instances; i++)
        //{
        GameObject prefabObject = crowdprototype.prefabObject;
        Vector3 pos = Vector3.zero;
        Quaternion rotation = Quaternion.Euler(0, 180, 0) * crowdprototype.prefabObject.transform.rotation;
        for (int r = 0; r < _rowCount; r++)
        {
            for (int c = 0; c < _collumnCount; c++)
            {
                pos.x = _space * r;
                pos.z = _space * c;
                pos.y = prefab.transform.position.y;

                GPUInstancerPrefab prefabInstance = Instantiate(prefab, pos, rotation);
                //GameObject prefabInstance = Instantiate(prefabObject, pos, rotation);

                //GPUInstancerPrefab prefabInstance = Instantiate(prefab);
                //prefabInstance.transform.localPosition = Random.insideUnitSphere * 20;
                prefabInstance.transform.SetParent(transform);



                NavMeshAgent agentai = prefabInstance.GetComponent<NavMeshAgent>(); // Store a reference to the NavMesh agent for later use.

                if (agentai != null)
                {
                    agentai.updateRotation = true;
                    agentai.updatePosition = true;

                    agentai.SetDestination(GetRandomNavMeshPositionNearLocation(_hero.transform.position, 25));
                 
                }

                goList.Add(prefabInstance.GetComponent<GPUICrowdPrefab>());
            } 

        }

        // Register the generated instances to the manager and initialize the manager.
        if (prefabManager != null && prefabManager.isActiveAndEnabled)
        {
            Debug.Log("fightv2 InitializeGPUInstancer ");
            GPUInstancerAPI.RegisterPrefabInstanceList(prefabManager, goList);
            GPUInstancerAPI.InitializeGPUInstancer(prefabManager);
        }
        prefabManager.enabled = true;
    }


    void updateTipsText()
    {

        //Debug.Log($"start updateTipsText {monsters.Count}");
        // 查找tag为"tips"的游戏对象
        GameObject tipsObject = _tipsObject; //GameObject.FindWithTag("tips");

        if (tipsObject != null)
        {
            // 获取Text组件
            Text tipsText = tipsObject.GetComponent<Text>();

            if (tipsText != null)
            {
                // 对Text组件的text属性进行赋值
                tipsText.text = $"box number: {goList.Count}";
            }
        }
    }
    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.P))
        {
            AddInstances(); 
            //GPUInstancerAPI.RegisterPrefabInstanceList(prefabManager, goList);
            Debug.Log("goList: " + goList.Count);
        }
        // Update the variation buffer with a random set of colors every frame, thus changing instance colors per instance every frame.
        //GPUInstancerAPI.UpdateVariation(prefabManager, goList[Random.Range(0, goList.Count)], bufferName, (Vector4)Random.ColorHSV());

        updateTipsText();
    }

    public void AddInstances()
    {
        GPUICrowdManager gpuiCrowdManager = prefabManager;
        if (gpuiCrowdManager == null)
            return;
        if (_rowCount >= 100)
            return;
        GameObject prefabObject = prefab.prefabPrototype.prefabObject; //gpuiCrowdManager.prototypeList[_selectedPrototypeIndex].prefabObject;
        Vector3 pos = Vector3.zero;
        GPUICrowdPrefab prefabInstance;
        Quaternion rotation = Quaternion.Euler(0, 180, 0) * prefabObject.transform.rotation;
        for (int r = 0; r < _rowCount + 10; r++)
        {
            for (int c = (r < _rowCount ? _collumnCount : 0); c < _collumnCount + 10; c++)
            {
                pos.x = _space * r;
                pos.y = prefab.transform.position.y;
                pos.z = _space * c;
                prefabInstance = Instantiate(prefab, pos, rotation);
                //GameObject instanceGO = Instantiate(prefab, pos, rotation).gameObject;
                //prefabInstance = instanceGO.GetComponent<GPUICrowdPrefab>(); // We reference the prototype by the GPUICrowdPrefab component that GPUI adds on the prefab...
                prefabInstance.transform.SetParent(transform);
                GPUInstancerAPI.AddPrefabInstance(gpuiCrowdManager, prefabInstance); // and add the instance to the manager using that reference using this API method.
                goList.Add(prefabInstance);


                NavMeshAgent agentai = prefabInstance.GetComponent<NavMeshAgent>(); // Store a reference to the NavMesh agent for later use.

                if (agentai != null)
                {
                    agentai.updateRotation = true;
                    agentai.updatePosition = true;
                     
                    agentai.SetDestination(GetRandomNavMeshPositionNearLocation(_hero.transform.position, 25));
                    prefabInstance.animatorRef.SetFloat("Speed", 0.5f);
                }
            }
        }
        _rowCount += 10;
        _collumnCount += 10;
        //textInstanceCount.text = _prototypeNameText + gpuiCrowdManager.runtimeDataList[_selectedPrototypeIndex].instanceCount;
    }


    private Vector3 GetRandomNavMeshPositionNearLocation(Vector3 origin, float range)
    {
        for (int i = 0; i < 30; i++)
        {
            Vector3 randomPoint = origin + Random.insideUnitSphere * range;
            if (NavMesh.SamplePosition(randomPoint, out _navMeshHit, range, NavMesh.AllAreas))
                return _navMeshHit.position;
            //return randomPoint;
        }
        return origin;
    }

}
