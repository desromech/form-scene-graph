"
I represent an abstract GPU based draw command.
"
Class {
	#name : #FormSGGPUDrawCommand,
	#superclass : #Object,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #testing }
FormSGGPUDrawCommand class >> isAbstract [
	^ self == FormSGGPUDrawCommand
]

{ #category : #visiting }
FormSGGPUDrawCommand >> accept: visitor [
	self subclassResponsibility
]

{ #category : #testing }
FormSGGPUDrawCommand >> isDrawElements [
	^ false
]

{ #category : #testing }
FormSGGPUDrawCommand >> isNoTexture [
	^ false
]

{ #category : #testing }
FormSGGPUDrawCommand >> isSetFormTexture [
	^ false
]

{ #category : #testing }
FormSGGPUDrawCommand >> isSetScissor [
	^ false
]
