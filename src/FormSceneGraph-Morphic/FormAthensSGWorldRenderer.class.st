Class {
	#name : #FormAthensSGWorldRenderer,
	#superclass : #FormSGWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #operations }
FormAthensSGWorldRenderer >> displayNewSceneScene: newSceneGraph [
	| renderer |
	renderer := self osWindowRenderer.
	renderer drawDuring: [ :canvas |
		FormSGAthensRenderer render: newSceneGraph on: canvas
	].
	renderer updateAll; present
]

{ #category : #initialization }
FormAthensSGWorldRenderer >> osWindowRenderer [
		
	^ osWindow renderer ifNil: [
		osWindow newAthensRenderer.
		osWindow renderer
	].
	
]
