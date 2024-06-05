Class {
	#name : 'FormOSWindowGenericRendererSGWorldRenderer',
	#superclass : 'FormSGAbstractWorldRenderer',
	#category : 'FormSceneGraph-MorphicP12-WorldRenderer',
	#package : 'FormSceneGraph-MorphicP12',
	#tag : 'WorldRenderer'
}

{ #category : 'operations' }
FormOSWindowGenericRendererSGWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	| renderer |
	renderer := self osWindowRenderer.
	renderer scene
		surfaceScaleFactor: self scaleFactor;
		rootNode: newSceneGraph.
	renderer updateRectangle: damageRectangle.

]

{ #category : 'initialization' }
FormOSWindowGenericRendererSGWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	^ osWindow renderer ifNil: [
		osWindow newGenericRenderer.
		osWindow renderer scene: FormSGOSWindowGenericRendererScene new.
		osWindow renderer
	].
	
]
