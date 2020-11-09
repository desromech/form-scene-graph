Class {
	#name : #FormOSWindowGenericRendererSGWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #operations }
FormOSWindowGenericRendererSGWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	| renderer |
	renderer := self osWindowRenderer.
	renderer scene rootNode: newSceneGraph.
	renderer updateRectangle: damageRectangle.

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
