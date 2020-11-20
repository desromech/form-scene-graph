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
