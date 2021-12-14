# Form Scene Graph
## Rendering framework inspired on GSK for Pharo.

### Loading the framework in Pharo

For loading this framework with the default software based backend, you need to
execute the following script in a playground:

```smalltalk
"Scene graph rendering framework"
Metacello new
   baseline: 'FormSceneGraph';
   repository: 'github://ronsaldo/form-scene-graph';
   onConflictUseIncoming;
   load.
```

If you feel adventurous, and want to try the experiment OpenGL ES accelerated backend, you need
to load it with the following script in a playground, and then select it in the *Setting browser*:

```smalltalk
"Scene graph rendering framework"
Metacello new
   baseline: 'FormSceneGraph';
   repository: 'github://ronsaldo/form-scene-graph';
   onConflictUseIncoming;
   load: #AcceleratedOpenGL.
```

If you feel even more adventurous, and want to try the experiment AbstractGPU accelerated backend (Vulkan, Metal and Direct3D 12), you need
to load it with the following script in a playground, and then select it in the *Setting browser*:

```smalltalk
"Scene graph rendering framework"
Metacello new
   baseline: 'FormSceneGraph';
   repository: 'github://ronsaldo/form-scene-graph';
   onConflictUseIncoming;
   load: #AcceleratedAbstractGPU.
```

### Enabling the new renderer on the main Pharo window.
For enabling this new renderer for the Pharo Morphic World, in addition to loading
this baseline it is required to also enable its usage through the *Settings browser*:

![Renderer Enabling Setting](images/enable-settings.png)

The effect of changing this setting is only visible after restarting the image by doing a save and quit.

### Comparison
The followings are comparisons with a scale factor of 1.5:

Old Renderer at 1.5x:
![Old Renderer 1.5x](images/old-renderer-150.png)

New Renderer at 1.5x with Athens backend:
![New Renderer 1.5x](images/new-renderer-150-athens.png)

New Renderer at 1.5x with OSWindow SDL2 renderer backend:
![New Renderer 1.5x](images/new-renderer-150-sdl2.png)

### Extra: opening external windows (Very experimental)
```smalltalk
"Open an external world with the Athens based scene graph renderer. (Most of the work goes here)"
FormSGAthensWorldMorph new open.

"Open an external world with the SDL2 based renderer."
FormOSWindowGenericRendererSGWorldRenderer new open.

"Open an external world with the BitBlt based renderer. (Incomplete)"
FormSGCanvasWorldMorph new open.

"Open an external world with the OpenGL ES based scene graph renderer. (Experimental, may be unstable)"
FormSGOpenGLESRendererWorldMorph new open.

"Open an external world with the AbstractGPU based scene graph renderer. (Experimental, may be unstable)"
FormSGAGPURendererWorldMorph new open.

```
