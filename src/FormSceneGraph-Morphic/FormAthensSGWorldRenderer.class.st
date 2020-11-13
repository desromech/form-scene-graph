"
I am a scene graph based world renderer that uses the Athens renderer.
"
Class {
	#name : #FormAthensSGWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #hooks }
FormAthensSGWorldRenderer >> adjustSurfaceDamageRectangle: rectangle [
	^ rectangle origin corner: rectangle corner + (1@1)
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
	renderer updateRectangle: damageRectangle.
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
