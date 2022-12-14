"
I encapsulate the state required for manipulating and binding a texture that is used as a render target.
"
Class {
	#name : #FormSGAGPURenderTarget,
	#superclass : #Object,
	#instVars : [
		'device',
		'colorBuffer',
		'colorBufferView',
		'framebuffer',
		'renderpass',
		'extent',
		'modificationCount',
		'binding'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #accessing }
FormSGAGPURenderTarget >> binding [
	^ binding
]

{ #category : #accessing }
FormSGAGPURenderTarget >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
FormSGAGPURenderTarget >> colorBuffer [
	^ colorBuffer
]

{ #category : #accessing }
FormSGAGPURenderTarget >> colorBuffer: anObject [
	colorBuffer := anObject
]

{ #category : #accessing }
FormSGAGPURenderTarget >> colorBufferView [
	^ colorBufferView
]

{ #category : #accessing }
FormSGAGPURenderTarget >> colorBufferView: anObject [
	colorBufferView := anObject
]

{ #category : #accessing }
FormSGAGPURenderTarget >> device [
	^ device
]

{ #category : #accessing }
FormSGAGPURenderTarget >> device: anObject [
	device := anObject
]

{ #category : #accessing }
FormSGAGPURenderTarget >> extent [
	^ extent
]

{ #category : #accessing }
FormSGAGPURenderTarget >> extent: anObject [
	extent := anObject
]

{ #category : #accessing }
FormSGAGPURenderTarget >> framebuffer [
	^ framebuffer
]

{ #category : #accessing }
FormSGAGPURenderTarget >> framebuffer: anObject [
	framebuffer := anObject
]

{ #category : #accessing }
FormSGAGPURenderTarget >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGAGPURenderTarget >> modificationCount: anObject [
	modificationCount := anObject
]

{ #category : #'life cycle management' }
FormSGAGPURenderTarget >> recordOnFrameStateTracker: frameStateTracker [
	frameStateTracker
		recordUsedResource: colorBuffer;
		recordUsedResource: colorBufferView;
		recordUsedResource: binding;
		recordUsedResource: framebuffer;
		recordUsedResource: renderpass
]

{ #category : #accessing }
FormSGAGPURenderTarget >> renderpass [
	^ renderpass
]

{ #category : #accessing }
FormSGAGPURenderTarget >> renderpass: anObject [
	renderpass := anObject
]
