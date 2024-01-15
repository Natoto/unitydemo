using System.Collections;
using System.Collections.Generic;
using UnityEngine; 

namespace CombineMeshes
{
    ///<summary>
    ///注意：MergeMesh2、3只能针对于mesh上只有一个材质
    /// </summary>
    public static class Combinemeshes
    {
         

        static public GameObject MergeMeshes(GameObject parent, Material sharedMaterial)
        {

            MeshFilter[] meshesToMerge = parent.GetComponentsInChildren<MeshFilter>();
            // Create a new empty game object to hold the merged mesh
            GameObject mergedMeshObject = new GameObject("MergedMesh");
            mergedMeshObject.transform.position = Vector3.zero;
            mergedMeshObject.transform.rotation = Quaternion.identity;

            // Create an array of CombineInstance objects
            CombineInstance[] combineInstances = new CombineInstance[meshesToMerge.Length];

            // Loop through each mesh filter and assign its mesh and transform to the corresponding CombineInstance
            for (int i = 0; i < meshesToMerge.Length; i++)
            {
                combineInstances[i].mesh = meshesToMerge[i].sharedMesh;
                combineInstances[i].transform = meshesToMerge[i].transform.localToWorldMatrix;
            }

            // Create a new mesh to hold the merged mesh
            Mesh mergedMesh = new Mesh();

            // Combine the meshes using the CombineMeshes method
            mergedMesh.CombineMeshes(combineInstances, true, true);

            // Assign the merged mesh to the mesh filter of the merged mesh object
            MeshFilter mergedMeshFilter = mergedMeshObject.AddComponent<MeshFilter>();
            mergedMeshFilter.sharedMesh = mergedMesh;

            // Attach a mesh renderer to the merged mesh object
            MeshRenderer mergedMeshRenderer = mergedMeshObject.AddComponent<MeshRenderer>();
            mergedMeshRenderer.sharedMaterial = sharedMaterial;


            //// Optionally, you can delete the original mesh objects
            foreach (MeshFilter meshFilter in meshesToMerge)
            {
                GameObject.Destroy(meshFilter.gameObject);
            }
            return mergedMeshObject;
        }
    }
}