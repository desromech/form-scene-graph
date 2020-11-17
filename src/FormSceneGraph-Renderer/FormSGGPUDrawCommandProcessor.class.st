"
I am a processor of GPU drawing commands. My subclasses are used for connecting FormSGGPUCommandListRenderer with an actual graphics API such as OpenGL ES and Vulkan.
"
Class {
	#name : #FormSGGPUDrawCommandProcessor,
	#superclass : #Object,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #'as yet unclassified' }
FormSGGPUDrawCommandProcessor >> drawElements: command [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
FormSGGPUDrawCommandProcessor >> noTexture [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
FormSGGPUDrawCommandProcessor >> setFormTexture: formTexture [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
FormSGGPUDrawCommandProcessor >> setScissor: command [
	self subclassResponsibility
]
