Class {
	#name : #FormSGGPUUseSubpixelFontSecondPassBlendingCommand,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUUseSubpixelFontSecondPassBlendingCommand >> accept: visitor [
	^ visitor useSubpixelFontSecondPassBlending
]
