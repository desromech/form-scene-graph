"
I am command list set builder that validates on whether OpenGL render targets associated to the cached sub scene nodes need to be recomputed or not.
"
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
	(target modificationCount isNil or:
	[target modificationCount < renderTargetCommand modificationCount or:
	[target extent ~= renderTargetCommand extent]]) ifTrue: [
		target
			extent: renderTargetCommand extent;
			modificationCount: renderTargetCommand modificationCount.
		^ false
	].

	^ true
]
