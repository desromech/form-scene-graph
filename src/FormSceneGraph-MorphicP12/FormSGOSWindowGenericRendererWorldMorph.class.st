"
I am an OSWindowWorldMorph that uses the OSWindowGenericRenderer as the rendering backend for the scene graph.
"
Class {
	#name : 'FormSGOSWindowGenericRendererWorldMorph',
	#superclass : 'FormSGWorldMorph',
	#category : 'FormSceneGraph-MorphicP12-WorldRenderer',
	#package : 'FormSceneGraph-MorphicP12',
	#tag : 'WorldRenderer'
}

{ #category : 'hooks' }
FormSGOSWindowGenericRendererWorldMorph >> worldRendererClass [
	^ FormOSWindowGenericRendererSGWorldRenderer
]
