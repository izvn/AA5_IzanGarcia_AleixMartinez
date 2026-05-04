using UnityEngine;
using UnityEngine.InputSystem;

public class PostProcessController : MonoBehaviour
{
    [Header("Materiales de Post-Procesado")]
    public Material matVignette;
    public Material matChromatic;
    public Material matGradient;
    public Material matDistortion;
    public Material matCRT;
    public Material matPixelated;

   

    private string keyword = "EFFECT_ON";

    void Update()
    {
        if (Keyboard.current == null) return;

        if (Keyboard.current.digit1Key.wasPressedThisFrame) { Debug.Log("Tecla 1"); ToggleEffect(matVignette); }
        if (Keyboard.current.digit2Key.wasPressedThisFrame) { Debug.Log("Tecla 2"); ToggleEffect(matChromatic); }
        if (Keyboard.current.digit3Key.wasPressedThisFrame) { Debug.Log("Tecla 3"); ToggleEffect(matGradient); }
        if (Keyboard.current.digit4Key.wasPressedThisFrame) { Debug.Log("Tecla 4"); ToggleEffect(matDistortion); }
        if (Keyboard.current.digit5Key.wasPressedThisFrame) { Debug.Log("Tecla 5"); ToggleEffect(matCRT); }
        if (Keyboard.current.digit6Key.wasPressedThisFrame) { Debug.Log("Tecla 6"); ToggleEffect(matPixelated); }
    }

    void ToggleEffect(Material mat)
    {
        if (mat == null) return;

        // apagar/encender
        if (mat.IsKeywordEnabled(keyword))
        {
            mat.DisableKeyword(keyword);
            Debug.Log("Apagando efecto en: " + mat.name);
        }
        else
        {
            mat.EnableKeyword(keyword);
            Debug.Log("Encendiendo efecto en: " + mat.name);
        }
    }
}