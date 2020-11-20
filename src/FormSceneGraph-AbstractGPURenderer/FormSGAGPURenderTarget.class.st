Class {
	#name : #FormSGAGPURenderTarget,
	#superclass : #Object,
	#instVars : [
		'device',
		'colorBuffer',
		'colorBufferView',
		'framebuffer',
		'renderpass',
		'extent'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

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
FormSGAGPURenderTarget >> renderpass [
	^ renderpass
]

{ #category : #accessing }
FormSGAGPURenderTarget >> renderpass: anObject [
	renderpass := anObject
]
