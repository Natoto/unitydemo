using UnityEngine;

public class CreateCube : MonoBehaviour
{
    [SerializeField]
    private GameObject _instanceGo;//需要实例化对象
    [SerializeField]
    private int _instanceCount;//需要实例化个数
    [SerializeField]
    private bool _bRandPos = false;//是否随机的显示对象
    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < _instanceCount; i++)
        {
            float randomX = Random.Range(-10, 10);
            float randomZ = Random.Range(-10, 10);
            Vector3 pos = new Vector3(randomX , 0, randomZ);
            GameObject pGO = GameObject.Instantiate<GameObject>(_instanceGo);
            pGO.transform.SetParent(gameObject.transform);
            if(_bRandPos)
            {
                pGO.transform.localPosition = Random.insideUnitSphere * 10.0f;
            }
            else
            {
                pGO.transform.localPosition = pos;
            }
            //Material mt = pGO.GetComponent<MeshRenderer>().material;
            //Color color = new Color(Random.RandomRange(0.0f, 1.0f), Random.RandomRange(0.0f, 1.0f), Random.RandomRange(0.0f, 1.0f), 1.0f);
            //mt.color = color;

        }

    }
}
