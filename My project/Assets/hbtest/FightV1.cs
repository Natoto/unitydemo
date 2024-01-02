 
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using CombineMeshes;
public class FightV1 : MonoBehaviour
{
     
    public GameObject monster;
    public GameObject target;
    public GameObject _tipsObject;
    public GameObject mHouse;
    public int MonsterMax = 20000;
    public int MonsterCreateOnce = 100;
    public int liftTime = 15; 
    private List<GameObject> monsters = new List<GameObject>();

    private Matrix4x4[] matrices;



    int genIndex = 1;
    //float frameDur = 0;
    int randomZ;
    int randomX;
    // Start is called before the first frame update
    void Start()
    {
        //InvokeRepeating("createMonster", 1, 0.2f);

        for (int i = 0; i < MonsterCreateOnce; i++)
        {
            createMonster();
        } 

    }


    private void updateInstanceMatrix()
    {
        MaterialPropertyBlock props = new MaterialPropertyBlock();
        MeshRenderer renderer;

        int instanceCount = monsters.Count;
        //if (matrices == null) {
         matrices = new Matrix4x4[instanceCount]; 
        //}
        for (int i = 0; i < instanceCount; i++)
        { 
            // Generate random position and rotation for each instance
            Vector3 position = new Vector3( Random.Range(-10f, 10f), 10.0f, Random.Range(-10f, 10f));
            Quaternion rotation = Quaternion.Euler(0f, Random.Range(0f, 360f), 0f);
            matrices[i] = Matrix4x4.TRS(position, rotation, Vector3.one);

            GameObject obj = monsters[i];
            float r = (i % 255.0f) / 255.0f; //Random.Range(0.0f, 1.0f);
            float g = ((i + 100) % 255.0f) / 255.0f; // Random.Range(0.0f, 1.0f);
            float b = ((i + 200) % 255.0f) / 255.0f; //Random.Range(0.0f, 1.0f);
            props.SetColor("_Color", new Color(r, g, b));
            renderer = obj.GetComponent<MeshRenderer>();
            renderer.SetPropertyBlock(props);
        }
        //Debug.Log("instancecount: " + instanceCount);
    }

    void updateTipsText() {

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
                tipsText.text = $"box number: {monsters.Count}";
            }
        } 
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P)) {
            for (int i = 0; i < MonsterCreateOnce; i++)
            {
                createMonster();
            }
        }
        //for (int idx = 0; idx < monsters.Count; idx++) {
        //    GameObject m = monsters[idx];
        //    if (m ) {
        //        int c = Random.Range(1, 10);
        //        if ((int)frameDur % c == 0) {
        //            randomZ = Random.Range(1, 10);
        //            randomX = Random.Range(-10, 10);
        //        }
        //        frameDur = frameDur + Time.deltaTime;
        //        m.transform.Translate(randomZ * Time.deltaTime * Vector3.forward + randomX * Time.deltaTime * Vector3.right);
        //    }
        //}


        // Draw the instances using GPU instancing 
        //Mesh mesh = monster.GetComponent<MeshFilter>().mesh;
        //Material material = monster.GetComponent<Renderer>().material;
        //material.enableInstancing = true;
        //updateInstanceMatrix();
        //Graphics.DrawMeshInstanced(mesh, 0, material, matrices);

        updateTipsText();
    }



    private void MergeMeshes()
    {
        // Create a new empty game object to hold the merged mesh
        GameObject mergedMeshObject = new GameObject("MergedMesh");
        mergedMeshObject.transform.position = Vector3.zero;
        mergedMeshObject.transform.rotation = Quaternion.identity;

        Material material = monster.GetComponent<Material>();
        // Merge the meshes using MergeUtils.MergeMesh method
        GameObject meshesToMerge = CombineMeshes.Combinemeshes.MergeMeshes(mHouse, material);
        meshesToMerge.transform.SetParent(mergedMeshObject.transform);

        meshesToMerge.AddComponent<Rigidbody>();
        meshesToMerge.AddComponent<monster>();
        meshesToMerge.AddComponent<BoxCollider>(); 
        monsters.Clear(); 
    }

    void createMonster() {

        if (monsters.Count < MonsterMax && monster) {
            GameObject m = Object.Instantiate(monster, mHouse.transform);

            randomZ = Random.Range(1, 100);
            randomX = Random.Range(-100, 100);
            m.transform.LookAt(target.transform);
            m.transform.position = monster.transform.position + Vector3.right * randomX + Vector3.forward * randomZ;


            m.name = "m-" + genIndex;
            m.SetActive(true);
            genIndex++; 
            monsters.Add(m);

            //monster ms = m.GetComponent<monster>();
            //ms.liftTime = liftTime;
            Debug.Log($"create monster {m.name} x:{m.transform.position.x}  y:{m.transform.position.y}   z:{m.transform.position.z}");

        } 
    }
     

    public void OnGameObjectDestroyed(GameObject destroyedObject)
    {
        // 执行相应的处理逻辑
        monsters.Remove(destroyedObject); 
        //Destroy(destroyedObject);
        Debug.Log($"MakeFireV2.OnGameObjectDestroyed {destroyedObject.name}");

    }

    private void OnDestroy()
    {
        CancelInvoke();
    }

}
