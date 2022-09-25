using System;
using JetBrains.Annotations;
using UnityEngine;

namespace GPUNoiseGenerator.Generators
{
    public class PerlinNoise3DExecutor : PerlinNoiseExecutor
    {

        public Vector3 Offset
        {
            get => _offset;
            set
            {
                _offset = value;
                shader.SetVector("offset", _offset);
            }
        }
        
        private Vector3 _offset;

        public PerlinNoise3DExecutor()
        {
            shader = (ComputeShader)Resources.Load("NoiseGenerator3D");
            if (shader == null)
            {
                throw new Exception("Couldn't find ComputeShader");
            }
            Octaves = 8;
            Persistence = 0.5f;
            Scale = 1f;
            Offset = Vector3.zero;
        }
        
        public override int GetKernelId()
        {
            return shader.FindKernel("PerlinNoise3D");
        }

        public override void Execute()
        {
            shader.Dispatch(GetKernelId(), renderTexture.width/8, renderTexture.height/8, renderTexture.volumeDepth/8);
        }
    }
}