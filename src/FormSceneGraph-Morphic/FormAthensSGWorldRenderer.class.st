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
FormAthensSGWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	| renderer |
	renderer := self osWindowRenderer.
	renderer drawDuring: [ :canvas |
		canvas clipBy: damageRectangle during: [
			canvas paintMode clear.
			canvas
				setPaint: Color transparent;
				drawShape: damageRectangle.

			canvas paintMode default.
			FormSGAthensRenderer render: newSceneGraph on: canvas.
		].
	].
	renderer updateAll.
	renderer present
]

{ #category : #initialization }
FormAthensSGWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	^ osWindow renderer ifNil: [
		osWindow newAthensRenderer.
		osWindow renderer
	].
	
]
