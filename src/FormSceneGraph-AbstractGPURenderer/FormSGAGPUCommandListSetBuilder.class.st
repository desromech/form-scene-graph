Class {
	#name : #FormSGAGPUCommandListSetBuilder,
	#superclass : #FormSGGPUCommandListSetBuilder,
	#instVars : [
		'drawCommandProcessor'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #accessing }
FormSGAGPUCommandListSetBuilder >> drawCommandProcessor [
	^ drawCommandProcessor
]

{ #category : #accessing }
FormSGAGPUCommandListSetBuilder >> drawCommandProcessor: anObject [
	drawCommandProcessor := anObject
]

{ #category : #testing }
FormSGAGPUCommandListSetBuilder >> isRenderTargetCommandValidated: renderTargetCommand [
	^ drawCommandProcessor isRenderTargetCommandValidated: renderTargetCommand

]
