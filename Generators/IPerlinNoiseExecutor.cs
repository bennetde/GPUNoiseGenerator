using UnityEngine;

namespace GPUNoiseGenerator.Generators
{
    public interface IPerlinNoiseExecutor<in T>
    {
        public IPerlinNoiseExecutor<T> SetOctaves(int octaves);
        public IPerlinNoiseExecutor<T> SetScale(float scale);
        public IPerlinNoiseExecutor<T> SetOffset(T offset);
        public IPerlinNoiseExecutor<T> AddOffset(T offset);
        public IPerlinNoiseExecutor<T> SetPersistence(float persistence);
        public IPerlinNoiseExecutor<T> SetSeed(int seed);
        public IPerlinNoiseExecutor<T> SetRenderTexture(RenderTexture t);
        public RenderTexture GetRenderTexture();
        public IPerlinNoiseExecutor<T> Execute();

    }
}