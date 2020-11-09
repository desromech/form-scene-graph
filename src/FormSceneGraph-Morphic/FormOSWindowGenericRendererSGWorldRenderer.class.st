Class {
	#name : #FormOSWindowGenericRendererSGWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #operations }
FormOSWindowGenericRendererSGWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRecorder [
	| renderer |
	renderer := self osWindowRenderer.
	renderer scene rootNode: newSceneGraph.
	renderer updateAll.

]

{ #category : #initialization }
FormOSWindowGenericRendererSGWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	^ osWindow renderer ifNil: [
		osWindow newGenericRenderer.
		osWindow renderer scene: FormSGOSWindowGenericRendererScene new.
		osWindow renderer
	].
	
]
