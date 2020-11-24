"
I am draw commands that enables composite alpha blending.
"
Class {
	#name : #FormSGGPUUseCompositeAlphaBlendingCommand,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUUseCompositeAlphaBlendingCommand >> accept: visitor [
	^ visitor useCompositeAlphaBlending
]
