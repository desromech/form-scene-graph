Class {
	#name : #FormSGGPUUseSubpixelDualOutputBlendingCommand,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUUseSubpixelDualOutputBlendingCommand >> accept: visitor [
	^ visitor useSubpixelDualOutputBlending
]
