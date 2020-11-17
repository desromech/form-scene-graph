"
I am GPU drawing command for activating a texture that is specified from a form.
"
Class {
	#name : #FormSGGPUSetFormTextureCommand,
	#superclass : #FormSGGPUDrawCommand,
	#instVars : [
		'form'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUSetFormTextureCommand >> accept: visitor [
	^ visitor setFormTexture: self
]

{ #category : #accessing }
FormSGGPUSetFormTextureCommand >> form [
	^ form
]

{ #category : #accessing }
FormSGGPUSetFormTextureCommand >> form: anObject [
	form := anObject
]

{ #category : #testing }
FormSGGPUSetFormTextureCommand >> isSetFormTexture [
	^ true
]
