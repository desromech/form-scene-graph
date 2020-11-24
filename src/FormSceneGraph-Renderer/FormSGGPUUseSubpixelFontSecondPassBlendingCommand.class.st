"
I am a blending command that enabled the second pass blending mode required for subpixel antialiased font rendering.
"
Class {
	#name : #FormSGGPUUseSubpixelFontSecondPassBlendingCommand,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUUseSubpixelFontSecondPassBlendingCommand >> accept: visitor [
	^ visitor useSubpixelFontSecondPassBlending
]
