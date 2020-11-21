"
I am a command that is used for specifying a render target texture whose content is conditionally updated.
"
Class {
	#name : #FormSGGPUSetRenderTargetTextureWithModificationCountCommand,
	#superclass : #FormSGGPUDrawCommand,
	#instVars : [
		'extent',
		'keyObject',
		'modificationCount',
		'renderingBlock'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> accept: visitor [
	^ visitor setRenderTargetWithModificationCount: self
]

{ #category : #accessing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> extent [
	^ extent
]

{ #category : #accessing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> extent: anObject [
	extent := anObject
]

{ #category : #testing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> isSetRenderTargetTextureWithModificationCountCommand [
	^ true
]

{ #category : #accessing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> keyObject [
	^ keyObject
]

{ #category : #accessing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> keyObject: anObject [
	keyObject := anObject
]

{ #category : #accessing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> modificationCount: anObject [
	modificationCount := anObject
]

{ #category : #accessing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> renderingBlock [
	^ renderingBlock
]

{ #category : #accessing }
FormSGGPUSetRenderTargetTextureWithModificationCountCommand >> renderingBlock: anObject [
	renderingBlock := anObject
]
