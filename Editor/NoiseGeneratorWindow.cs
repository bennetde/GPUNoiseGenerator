using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.UIElements;
using Button = UnityEngine.UIElements.Button;

namespace GPUNoiseGenerator.Editor
{
    public class NoiseGeneratorWindow : EditorWindow
    {
        private ComputeShader _shader;
        private RenderTexture _renderTexture;
        private Texture2D _texture;
        private Image _imagePreview;

        private DropdownField _imageDimensionsDropdown;
        private DropdownField _noiseTypeDropdown;
        private DropdownField _imageSizeDropdown;

        private static readonly Dictionary<string, string> NoiseTypeToKernel = new()
        {
            { "Static", "StaticNoise" },
            { "Perlin", "PerlinNoise" },
            { "Worley", "Worley" },
            { "Voronoi", "Voronoi" }
        };

        [MenuItem("Tools/Noise Generator")]
        public static void Open()
        {
            EditorWindow wnd = GetWindow<NoiseGeneratorWindow>();
            wnd.titleContent = new GUIContent("Noise Texture Generator");
        }

        public void CreateGUI()
        {
            _shader = (ComputeShader)Resources.Load("NoiseGenerator");
            _texture = new Texture2D(1024, 1024);

            _imageDimensionsDropdown = new DropdownField("Dimensions")
            {
                choices = new List<string> { "2D" },
                value = "2D"
            };
            _renderTexture = new RenderTexture(1024, 1024, 32)
            {
                enableRandomWrite = true
            };
            _renderTexture.Create();
            _noiseTypeDropdown = new DropdownField("Noise Type")
            {
                choices = NoiseTypeToKernel.Keys.ToList(),
                value = "Static"
            };

            _imageSizeDropdown = new DropdownField("Image Size")
            {
                choices = new List<string> { "32", "64", "128", "256", "512", "1024", "2048", "4096", "8192", "16384" },
                value = "1024"
            };

            _imageSizeDropdown.RegisterValueChangedCallback(evt =>
            {
                var newSize = int.Parse(evt.newValue);
                Resize(newSize, newSize);
            });

            rootVisualElement.Add(_imageDimensionsDropdown);
            rootVisualElement.Add(_noiseTypeDropdown);
            rootVisualElement.Add(_imageSizeDropdown);

            var settingsLabel = new Label("Settings:");
            var octavesSlider = new SliderInt
            {
                label = "Octaves",
                highValue = 32,
                lowValue = 1,
                showInputField = true,
                value = 8
            };
            octavesSlider.RegisterValueChangedCallback(evt => { _shader.SetInt("octaves", evt.newValue); });
            var scale = new Slider()
            {
                label = "Scale",
                highValue = 3000f,
                lowValue = 1f,
                showInputField = true,
                value = 1,
            };
            scale.RegisterValueChangedCallback(evt => { _shader.SetFloat("scale", evt.newValue); });
            var persistenceSlider = new Slider()
            {
                label = "Persistence",
                highValue = 1f,
                lowValue = 0f,
                showInputField = true,
                value = 0.2f
            };
            persistenceSlider.RegisterValueChangedCallback(evt => { _shader.SetFloat("persistence", evt.newValue); });

            var seedInput = new IntegerField()
            {
                label = "Seed",
            };
            seedInput.RegisterValueChangedCallback(evt => { _shader.SetInt("seed", evt.newValue); });

            rootVisualElement.Add(settingsLabel);
            rootVisualElement.Add(octavesSlider);
            rootVisualElement.Add(persistenceSlider);
            rootVisualElement.Add(scale);
            rootVisualElement.Add(seedInput);

            _imagePreview = new Image
            {
                image = _texture
            };
            rootVisualElement.Add(_imagePreview);

            var saveButton = new Button
            {
                text = "Save as PNG"
            };
            saveButton.clicked += Save;
            rootVisualElement.Add(saveButton);
        }

        public void OnDestroy()
        {
            // Release RenderTexture to not trash GPU memory
            if (_renderTexture.IsCreated())
            {
                _renderTexture.Release();
            }
        }

        private string GetCurrentKernel()
        {
            return NoiseTypeToKernel[_noiseTypeDropdown.value] + _imageDimensionsDropdown.value;
        }

        private void Resize(int newWidth, int newHeight)
        {
            Debug.Log("Resize");
            if (_renderTexture.IsCreated())
            {
                _renderTexture.Release();
            }

            _renderTexture = new RenderTexture(newWidth, newHeight, 32)
            {
                enableRandomWrite = true
            };
            _renderTexture.Create();
            _texture = new Texture2D(newWidth, newHeight);
        }

        private void DispatchShader()
        {
            var kernelIndex = _shader.FindKernel(GetCurrentKernel());
            _shader.SetTexture(kernelIndex, "result", _renderTexture);
            _shader.SetFloats("image_size", _renderTexture.width, _renderTexture.height);
            _shader.Dispatch(kernelIndex, _renderTexture.width / 8, _renderTexture.height / 8, 1);
        }

        private void Save()
        {
            var path = EditorUtility.SaveFilePanelInProject("Save texture as PNG", "", "png", "Message");
            if (path.Length > 0)
            {
                var data = (_imagePreview.image as Texture2D).EncodeToPNG();
                File.WriteAllBytes(path, data);
            }
        }

        private void Update()
        {
            _shader.SetFloat("time", Time.realtimeSinceStartup);
            DispatchShader();
            _imagePreview.image = _renderTexture.ToTexture2D();
        }
    }

    static class Util
    {
        public static Texture2D ToTexture2D(this RenderTexture rTex)
        {
            var tex = new Texture2D(rTex.width, rTex.height, rTex.graphicsFormat, TextureCreationFlags.None);
            var oldRT = RenderTexture.active;
            RenderTexture.active = rTex;

            tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
            tex.Apply();

            RenderTexture.active = oldRT;
            return tex;
        }
    }

}