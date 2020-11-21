"
I encapsulate the state required for manipulating and binding a texture.
"
Class {
	#name : #FormSGAGPUTexture,
	#superclass : #Object,
	#instVars : [
		'texture',
		'view',
		'binding',
		'extent',
		'modificationCount'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #accessing }
FormSGAGPUTexture >> binding [
	^ binding
]

{ #category : #accessing }
FormSGAGPUTexture >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
FormSGAGPUTexture >> extent [
	^ extent
]

{ #category : #accessing }
FormSGAGPUTexture >> extent: anObject [
	extent := anObject
]

{ #category : #accessing }
FormSGAGPUTexture >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGAGPUTexture >> modificationCount: anObject [
	modificationCount := anObject
]

{ #category : #'life cycle management' }
FormSGAGPUTexture >> recordOnFrameStateTracker: frameStateTracker [
	frameStateTracker
		recordUsedResource: texture;
		recordUsedResource: view;
		recordUsedResource: binding.
]

{ #category : #accessing }
FormSGAGPUTexture >> texture [
	^ texture
]

{ #category : #accessing }
FormSGAGPUTexture >> texture: anObject [
	texture := anObject
]

{ #category : #'texture manipulation' }
FormSGAGPUTexture >> uploadAthensSurface: surface [
	texture uploadTextureData: 0 arrayIndex: 0 pitch: surface stride slicePitch: surface stride * surface height data: surface getDataPtr
]

{ #category : #'texture manipulation' }
FormSGAGPUTexture >> uploadAthensSurface: surface withModificationCount: newModificationCount [
	(modificationCount isNil or: [modificationCount < newModificationCount]) ifTrue: [
		self uploadAthensSurface: surface .
		modificationCount := newModificationCount
	]
]

{ #category : #'texture manipulation' }
FormSGAGPUTexture >> uploadForm: form [
	| convertedForm |
	convertedForm := form asFormOfDepth: 32.
	convertedForm unhibernate.
	texture uploadTextureData: 0 arrayIndex: 0 pitch: extent x * 4 slicePitch: extent x * 4 * extent y data: convertedForm bits
]

{ #category : #'texture manipulation' }
FormSGAGPUTexture >> uploadForm: form withModificationCount: newModificationCount [
	(modificationCount isNil or: [modificationCount < newModificationCount]) ifTrue: [
		self uploadForm: form.
		modificationCount := newModificationCount
	]
]

{ #category : #accessing }
FormSGAGPUTexture >> view [
	^ view
]

{ #category : #accessing }
FormSGAGPUTexture >> view: anObject [
	view := anObject
]
