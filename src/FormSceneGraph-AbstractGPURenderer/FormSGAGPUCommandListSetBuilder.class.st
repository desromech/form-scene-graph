"
I am command list set builder that validates on whether AGPU render targets associated to the cached sub scene nodes need to be recomputed or not.
"
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

{ #category : #hooks }
FormSGAGPUCommandListSetBuilder >> makeCommandListBuilder [
	^ FormSGAGPUCommandListBuilder new
]
