using System;
using JetBrains.Annotations;
using UnityEngine;

namespace GPUNoiseGenerator.Generators
{
    public class PerlinNoise2DExecutor : IPerlinNoiseExecutor<Vector2>
    {
        private static string _perlinNoiseKernel = "PerlinNoise2D";
            
        private ComputeShader _shader;
        private RenderTexture _renderTexture;
        private int _octaves;
        private Vector2Int _imageSize;
        private Vector2 _offset;
        private float _scale;
        private float _persistence;
        private int _seed;

        public PerlinNoise2DExecutor(int octaves = 1, float scale = 1f,
            float persistence = 0.5f, int seed = 1)
        {
            _shader = (ComputeShader)Resources.Load("NoiseGenerator");
            SetOctaves(octaves)
                .SetScale(scale)
                .SetPersistence(persistence)
                .SetOffset(Vector2.zero)
                .SetSeed(seed);
        }

        public IPerlinNoiseExecutor<Vector2> SetOctaves(int octaves)
        {
            _octaves = octaves;
            _shader.SetInt("octaves", _octaves);
            return this;
        }

        public IPerlinNoiseExecutor<Vector2> SetOffset(Vector2 offset)
        {
            _offset = offset;
            _shader.SetFloats("offset", _offset.x, _offset.y);
            return this;
        }

        public IPerlinNoiseExecutor<Vector2> AddOffset(Vector2 offset)
        {
            return SetOffset(_offset + offset);
        }

        public IPerlinNoiseExecutor<Vector2> SetScale(float scale)
        {
            _scale = scale;
            _shader.SetFloat("scale", _scale);
            return this;
        }

        public IPerlinNoiseExecutor<Vector2> SetPersistence(float persistence)
        {
            _persistence = persistence;
            _shader.SetFloat("persistence", persistence);
            return this;
        }

        public IPerlinNoiseExecutor<Vector2> SetSeed(int seed)
        {
            _seed = seed;
            _shader.SetInt("seed", seed);
            return this;
        }

        public IPerlinNoiseExecutor<Vector2> SetRenderTexture(RenderTexture tex)
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
            _shader.SetFloats("image_size", _renderTexture.width, _renderTexture.height);
            _shader.SetTexture(_shader.FindKernel(_perlinNoiseKernel), "result", tex);

            return this;
        }

        public RenderTexture GetRenderTexture()
        {
            return _renderTexture;
        }

        public IPerlinNoiseExecutor<Vector2> Execute()
        {
            _shader.Dispatch(_shader.FindKernel(_perlinNoiseKernel), _renderTexture.width/8, _renderTexture.height/8, 1);
            return this;
        }
    }
}