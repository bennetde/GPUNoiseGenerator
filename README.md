# GPUNoiseGenerator
A Unity Utility to generate Noise Textures

The GPUNoiseGenerator (as it name suggests) provides a simple to use Editor inside Unity to generate various noise textures. As a learning project this uses Compute Shaders to use the power of GPUs. It uses the PCG as a random number generator to prevent repeating patterns at high scales.

It currently provides:
- White Noise (2D & 3D)
- Perlin Noise (2D & 3D)
- Worley Noise (2D)
- Voronoi (2D)

## Installation

Open the Unity Package Manager, press `Add package from git URL...` and insert `git@github.com:bennetde/GPUNoiseGenerator.git`. 


## Usage
For 2D: Open the Editor window under `Tools->Noise Generator`.

For 3D: Use the classes `PerlinNoise3DExecutor` or `StaticNoise3DExecutor`.

Example:
```csharp
// Create a Render Texture on the GPU
var _renderTexture = new RenderTexture(128, 128, 0)
{
    enableRandomWrite = true, // This needs to be true 
    dimension = TextureDimension.Tex3D,
    volumeDepth = 128, // Z-Dimension Image Size
    wrapMode = TextureWrapMode.Repeat
};
_renderTexture.Create();

// i.e. set render texture to be used in a shader:
// GetComponent<Renderer>().material.SetTexture("_MainTexture", _renderTexture);

var executor = new PerlinNoise3DExecutor()
{
    Octaves = 8, // Octaves
    Persistence = 0.5f, //Persistence (between 0.0-1.0)
    Scale = 5, // Scale (needs to be an integer number for tiling to work, otherwise it can be a floating point number)
    Seed = 34030, // Random seed
    Tiling = true
};
// 
executor.SetRenderTexture(_renderTexture);
executor.Execute(); // Fill Render Texture with Perlin Noise-Data



```
## TODO

- [X] 3D texture support
- [ ] Tiling textures (3D Perlin Noise only so far)
- [ ] API-Support for direct usage without the generator (2D/3D Perlin Noise and White Noise only so far)

## Screenshots
![Example of the editor generating white noise](https://github.com/bennetde/GPUNoiseGenerator/blob/main/Documentation/Screenshots/EditorNoise.png)
![Example of the editor generating perlin noise](https://github.com/bennetde/GPUNoiseGenerator/blob/main/Documentation/Screenshots/EditorPerlin.png)
![Example of the editor generating worley noise](https://github.com/bennetde/GPUNoiseGenerator/blob/main/Documentation/Screenshots/EditorVoronoi.png)
