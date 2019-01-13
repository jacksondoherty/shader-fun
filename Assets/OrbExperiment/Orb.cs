using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Orb : MonoBehaviour
{
    private float range = 0.1f;

    private void Start()
    {
        Mesh mesh = GetComponent<MeshFilter>().mesh;
        Vector3[] vertices = mesh.vertices;

        Color[] colors = new Color[vertices.Length];

        for (int i = 0; i < vertices.Length; i++)
        {
            colors[i] = new Color(Random.Range(-1* range, range), Random.Range(-1* range, range), Random.Range(-1 * range, range));
        }

        mesh.colors = colors;
    }
}
