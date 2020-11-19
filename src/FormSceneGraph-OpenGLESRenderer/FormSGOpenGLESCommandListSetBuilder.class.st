Class {
	#name : #FormSGOpenGLESCommandListSetBuilder,
	#superclass : #FormSGGPUCommandListSetBuilder,
	#instVars : [
		'context'
	],
	#category : #'FormSceneGraph-OpenGLESRenderer'
}

{ #category : #accessing }
FormSGOpenGLESCommandListSetBuilder >> context [
	^ context
]

{ #category : #accessing }
FormSGOpenGLESCommandListSetBuilder >> context: anObject [
	context := anObject
]

{ #category : #testing }
FormSGOpenGLESCommandListSetBuilder >> isRenderTargetCommandValidated: renderTargetCommand [
	| target |
	target := context offscreenBufferExtent: renderTargetCommand extent hasColorBuffer: true isSRGB: context hasSRGB hasDepthBuffer: false hasStencilBuffer: false for: renderTargetCommand keyObject.
	(target modificationCount isNil or: [target modificationCount < renderTargetCommand modificationCount]) ifTrue: [
		target
			modificationCount: renderTargetCommand modificationCount.
		^ false
	].

	^ true
]
