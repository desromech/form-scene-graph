"
I am a scene graph based world renderer that uses the Athens renderer.
"
Class {
	#name : #FormAthensSGWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #accessing }
FormAthensSGWorldRenderer class >> isApplicableFor: aWorld [

	^ self isEnabled and: [Smalltalk isHeadless and: [ CommandLineArguments new hasOption: 'interactive'  ]]
]

{ #category : #accessing }
FormAthensSGWorldRenderer class >> priority [
	^ FormSGAbstractWorldRenderer priority + 1
]

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
