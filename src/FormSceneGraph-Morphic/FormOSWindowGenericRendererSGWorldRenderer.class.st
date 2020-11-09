Class {
	#name : #FormOSWindowGenericRendererSGWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #operations }
FormOSWindowGenericRendererSGWorldRenderer >> displayNewSceneScene: newSceneGraph [
	| renderer |
	renderer := self osWindowRenderer.
	renderer scene rootNode: newSceneGraph.
	renderer updateAll.

]

{ #category : #initialization }
FormOSWindowGenericRendererSGWorldRenderer >> osWindowRenderer [
		
	^ osWindow renderer ifNil: [
		osWindow newGenericRenderer.
		osWindow renderer scene: FormSGOSWindowGenericRendererScene new.
		osWindow renderer
	].
	
]
