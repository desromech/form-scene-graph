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
			package: 'FormSceneGraph-Core';
			package: 'FormSceneGraph-Core-Tests' with: [ spec requires: 'FormSceneGraph-Core' ];
			package: 'FormSceneGraph-Renderer' with: [ spec requires: 'FormSceneGraph-Core' ];
			package: 'FormSceneGraph-Morphic' with: [ spec requires: #('FormSceneGraph-Core' 'FormSceneGraph-Renderer') ]
	]
]
