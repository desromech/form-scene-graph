# Form Scene Graph
## Rendering framework inspired on GSK for Pharo.


```smalltalk
"Scene graph renderin framework"
Metacello new
   baseline: 'FormSceneGraph';
   repository: 'github://ronsaldo/form-scene-graph';
   load.

"Open an external world with the athens based scene graph renderer."
FormSGAthensWorldMorph new open.

"Open an external world with the SDL2 based renderer. Font texture caching is currently slow."
FormSGWorldMorph new open.
```

