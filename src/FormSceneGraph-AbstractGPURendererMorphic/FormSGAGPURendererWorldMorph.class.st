"
I am a world morph that uses the AGPU world renderer.
"
Class {
	#name : #FormSGAGPURendererWorldMorph,
	#superclass : #FormSGWorldMorph,
	#instVars : [
		'device'
	],
	#category : #'FormSceneGraph-AbstractGPURendererMorphic'
}

{ #category : #hooks }
FormSGAGPURendererWorldMorph >> worldRendererClass [
	^ FormSGAGPUWorldRenderer
]
