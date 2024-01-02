using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class testcompute : MonoBehaviour
{
    public ComputeShader computeShader;
    public Material material;
    public RenderTexture resultTexture;
    Texture2D texture;
    // Start is called before the first frame update
    void Start()
    {
        int kernel = computeShader.FindKernel("CSMain");
        computeShader.SetTexture(kernel, "Result", resultTexture);
        computeShader.Dispatch(kernel, resultTexture.width / 4, resultTexture.height / 4, 1);

        // 创建一个新的Texture2D对象
        texture = new Texture2D(resultTexture.width, resultTexture.height, TextureFormat.RGB24, false);

    }

    // Update is called once per frame
    void Update()
    {
        //Graphics.Blit(resultTexture, material);
     
        // 使用Graphics.Blit函数将RenderTexture的内容复制到Texture2D对象中
        RenderTexture.active = resultTexture;
        texture.ReadPixels(new Rect(0, 0, resultTexture.width, resultTexture.height), 0, 0);
        texture.Apply();

        // 将Texture2D对象设置为Material的贴图属性
        Material material = GetComponent<Renderer>().material;
        material.mainTexture = texture;
    }



    private Texture2D RT2Tex2D(RenderTexture rt)
    {
        Texture2D tex = new Texture2D(rt.width, rt.height, TextureFormat.RGB24, false);
        RenderTexture.active = rt;
        tex.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
        tex.Apply();
        return tex;
    }
}
