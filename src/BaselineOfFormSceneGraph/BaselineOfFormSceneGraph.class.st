Class {
	#name : 'BaselineOfFormSceneGraph',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFormSceneGraph',
	#package : 'BaselineOfFormSceneGraph'
}

{ #category : 'baselines' }
BaselineOfFormSceneGraph >> baseline: spec [
    <baseline>

	spec for: #'pharo11.x' do: [ self baselineForPharo11: spec ].
	spec for: #pharo do: [ self baselineForPharo: spec ].
	spec for: #squeak do: [ self baselineForSqueak: spec ].
]

{ #category : 'baselines' }
BaselineOfFormSceneGraph >> baselineForPharo11: spec [
	spec 
		baseline: 'UFFIOpenGL' with: [
			spec repository: 'github://ronsaldo/uffi-opengl'
		];
		baseline: 'AbstractGPU' with: [
			spec repository: 'github://ronsaldo/abstract-gpu'
		];

		package: 'FormSceneGraph-Core';
		package: 'FormSceneGraph-Core-Tests' with: [ spec requires: 'FormSceneGraph-Core' ];
		package: 'FormSceneGraph-FreeTypeFontSupport' with: [ spec requires: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer')];
		package: 'FormSceneGraph-Renderer' with: [ spec requires: #('FormSceneGraph-Core')];
		package: 'FormSceneGraph-RendererAthens' with: [ spec requires: 'FormSceneGraph-Renderer' ];
		package: 'FormSceneGraph-RendererOSWindow' with: [ spec requires: 'FormSceneGraph-Renderer' ];
		package: 'FormSceneGraph-Morphic' with: [ spec requires: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer' 'FormSceneGraph-RendererAthens' 'FormSceneGraph-RendererOSWindow') ];
		package: 'FormSceneGraph-Roassal' with: [ spec requires: 'FormSceneGraph-Morphic' ];
		package: 'FormSceneGraph-OpenGLESRenderer' with: [ spec requires: #('FormSceneGraph-Renderer' 'UFFIOpenGL') ];
		package: 'FormSceneGraph-AbstractGPURenderer' with: [ spec requires: #('FormSceneGraph-Renderer' 'AbstractGPU') ];
		package: 'FormSceneGraph-AbstractGPURendererMorphic' with: [ spec requires: #('FormSceneGraph-AbstractGPURenderer') ];
		
		group: 'default' with: #('Core' 'Tests' 'UI');
		group: 'Core' with: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer' 'FormSceneGraph-RendererAthens' 'FormSceneGraph-RendererOSWindow' 'FormSceneGraph-FreeTypeFontSupport');
		group: 'Tests' with: #('FormSceneGraph-Core-Tests');
		group: 'UI' with: #('FormSceneGraph-Morphic' 'FormSceneGraph-Roassal');
		group: 'OpenGL' with: #('FormSceneGraph-OpenGLESRenderer');
		group: 'AbstractGPURenderer' with: #('FormSceneGraph-AbstractGPURenderer' 'FormSceneGraph-AbstractGPURendererMorphic');

		group: 'AcceleratedOpenGL' with: #(Core UI Tests OpenGL);
		group: 'AcceleratedAbstractGPU' with: #(Core UI Tests AbstractGPURenderer);
		group: 'Accelerated' with: #(AcceleratedOpenGL AcceleratedAbstractGPU)

]

{ #category : 'baselines' }
BaselineOfFormSceneGraph >> baselineForPharo: spec [
	spec 
		baseline: 'UFFIOpenGL' with: [
			spec repository: 'github://ronsaldo/uffi-opengl'
		];
		baseline: 'AbstractGPU' with: [
			spec repository: 'github://ronsaldo/abstract-gpu'
		];

		package: 'FormSceneGraph-Core';
		package: 'FormSceneGraph-Core-Tests' with: [ spec requires: 'FormSceneGraph-Core' ];
		package: 'FormSceneGraph-FreeTypeFontSupport' with: [ spec requires: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer')];
		package: 'FormSceneGraph-Renderer' with: [ spec requires: #('FormSceneGraph-Core')];
		package: 'FormSceneGraph-RendererAthens' with: [ spec requires: 'FormSceneGraph-Renderer' ];
		package: 'FormSceneGraph-RendererOSWindow' with: [ spec requires: 'FormSceneGraph-Renderer' ];
		package: 'FormSceneGraph-MorphicP12' with: [ spec requires: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer' 'FormSceneGraph-RendererAthens' 'FormSceneGraph-RendererOSWindow') ];
		package: 'FormSceneGraph-Roassal' with: [ spec requires: 'FormSceneGraph-MorphicP12' ];
		package: 'FormSceneGraph-OpenGLESRenderer' with: [ spec requires: #('FormSceneGraph-Renderer' 'UFFIOpenGL') ];
		package: 'FormSceneGraph-AbstractGPURenderer' with: [ spec requires: #('FormSceneGraph-Renderer' 'AbstractGPU') ];
		package: 'FormSceneGraph-AbstractGPURendererMorphic' with: [ spec requires: #('FormSceneGraph-AbstractGPURenderer') ];
		
		group: 'default' with: #('Core' 'Tests' 'UI');
		group: 'Core' with: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer' 'FormSceneGraph-RendererAthens' 'FormSceneGraph-RendererOSWindow' 'FormSceneGraph-FreeTypeFontSupport');
		group: 'Tests' with: #('FormSceneGraph-Core-Tests');
		group: 'UI' with: #('FormSceneGraph-MorphicP12' 'FormSceneGraph-Roassal');
		group: 'OpenGL' with: #('FormSceneGraph-OpenGLESRenderer');
		group: 'AbstractGPURenderer' with: #('FormSceneGraph-AbstractGPURenderer' 'FormSceneGraph-AbstractGPURendererMorphic');

		group: 'AcceleratedOpenGL' with: #(Core UI Tests OpenGL);
		group: 'AcceleratedAbstractGPU' with: #(Core UI Tests AbstractGPURenderer);
		group: 'Accelerated' with: #(AcceleratedOpenGL AcceleratedAbstractGPU)

]

{ #category : 'baselines' }
BaselineOfFormSceneGraph >> baselineForSqueak: spec [
	spec 
		baseline: 'AbstractGPU' with: [
			spec repository: 'github://ronsaldo/abstract-gpu'
		];
		package: 'FormSceneGraph-SqueakCompatibility';
		package: 'FormSceneGraph-Core' with: [ spec requires: 'FormSceneGraph-SqueakCompatibility' ];
		package: 'FormSceneGraph-Core-Tests' with: [ spec requires: 'FormSceneGraph-Core' ];
		package: 'FormSceneGraph-Renderer' with: [ spec requires: 'FormSceneGraph-Core' ];
		package: 'FormSceneGraph-AbstractGPURenderer' with: [ spec requires: #('FormSceneGraph-Renderer' 'AbstractGPU') ];
		
		group: 'default' with: #('Core' 'Tests');
		group: 'Core' with: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer');
		group: 'Tests' with: #('FormSceneGraph-Core-Tests');
		group: 'AbstractGPURenderer' with: #('FormSceneGraph-AbstractGPURenderer');

		group: 'AcceleratedAbstractGPU' with: #(Core Tests AbstractGPURenderer);
		group: 'Accelerated' with: #(AcceleratedAbstractGPU)
]
