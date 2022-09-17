# GPUNoiseGenerator
A Unity Utility to generate Noise Textures

The GPUNoiseGenerator (as it name suggests) provides a simple to use Editor inside Unity to generate various noise textures. As a learning project this uses Compute Shaders to use the power of GPUs. It uses the PCG as a random number generator to prevent repeating patterns at high scales.

It currently provides:
- White Noise
- Perlin Noise
- Worley Noise
- Voronoi

## Installation

Open the Unity Package Manager, press `Add package from git URL...` and insert `git@github.com:bennetde/GPUNoiseGenerator.git`. 
Afterwards, you should be able to open the Editor under `Tools->Noise Generator`.

## TODO

- [ ] 3D texture support
- [ ] Tiling textures
- [ ] API-Support for direct usage without the generator

## Screenshots
![Example of the editor generating white noise](https://github.com/bennetde/GPUNoiseGenerator/blob/main/Documentation/Screenshots/EditorNoise.png)
![Example of the editor generating perlin noise](https://github.com/bennetde/GPUNoiseGenerator/blob/main/Documentation/Screenshots/EditorPerlin.png)
![Example of the editor generating worley noise](https://github.com/bennetde/GPUNoiseGenerator/blob/main/Documentation/Screenshots/EditorVoronoi.png)
