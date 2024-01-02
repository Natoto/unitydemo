using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GPUInstancer;
using UnityEngine.UI;

public class FightV2 : MonoBehaviour
{

    // The reference to the Prototype (the prefab itself can be assigned here since the GPUI Prototype component lives on the Prefab).
    public GPUInstancerPrefab prefab;

    // The reference to the active Prefab Manager in the scene.
    public GPUInstancerPrefabManager prefabManager;
     
    public GameObject _hero;

    public GameObject _tipsObject;
    // The count of instances that will be generated.
    public int instances = 1000;

    // The name of the buffer. Must be the same with the StructuredBuffer in the shader that the Mateiral will use. See: "ColorVariationShader_GPUI.shader".
    public string bufferName = "colorBuffer";

    // The List to hold the instances that will be generated.
    private List<GPUInstancerPrefab> goList;
    // Start is called before the first frame update
    void Start()
    {
        goList = new List<GPUInstancerPrefab>();

        // Define the buffer to the Prefab Manager.
        if (prefabManager != null && prefabManager.isActiveAndEnabled)
        {
            GPUInstancerAPI.DefinePrototypeVariationBuffer<Vector4>(prefabManager, prefab.prefabPrototype, bufferName);
        }

        // Generate instances inside a radius.
        for (int i = 0; i < instances; i++)
        {
            GPUInstancerPrefab prefabInstance = Instantiate(prefab);
            prefabInstance.transform.localPosition = Random.insideUnitSphere * 20;
            prefabInstance.transform.SetParent(transform);
            goList.Add(prefabInstance);

            // Register the variation buffer for this instance.
            prefabInstance.AddVariation(bufferName, (Vector4)Random.ColorHSV());
              

        }

        // Register the generated instances to the manager and initialize the manager.
        if (prefabManager != null && prefabManager.isActiveAndEnabled)
        {
            GPUInstancerAPI.RegisterPrefabInstanceList(prefabManager, goList);
            GPUInstancerAPI.InitializeGPUInstancer(prefabManager);
        }
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

            // Define the buffer to the Prefab Manager.
            if (prefabManager != null && prefabManager.isActiveAndEnabled)
            {
                GPUInstancerAPI.DefinePrototypeVariationBuffer<Vector4>(prefabManager, prefab.prefabPrototype, bufferName);
            }
            for (int i = 0; i < instances; i++)
            {
                 
                GPUInstancerPrefab prefabInstance = Instantiate(prefab);
                Vector2 circle = Random.insideUnitCircle * 20;
                prefabInstance.transform.position =  _hero.transform.position + new Vector3(circle.x, 0, circle.y);
                prefabInstance.transform.SetParent(transform);

                // Register the variation buffer for this instance.
                prefabInstance.AddVariation(bufferName, (Vector4)Random.ColorHSV());

                if (!prefabInstance.prefabPrototype.addRuntimeHandlerScript)
                    GPUInstancerAPI.AddPrefabInstance(prefabManager, prefabInstance);
                    goList.Add(prefabInstance);
            }

            //GPUInstancerAPI.RegisterPrefabInstanceList(prefabManager, goList);
            Debug.Log("goList: " + goList.Count);
        }
        // Update the variation buffer with a random set of colors every frame, thus changing instance colors per instance every frame.
        GPUInstancerAPI.UpdateVariation(prefabManager, goList[Random.Range(0, goList.Count)], bufferName, (Vector4)Random.ColorHSV());

        updateTipsText();
    }
}
