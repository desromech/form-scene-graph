Class {
	#name : #BaselineOfFormSceneGraph,
	#superclass : #BaselineOf,
	#category : #BaselineOfFormSceneGraph
}

{ #category : #baselines }
BaselineOfFormSceneGraph >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'UFFIOpenGL' with: [
				spec repository: 'github://ronsaldo/uffi-opengl'
			];
			baseline: 'AbstractGPU' with: [
				spec repository: 'github://ronsaldo/abstract-gpu'
			];

			package: 'FormSceneGraph-Core';
			package: 'FormSceneGraph-Core-Tests' with: [ spec requires: 'FormSceneGraph-Core' ];
			package: 'FormSceneGraph-Renderer' with: [ spec requires: 'FormSceneGraph-Core' ];
			package: 'FormSceneGraph-Morphic' with: [ spec requires: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer') ];
			package: 'FormSceneGraph-Roassal' with: [ spec requires: 'FormSceneGraph-Morphic' ];
			package: 'FormSceneGraph-OpenGLESRenderer' with: [ spec requires: #('FormSceneGraph-Renderer' 'UFFIOpenGL') ];
			package: 'FormSceneGraph-AbstractGPURenderer' with: [ spec requires: #('FormSceneGraph-Renderer' 'AbstractGPU') ];
			
			group: 'default' with: #('Core' 'Tests' 'UI');
			group: 'Core' with: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer');
			group: 'Tests' with: #('FormSceneGraph-Core-Tests');
			group: 'UI' with: #('FormSceneGraph-Morphic' 'FormSceneGraph-Roassal');
			group: 'OpenGL' with: #('FormSceneGraph-OpenGLESRenderer');
			group: 'AbstractGPURenderer' with: #('FormSceneGraph-AbstractGPURenderer');

			group: 'AcceleratedOpenGL' with: #(Core UI Tests OpenGL);
			group: 'AcceleratedAbstractGPU' with: #(Core UI Tests AbstractGPURenderer);
			group: 'Accelerated' with: #(AcceleratedOpenGL AcceleratedAbstractGPU)
	]
]
