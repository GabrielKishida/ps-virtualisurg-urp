using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class ThicknessRenderFeature : ScriptableRendererFeature
{
    public Material backfaceMaterial;
    private ThicknessRenderPass thicknessRenderPass;

    public override void Create()
    {
        if (backfaceMaterial != null)
        {
            thicknessRenderPass = new ThicknessRenderPass(backfaceMaterial);
        }
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (thicknessRenderPass != null)
        {
            renderer.EnqueuePass(thicknessRenderPass);
        }
    }
}
