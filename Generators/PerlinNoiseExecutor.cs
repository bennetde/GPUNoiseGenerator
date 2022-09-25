using System;
using UnityEngine;
using UnityEngine.Rendering;

namespace GPUNoiseGenerator.Generators
{
    public abstract class PerlinNoiseExecutor
    {
        public RenderTexture RenderTexture => renderTexture;
        public int Octaves
        {
            get => _octaves;
            set
            {
                _octaves = value;
                shader.SetInt("octaves", _octaves);
            }
        }

        public float Scale
        {
            get => _scale;
            set
            {
                _scale = value;
                shader.SetFloat("scale", _scale);
            }
        }

        public int Seed
        {
            get => _seed;
            set
            {
                _seed = value;
                shader.SetInt("seed", _seed);
            }
        }

        public float Persistence
        {
            get => _persistence;
            set
            {
                _persistence = value;
                shader.SetFloat("persistence", _persistence);
            }
        }

        public bool Tiling
        {
            get => _tiling;
            set
            {
                _tiling = value;
                shader.SetBool("tiling", _tiling);
            }
        }

        protected RenderTexture renderTexture;
        protected ComputeShader shader;
        private int _octaves;
        private float _scale;
        private int _seed;
        private float _persistence;
        private bool _tiling;
        
        public abstract int GetKernelId();

        public void SetRenderTexture(RenderTexture tex)
        {
            // TODO: Figure out if it is required to have RenderTexture.Create() called beforehand or if it is fine letting the engine create it itself.
            if (!tex.enableRandomWrite)
            {
                throw new ArgumentException("RenderTexture needs to have enableRandomWrite enabled");
            }
            renderTexture = tex;
            switch (renderTexture.dimension)
            {
                case TextureDimension.Tex2D:
                    shader.SetFloats("image_size", renderTexture.width, renderTexture.height);
                    break;
                case TextureDimension.Tex3D:
                    shader.SetFloats("image_size", renderTexture.width, renderTexture.height,
                        renderTexture.volumeDepth);
                    break;
                default:
                    throw new ArgumentException("Unsupported TextureDimension (needs to be Tex2D or Tex3D)");
            }
            shader.SetTexture(GetKernelId(), "result", tex);
        }
        public abstract void Execute();

        // public PerlinNoiseExecutor<T> SetOctaves(int octaves)
        // {
        //     this.octaves = octaves;
        //     shader.SetInt("octaves", octaves);
        //     return this;
        // }
        //
        // public PerlinNoiseExecutor<T> SetScale(float scale)
        // {
        //     this.scale = scale;
        //     shader.SetFloat("scale", scale);
        //     return this;
        // }
        //
        // public PerlinNoiseExecutor<T> SetSeed(int seed)
        // {
        //     this.seed = seed;
        //     shader.SetInt("seed", seed);
        //     return this;
        // }
        //
        // public PerlinNoiseExecutor<T> SetPersistence(float persistence)
        // {
        //     this.persistence = persistence;
        //     shader.SetFloat("persistence", persistence);
        //     return this;
        // }


    }
}