"
I am a processor of GPU drawing commands. My subclasses are used for connecting FormSGGPUCommandListRenderer with an actual graphics API such as OpenGL ES and Vulkan.
"
Class {
	#name : #FormSGGPUDrawCommandProcessor,
	#superclass : #Object,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> beginCommandRecording [
	"Mark the beginning of a command recording."
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> drawElements: command [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> endCommandRecording [
	"Mark the end of a command recording."
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> noTexture [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> setAthensSurfaceTextureWithModificationCount: athensSurfaceTexture [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> setFormTexture: formTexture [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> setFormTextureWithModificationCount: formTexture [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> setLinearGradientCommand: linearGradient [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> setRadialGradientCommand: radialGradient [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> setRenderTargetWithModificationCount: renderTargetValidationCommand [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> setScissor: command [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> useCompositeAlphaBlending [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> useSubpixelDualOutputBlending [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> useSubpixelFontFirstPassBlending [
	self subclassResponsibility
]

{ #category : #commands }
FormSGGPUDrawCommandProcessor >> useSubpixelFontSecondPassBlending [
	self subclassResponsibility
]
