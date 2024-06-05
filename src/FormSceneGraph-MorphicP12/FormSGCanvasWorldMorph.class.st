"
I am an OSWindowWorldMorph that uses the BitBlt Canvas as the rendering backend for the scene graph.
"
Class {
	#name : 'FormSGCanvasWorldMorph',
	#superclass : 'FormSGWorldMorph',
	#category : 'FormSceneGraph-MorphicP12-WorldRenderer',
	#package : 'FormSceneGraph-MorphicP12',
	#tag : 'WorldRenderer'
}

{ #category : 'hooks' }
FormSGCanvasWorldMorph >> worldRendererClass [
	^ FormCanvasSGWorldRenderer
]
