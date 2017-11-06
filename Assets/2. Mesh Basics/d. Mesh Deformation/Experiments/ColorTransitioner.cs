using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorTransitioner : MonoBehaviour {

	public float fadeTimeSeconds = 2f;

	float currentLerp;
	bool lerping = false;
	Color firstColor;
	Color secondColor;

	void Update()
	{
		if (lerping) 
		{
			HandleLerp ();
		}
	}



	void HandleLerp()
	{
		currentLerp += Time.deltaTime / fadeTimeSeconds;

		Camera.main.backgroundColor = Color.Lerp(
			firstColor, 
			secondColor, 
			currentLerp);

		if (currentLerp >= 1) 
		{
			lerping = false;
			currentLerp = 0;
		}
	}
}
