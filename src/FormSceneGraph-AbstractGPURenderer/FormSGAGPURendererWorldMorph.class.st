"
I am a world morph that uses the AGPU world renderer.
"
Class {
	#name : #FormSGAGPURendererWorldMorph,
	#superclass : #FormSGWorldMorph,
	#instVars : [
		'device'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #hooks }
FormSGAGPURendererWorldMorph >> worldRendererClass [
	^ FormSGAGPUWorldRenderer
]
