"
I am draw command for enabling an agpu texture.
"
Class {
	#name : #FormSGGAPUSetAGPUTextureCommand,
	#superclass : #FormSGGPUDrawCommand,
	#instVars : [
		'node'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #visiting }
FormSGGAPUSetAGPUTextureCommand >> accept: visitor [
	^ visitor setAGPUTextureNode: node
]

{ #category : #accessing }
FormSGGAPUSetAGPUTextureCommand >> node [
	^ node
]

{ #category : #accessing }
FormSGGAPUSetAGPUTextureCommand >> node: anObject [
	node := anObject
]
