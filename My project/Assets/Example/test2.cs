using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GameFramework;
using GameFramework.Procedure;
using UnityGameFramework.Runtime;
using ProcedureOwner = GameFramework.Fsm.IFsm<GameFramework.Procedure.IProcedureManager>;
using GameFramework.DataNode;

//https://gameframework.cn/document/datanode/
public class test2 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    { 

    }

    // Update is called once per frame
    void Update()
    {
        var dataNode = GameEntry.GetComponent<DataNodeComponent>();
        IDataNode playerNode = dataNode.GetNode("Player");
        Variable level = dataNode.GetData("Level", playerNode);
        Log.Info("level: " + level);

    }
}
