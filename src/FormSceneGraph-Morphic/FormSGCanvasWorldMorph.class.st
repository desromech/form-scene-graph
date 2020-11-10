"
I am an OSWindowWorldMorph that uses the BitBlt Canvas as the rendering backend for the scene graph.
"
Class {
	#name : #FormSGCanvasWorldMorph,
	#superclass : #FormSGWorldMorph,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #hooks }
FormSGCanvasWorldMorph >> worldRendererClass [
	^ FormCanvasSGWorldRenderer
]
