"
I am an OSWindowWorldMorph that uses Athens as the rendering backend for the scene graph.
"
Class {
	#name : #FormSGAthensWorldMorph,
	#superclass : #FormSGWorldMorph,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #hooks }
FormSGAthensWorldMorph >> worldRendererClass [
	^ FormAthensSGWorldRenderer
]
