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

			package: 'FormSceneGraph-Core';
			package: 'FormSceneGraph-Core-Tests' with: [ spec requires: 'FormSceneGraph-Core' ];
			package: 'FormSceneGraph-Renderer' with: [ spec requires: 'FormSceneGraph-Core' ];
			package: 'FormSceneGraph-Morphic' with: [ spec requires: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer') ];
			package: 'FormSceneGraph-Roassal' with: [ spec requires: 'FormSceneGraph-Morphic' ];
			package: 'FormSceneGraph-OpenGLESRenderer' with: [ spec requires: #('FormSceneGraph-Renderer' 'UFFIOpenGL') ];
			
			group: 'default' with: #('Core' 'UI');
			group: 'Core' with: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer');
			group: 'UI' with: #('FormSceneGraph-Morphic' 'FormSceneGraph-Roassal');
			group: 'OpenGL' with: #('FormSceneGraph-OpenGLESRenderer');
			group: 'AcceleratedOpenGL' with: #(Core UI OpenGL)
	]
]
