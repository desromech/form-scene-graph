"
I am an extent command list builder that allows setting an agpu texture node.
"
Class {
	#name : #FormSGAGPUCommandListBuilder,
	#superclass : #FormSGGPUCommandListBuilder,
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #initialization }
FormSGAGPUCommandListBuilder >> setAGPUTextureNode: textureNode [
	drawCommands add: (currentTextureCommand := FormSGGAPUSetAGPUTextureCommand new node: textureNode)
]
