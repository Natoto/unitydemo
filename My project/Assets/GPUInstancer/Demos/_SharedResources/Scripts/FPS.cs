using UnityEngine;
using System.Collections;
using UnityEngine.UI;

namespace GPUInstancer
{
    public class FPS : MonoBehaviour
    {
        public GameObject fpslabel;
        public float FPSCount;

        IEnumerator Start()
        {
            //GUI.depth = 2;
            while (true)
            {
                if (Time.timeScale == 1)
                {
                    yield return new WaitForSeconds(0.1f);
                    FPSCount = Mathf.Round(1 / Time.deltaTime);  
                    // 获取Text组件
                    Text tipsText = fpslabel.GetComponent<Text>(); 
                    if (tipsText != null)
                    { 
                        tipsText.text = $"FPS: {FPSCount}";
                    }
                }
                else
                {
                    FPSCount = 0;
                }
                yield return new WaitForSeconds(0.5f);
            }
        }
    }
}
