using UnityEngine;
using UnityEngine.UI;

//https://blog.csdn.net/yinhun2012/article/details/112171905
public class BufferCSCall : MonoBehaviour
{
    public int texWidth = 8192;
    public int texHeight = 8192;
    public ComputeShader theCS;
    public RawImage img;
    public Material material;
    private ComputeBuffer csBuffer;
    private Vector2[] csFloats;
    private RenderTexture csTex;

    void Start()
    {
        //假设有这么一个二维vector2矩阵
        int bufferlen = texWidth * texHeight;
        csFloats = new Vector2[bufferlen];
        for (int x = 0; x < texWidth; x++)
        {
            for (int y = 0; y < texHeight; y++)
            {
                int index = x * texHeight + y;
                csFloats[index] = new Vector2(x, y);
            }
        }
#if UNITY_EDITOR
        Debug.LogFormat("cs start time = {0}", Time.realtimeSinceStartup);
#endif
        //初始化tex
        csTex = new RenderTexture(texWidth, texHeight, 0, RenderTextureFormat.ARGB32);
        csTex.enableRandomWrite = true;
        csTex.Create();
        //绘制图像
        //通过Set函数传递数据到GPU
        int kl = theCS.FindKernel("CSMain");
        csBuffer = new ComputeBuffer(bufferlen, 32);
        csBuffer.SetData(csFloats);
        theCS.SetBuffer(kl, "Float2s", csBuffer);
        theCS.SetTexture(kl, "Result", csTex);
        theCS.SetInt("Width", texWidth);
        theCS.SetInt("Height", texHeight);
        theCS.Dispatch(kl, texWidth / 16, texHeight / 32, 1);
        img.texture = csTex;
#if UNITY_EDITOR
        Debug.LogFormat("cs stop time = {0}", Time.realtimeSinceStartup);
#endif
    }

    private void Update()
    {

        // 将Texture2D对象设置为Material的贴图属性
        Material material = GetComponent<Renderer>().material;
        material.mainTexture =  GetTextureFromRawImage(img) ;
    }


    Texture2D GetTextureFromRawImage(RawImage rawImage)
    {
        RenderTexture renderTex = RenderTexture.GetTemporary(
            rawImage.texture.width,
            rawImage.texture.height,
            0,
            RenderTextureFormat.Default,
            RenderTextureReadWrite.Linear
        );

        Graphics.Blit(rawImage.texture, renderTex);
        RenderTexture previous = RenderTexture.active;
        RenderTexture.active = renderTex;
        Texture2D texture = new Texture2D(rawImage.texture.width, rawImage.texture.height);
        texture.ReadPixels(new Rect(0, 0, renderTex.width, renderTex.height), 0, 0);
        texture.Apply();

        RenderTexture.active = previous;
        RenderTexture.ReleaseTemporary(renderTex);

        return texture;
    }
}