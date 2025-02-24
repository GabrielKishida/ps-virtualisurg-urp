using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ThicknessRenderPass : ScriptableRenderPass
{
    RenderTargetHandle backfaceDepthTexture;
    private Material backfaceMaterial;
    private FilteringSettings filteringSettings;
    private ShaderTagId shaderTagId = new ShaderTagId("UniversalForward");

    public ThicknessRenderPass(Material backfaceMaterial)
    {
        this.backfaceMaterial = backfaceMaterial;
        this.renderPassEvent = RenderPassEvent.BeforeRenderingOpaques;
        filteringSettings = new FilteringSettings(RenderQueueRange.opaque);
        backfaceDepthTexture.Init("_BackfaceDepthTexture");
    }

    public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
    {
        RenderTextureDescriptor desc = cameraTextureDescriptor;
        desc.colorFormat = RenderTextureFormat.RFloat;
        desc.depthBufferBits = 32;
        cmd.GetTemporaryRT(backfaceDepthTexture.id, desc, FilterMode.Bilinear);
        ConfigureTarget(backfaceDepthTexture.Identifier());
        ConfigureClear(ClearFlag.All, Color.clear);
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        CommandBuffer cmd = CommandBufferPool.Get("Thickness Backface Pass");

        using (new ProfilingScope(cmd, new ProfilingSampler("ThicknessBackfacePass")))
        {
            context.ExecuteCommandBuffer(cmd);
            cmd.Clear();

            var drawSettings = CreateDrawingSettings(shaderTagId, ref renderingData, SortingCriteria.CommonOpaque);
            drawSettings.overrideMaterial = backfaceMaterial;

            context.DrawRenderers(renderingData.cullResults, ref drawSettings, ref filteringSettings);
            cmd.SetGlobalTexture("_BackfaceDepthTexture", backfaceDepthTexture.Identifier());
        }

        context.ExecuteCommandBuffer(cmd);
        CommandBufferPool.Release(cmd);
    }

    public override void OnCameraCleanup(CommandBuffer cmd)
    {
        cmd.ReleaseTemporaryRT(backfaceDepthTexture.id);
    }
}
