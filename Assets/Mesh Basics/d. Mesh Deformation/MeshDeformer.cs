using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
public class MeshDeformer : MonoBehaviour 
{
	public float springForce = 20f;
	public float damping = 5f;

	Mesh deformingMesh;
	Vector3[] originalVertices, displacedVertices;
    Vector3[] vertexVelocities;

	// for nonuniformscales,
	// You could use a 3D vector instead of a single value for the scale. 
	// Then adjust each dimension separately. But really, you don't want to deal with nonuniform scales.
	float uniformScale = 1f;

	// We're using Start so procedural meshes can be generated in Awake, which is always invoked first. 
	// This approach relies on other components taking care of their stuff in Awake, so it is no guarantee.
	void Start () 
	{
		deformingMesh = GetComponent<MeshFilter>().mesh;
		originalVertices = deformingMesh.vertices;
		displacedVertices = new Vector3[originalVertices.Length];
		for (int i = 0; i < originalVertices.Length; i++) {
			displacedVertices[i] = originalVertices[i];
		}
		vertexVelocities = new Vector3[originalVertices.Length];
	}

	void Update () {
		uniformScale = transform.localScale.x;
		for (int i = 0; i < displacedVertices.Length; i++) {
			UpdateVertex(i);
		}
		deformingMesh.vertices = displacedVertices;
		deformingMesh.RecalculateNormals();
	}

	void UpdateVertex (int i) {
		Vector3 velocity = vertexVelocities[i];
		Vector3 displacement = displacedVertices[i] - originalVertices[i];
		displacement *= uniformScale;
		velocity -= displacement * springForce * Time.deltaTime;
		velocity *= 1f - damping * Time.deltaTime;
		vertexVelocities[i] = velocity;
		displacedVertices[i] += velocity * (Time.deltaTime / uniformScale);
	}
	
	public void AddDeformingForce (Vector3 point, float force) 
	{
		point = transform.InverseTransformPoint(point);
		for (int i = 0; i < displacedVertices.Length; i++) 
		{
			AddForceToVertex(i, point, force);
		}
	}

	void AddForceToVertex (int i, Vector3 point, float force) 
	{
		Vector3 pointToVertex = displacedVertices[i] - point;
		pointToVertex *= uniformScale;
		float attenuatedForce = force / (1f + pointToVertex.sqrMagnitude);
		float velocity = attenuatedForce * Time.deltaTime;
		vertexVelocities[i] += pointToVertex.normalized * velocity;
	}
}
