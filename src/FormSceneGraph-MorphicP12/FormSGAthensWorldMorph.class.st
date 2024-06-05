"
I am an OSWindowWorldMorph that uses Athens as the rendering backend for the scene graph.
"
Class {
	#name : 'FormSGAthensWorldMorph',
	#superclass : 'FormSGWorldMorph',
	#category : 'FormSceneGraph-MorphicP12-WorldRenderer',
	#package : 'FormSceneGraph-MorphicP12',
	#tag : 'WorldRenderer'
}

{ #category : 'hooks' }
FormSGAthensWorldMorph >> worldRendererClass [
	^ FormAthensSGWorldRenderer
]
