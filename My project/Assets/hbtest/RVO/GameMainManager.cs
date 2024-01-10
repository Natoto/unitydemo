using System;
using System.Collections;
using System.Collections.Generic;
using Lean;
using RVO;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.Assertions.Comparers;
//using UnityEngine.Experimental.UIElements;
using Random = System.Random;
using Vector2 = RVO.Vector2;

public class GameMainManager : SingletonBehaviour<GameMainManager>
{
    public GameObject agentPrefab;

    [HideInInspector] public Vector2 mousePosition;
    public GameObject planeObject;
    public float maxSpeed = 20.0f;
    public float neighborDist = 15.0f;
    public int maxNeighbors = 10;
    public float timeHorizon = 5;
    public float timeHorizonObst = 5;
    public float radius = 2;

    private Plane m_hPlane = new Plane(Vector3.up, Vector3.zero);
    private Dictionary<int, GameAgent> m_agentMap = new Dictionary<int, GameAgent>();

    // Use this for initialization
    void Start()
    {
        //m_hPlane.SetNormalAndPosition(planeObject.transform.up, planeObject.transform.position);

        Simulator.Instance.setTimeStep(0.25f);
        //public void setAgentDefaults(float neighborDist, int maxNeighbors, float timeHorizon, float timeHorizonObst, float radius, float maxSpeed, Vector2 velocity


        Simulator.Instance.setAgentDefaults(neighborDist, maxNeighbors, timeHorizon, timeHorizonObst, radius, maxSpeed, new Vector2(0.0f, 0.0f));

        // add in awake
        Simulator.Instance.processObstacles();
    }

    private void UpdateMousePosition()
    {
        Vector3 position = new Vector3(mousePosition.x_,0, mousePosition.y_); //Vector3.zero;
        Ray mouseRay = Camera.main.ScreenPointToRay(Input.mousePosition);
        float rayDistance;
        if (m_hPlane.Raycast(mouseRay, out rayDistance))
            position = mouseRay.GetPoint(rayDistance);

        mousePosition.x_ = position.x;
        mousePosition.y_ = position.z;
    }

    void DeleteAgent()
    {
        //float rangeSq = float.MaxValue;
        //int agentNo = Simulator.Instance.queryNearAgent(mousePosition, 1.5f);
        //if (agentNo == -1 || !m_agentMap.ContainsKey(agentNo))
        //    return;
         
        //Simulator.Instance.delAgent(agentNo);
        //LeanPool.Despawn(m_agentMap[agentNo].gameObject);
        //m_agentMap.Remove(agentNo);
    }

    void CreatAgent()
    {
        int sid = Simulator.Instance.addAgent(mousePosition);
        if (sid >= 0)
        {
            //Instantiate(agentPrefab, agentPrefab.transform);
            //Vector3 position = new Vector3(mousePosition.x(), agentPrefab.transform.position.y, mousePosition.y());
            GameObject go = LeanPool.Spawn(agentPrefab, new Vector3(mousePosition.x(), agentPrefab.transform.position.y , mousePosition.y()), Quaternion.identity);
            GameAgent ga = go.GetComponent<GameAgent>();
            Assert.IsNotNull(ga);
            //ga.sid = sid;
            //m_agentMap.Add(sid, ga);
        }
    }

    // Update is called once per frame
    private void Update()
    {
        UpdateMousePosition();
   
        if (Input.GetMouseButtonUp(0))
        {
            if (Input.GetKey(KeyCode.Delete))
            {
                DeleteAgent();
            }
            else
            {
                CreatAgent();
            }
        }

        Simulator.Instance.doStep();
    }
}