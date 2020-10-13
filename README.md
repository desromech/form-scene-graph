# Form Scene Graph
## Rendering framework inspired on GSK for Pharo.

### Loading the framework in Pharo
```smalltalk
"Scene graph renderin framework"
Metacello new
   baseline: 'FormSceneGraph';
   repository: 'github://ronsaldo/form-scene-graph';
   load.
```
### Enabling the new renderer on the main Pharo window.
For enabling this new renderer for the Pharo Morphic World, in addition to loading
this baseline it is required to also enable its usage through the *Settings browser*:

![Renderer Enabling Setting](images/enable-settings.png)

The effect of changing this setting is only visible after restarting the image by doing a save and quit.

### Extra: opening external windows (Very experimental)
```smalltalk
"Open an external world with the athens based scene graph renderer."
FormSGAthensWorldMorph new open.

"Open an external world with the SDL2 based renderer. Font texture caching is currently slow."
FormSGWorldMorph new open.
```
