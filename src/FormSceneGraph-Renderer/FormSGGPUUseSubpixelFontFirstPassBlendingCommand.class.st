Class {
	#name : #FormSGGPUUseSubpixelFontFirstPassBlendingCommand,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUUseSubpixelFontFirstPassBlendingCommand >> accept: visitor [
	^ visitor useSubpixelFontFirstPassBlending
]
