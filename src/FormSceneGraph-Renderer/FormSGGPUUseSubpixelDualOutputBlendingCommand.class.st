"
I am a drawing command that enables a dual source blending mode for subpixel font rendering.
"
Class {
	#name : #FormSGGPUUseSubpixelDualOutputBlendingCommand,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUUseSubpixelDualOutputBlendingCommand >> accept: visitor [
	^ visitor useSubpixelDualOutputBlending
]
