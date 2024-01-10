using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GPUInstancer;
using UnityEngine.UI;
using GPUInstancer.CrowdAnimations;
using UnityEngine.AI;
using RVO;
using Vector2 = RVO.Vector2;

public class TestBatchRVO : MonoBehaviour
{

    // The reference to the Prototype (the prefab itself can be assigned here since the GPUI Prototype component lives on the Prefab).
    public GPUICrowdPrefab prefab;

    // The reference to the active Prefab Manager in the scene.
    public GPUICrowdManager prefabManager;

    public bool isEnermy;
    public GameObject _hero;

    public GameObject _tipsObject;
    // The count of instances that will be generated.
    public int instances = 1000;

    // The name of the buffer. Must be the same with the StructuredBuffer in the shader that the Mateiral will use. See: "ColorVariationShader_GPUI.shader".
    public string bufferName = "colorBuffer";

    // The List to hold the instances that will be generated.
    private List<GPUICrowdPrefab> goList;
    private NavMeshHit _navMeshHit;
    // Start is called before the first frame update


    private int _rowCount = 30;
    private int _collumnCount = 30;
    private float _space = 2.5f;

    private Ray _ray;
    private RaycastHit _hit;
    //private NavMeshHit _navMeshHit;
    void Start()
    {
        Debug.Log("fightv2 start ");
        goList = new List<GPUICrowdPrefab>();

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
        createPrefabInstance();

        // Register the generated instances to the manager and initialize the manager.
        if (prefabManager != null && prefabManager.isActiveAndEnabled)
        {
            Debug.Log("fightv2 InitializeGPUInstancer ");
            GPUInstancerAPI.RegisterPrefabInstanceList(prefabManager, goList);
            GPUInstancerAPI.InitializeGPUInstancer(prefabManager);
        }
        prefabManager.enabled = true;


        Simulator.Instance.setTimeStep(0.25f);
        //public void setAgentDefaults(float neighborDist, int maxNeighbors, float timeHorizon, float timeHorizonObst, float radius, float maxSpeed, Vector2 velocity
        Simulator.Instance.setAgentDefaults(15, 10, 5, 5, 3, 20, new Vector2(0.0f, 0.0f));
        // add in awake
        Simulator.Instance.processObstacles();
    }

    void placeHero() {
        GameObject _indicatorSphere = _hero;
        _ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(_ray, out _hit, Mathf.Infinity))
        {
            Vector3 oldpos = _indicatorSphere.transform.position;
            _indicatorSphere.transform.position = new Vector3(_hit.point.x, oldpos.y, _hit.point.z);

            //StartCoroutine(updateDestination());
        }
        Debug.Log("move position: " + _hit.point + _indicatorSphere.name); 
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
        else if (isEnermy && Input.GetMouseButtonDown(0) ) {
            placeHero();
        }
        else if (!isEnermy && Input.GetMouseButtonDown(1))
        {
            placeHero();
        }
        Simulator.Instance.doStep();

        updateTipsText();
    }

    private IEnumerator updateDestination() {


        for (int idx = 0; idx < goList.Count; idx++)
        {
            GPUICrowdPrefab prefab = goList[idx];
            NavMeshAgent agentai = prefab.GetComponent<NavMeshAgent>(); // Store a reference to the NavMesh agent for later use.

            if (agentai != null)
            {
                agentai.updateRotation = true;
                agentai.updatePosition = true;
                agentai.isStopped = true;
                agentai.velocity = Vector3.zero;
                agentai.SetDestination(GetRandomNavMeshPositionNearLocation(_hero.transform.position, 30));
                agentai.isStopped = false;
                Debug.Log("update destination: " + _hit.point + " " + idx);
            }
        }
        yield return new WaitForSeconds(0.001f);
    }

    public void AddInstances()
    {
        GPUICrowdManager gpuiCrowdManager = prefabManager;
        if (gpuiCrowdManager == null)
            return;
        if (_rowCount >= 100)
            return;
        createPrefabInstance();
    }

    void createPrefabInstance() {
        // prefab.prefabPrototype.prefabObject.transform.position; // 
        Vector3 pos = Vector3.zero;
        Debug.Log("pos: " + pos);
        Quaternion rotation = Quaternion.Euler(0, 180, 0) * prefab.prefabPrototype.prefabObject.transform.rotation;
        for (int r = 0; r < _rowCount; r++)
        {
            for (int c = 0; c < _collumnCount; c++)
            {
                float scale = prefab.prefabPrototype.prefabObject.transform.localScale.x;
                pos = prefab.prefabPrototype.prefabObject.transform.position;
                pos.x += _space * r * scale;
                pos.z += _space * c * scale;
                pos.y = prefab.transform.position.y;

                GPUInstancerPrefab prefabInstance = Instantiate(prefab, pos, rotation);
                prefabInstance.transform.SetParent(transform); 

                //NavMeshAgent agentai = prefabInstance.GetComponent<NavMeshAgent>(); // Store a reference to the NavMesh agent for later use.

                //if (agentai != null)
                //{
                //    agentai.updateRotation = true;
                //    agentai.updatePosition = true; 
                //    agentai.SetDestination(GetRandomNavMeshPositionNearLocation(_hero.transform.position, 30));

                //}

                goList.Add(prefabInstance.GetComponent<GPUICrowdPrefab>());
            }
        }
    }
    private Vector3 GetRandomNavMeshPositionNearLocation(Vector3 origin, float range)
    {
        for (int i = 0; i < 40; i++)
        {
            Vector3 randomPoint = origin + Random.insideUnitSphere * range;
            if (NavMesh.SamplePosition(randomPoint, out _navMeshHit, range, NavMesh.AllAreas))
                return _navMeshHit.position;
            //return randomPoint;
        }
        return origin;
    }

}
