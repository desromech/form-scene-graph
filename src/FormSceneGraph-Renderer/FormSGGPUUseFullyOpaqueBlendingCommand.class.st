"
I am a drawing command that enables a fully opaque blending mode.
"
Class {
	#name : #FormSGGPUUseFullyOpaqueBlendingCommand,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUUseFullyOpaqueBlendingCommand >> accept: visitor [
	^ visitor useFullyOpaqueBlending
]
