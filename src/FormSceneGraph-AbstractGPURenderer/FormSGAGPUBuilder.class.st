"
I am a scene graph builder that adds an additional node for rendering directly from an agpu texture node.
"
Class {
	#name : #FormSGAGPUBuilder,
	#superclass : #FormSGBuilder,
	#instVars : [
		'device',
		'drawCommandProcessor'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #'node building' }
FormSGAGPUBuilder >> agpuTextureNode [
	^ FormSGAGPUTextureNode new
		binding: (drawCommandProcessor context shaderSignature createShaderResourceBinding: 2);
		yourself
]

{ #category : #utility }
FormSGAGPUBuilder >> createViewForTexture: texture [
	| viewDescription |
	viewDescription := AGPUTextureViewDescription new.
	texture getFullViewDescription: viewDescription.

	viewDescription format: drawCommandProcessor colorBufferFormat.
	^ texture createView: viewDescription
]

{ #category : #accessing }
FormSGAGPUBuilder >> device [
	^ device
]

{ #category : #accessing }
FormSGAGPUBuilder >> device: anObject [
	device := anObject
]

{ #category : #accessing }
FormSGAGPUBuilder >> drawCommandProcessor [
	^ drawCommandProcessor
]

{ #category : #accessing }
FormSGAGPUBuilder >> drawCommandProcessor: anObject [
	drawCommandProcessor := anObject
]

{ #category : #testing }
FormSGAGPUBuilder >> isFormSGAGPUBuilder [
	^ true
]
