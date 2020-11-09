Class {
	#name : #FormCanvasSGWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #operations }
FormCanvasSGWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRecorder [
	| renderer requiredFormExtent |
	renderer := self osWindowRenderer.
	requiredFormExtent := self drawingSurfaceExtent.
	renderer form extent = requiredFormExtent ifFalse: [
		renderer form: (Form extent: requiredFormExtent depth: 32)
	].

	renderer drawDuring: [ :canvas |
		FormSGCanvasRenderer render: newSceneGraph on: canvas
	].
	renderer updateAll
]

{ #category : #initialization }
FormCanvasSGWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	display ifNil: [ display := Form extent: self drawingSurfaceExtent depth: 32 ].
	^ osWindow renderer ifNil: [
		osWindow newFormRenderer: display.
		osWindow renderer
	].
	
]
