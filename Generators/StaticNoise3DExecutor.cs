using System;
using JetBrains.Annotations;
using UnityEngine;

namespace GPUNoiseGenerator.Generators
{
    public class StaticNoise3DExecutor
    {
        private static string _staticNoiseKernel = "StaticNoise3D";
            
        private ComputeShader _shader;
        private RenderTexture _renderTexture;
        private Vector3Int _imageSize;
        private Vector3 _offset;
        private float _scale;
        private int _seed;

        public StaticNoise3DExecutor(float scale = 1f, int seed = 1)
        {
            _shader = (ComputeShader)Resources.Load("NoiseGenerator3D");
            SetScale(scale)
                .SetOffset(Vector3.zero)
                .SetSeed(seed);
        }

        public StaticNoise3DExecutor SetOffset(Vector3 offset)
        {
            _offset = offset;
            _shader.SetFloats("offset", _offset.x, _offset.y, _offset.z);
            return this;
        }
        
        public StaticNoise3DExecutor AddOffset(Vector3 offset)
        {
            return SetOffset(_offset + offset);
        }

        public StaticNoise3DExecutor SetScale(float scale)
        {
            _scale = scale;
            _shader.SetFloat("scale", _scale);
            return this;
        }
        
        public StaticNoise3DExecutor SetSeed(int seed)
        {
            _seed = seed;
            _shader.SetInt("seed", _seed);
            return this;
        }

        public StaticNoise3DExecutor SetRenderTexture(RenderTexture tex)
        {
            if (!tex.IsCreated())
            {
                throw new ArgumentException("RenderTexture needs to be created.");
            }

            if (!tex.enableRandomWrite)
            {
                throw new ArgumentException("RenderTexture needs to have enableRandomWrite enabled");
            }
            _renderTexture = tex;
            _shader.SetFloats("image_size", _renderTexture.width, _renderTexture.height, _renderTexture.volumeDepth);
            _shader.SetTexture(_shader.FindKernel(_staticNoiseKernel), "result", tex);

            return this;
        }

        public RenderTexture GetRenderTexture()
        {
            return _renderTexture;
        }

        public StaticNoise3DExecutor Execute()
        {
            _shader.Dispatch(_shader.FindKernel(_staticNoiseKernel), _renderTexture.width/8, _renderTexture.height/8, _renderTexture.volumeDepth/8);
            return this;
        }
    }
}