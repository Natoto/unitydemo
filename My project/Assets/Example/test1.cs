using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using GameFramework;
using GameFramework.Procedure;
using UnityGameFramework.Runtime;
using ProcedureOwner = GameFramework.Fsm.IFsm<GameFramework.Procedure.IProcedureManager>;
using GameFramework.DataNode;

//文档 https://gameframework.cn/api/class_unity_game_framework_1_1_runtime_1_1_config_component.html
public class test1 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
         
        var dataNodeComponent = GameEntry.GetComponent<DataNodeComponent>();
        // 获取某个数据结点
        IDataNode playerNode = dataNodeComponent.GetNode("Player");

        // 使用相对路径设置数据结点的数据
        dataNodeComponent.SetData<VarInt16>("Level", 99, playerNode);

        // 使用相对路径获取数据结点的数据
        // 等价于 dataNodeComponent.GetData("Player.Level")
        Variable playerLevelVariable = dataNodeComponent.GetData("Level", playerNode);

        var msg = Utility.Text.Format("玩家等级是 '{0}'", playerLevelVariable.ToString());
        Log.Info(msg);

        DataTableComponent dataTableComponent = GameEntry.GetComponent<DataTableComponent>();
        if (dataTableComponent.HasDataTable("player")) { 
        }
    }

    // Update is called once per frame
    void Update()
    {
        //Log.Info("helllloooo");
        
    }
}
