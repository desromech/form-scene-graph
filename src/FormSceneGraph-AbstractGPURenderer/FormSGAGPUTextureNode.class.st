"
I am texture node whose data comes from an agpu texture. I am specific to the agpu renderer.
"
Class {
	#name : #FormSGAGPUTextureNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'isRepeated',
		'sourceRectangle',
		'texture',
		'extent',
		'view',
		'binding',
		'isFullyOpaque'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #visiting }
FormSGAGPUTextureNode >> accept: visitor [
	^ visitor visitAGPUTextureNode: self
]

{ #category : #accessing }
FormSGAGPUTextureNode >> binding [
	^ binding
]

{ #category : #accessing }
FormSGAGPUTextureNode >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
FormSGAGPUTextureNode >> extent [
	^ extent
]

{ #category : #accessing }
FormSGAGPUTextureNode >> extent: anObject [
	extent := anObject
]

{ #category : #initialization }
FormSGAGPUTextureNode >> initialize [
	isFullyOpaque := false.
	isRepeated := false.
]

{ #category : #visiting }
FormSGAGPUTextureNode >> isAGPUTextureNode [
	^ true
]

{ #category : #accessing }
FormSGAGPUTextureNode >> isFullyOpaque [
	^ isFullyOpaque
]

{ #category : #accessing }
FormSGAGPUTextureNode >> isFullyOpaque: anObject [
	isFullyOpaque := anObject
]

{ #category : #accessing }
FormSGAGPUTextureNode >> isRepeated [
	^ isRepeated
]

{ #category : #accessing }
FormSGAGPUTextureNode >> isRepeated: anObject [
	isRepeated := anObject
]

{ #category : #accessing }
FormSGAGPUTextureNode >> sourceRectangle [
	^ sourceRectangle
]

{ #category : #accessing }
FormSGAGPUTextureNode >> sourceRectangle: anObject [
	sourceRectangle := anObject
]

{ #category : #accessing }
FormSGAGPUTextureNode >> texture [
	^ texture
]

{ #category : #accessing }
FormSGAGPUTextureNode >> texture: anObject [
	texture := anObject
]

{ #category : #accessing }
FormSGAGPUTextureNode >> validSourceRectangle [
	^ sourceRectangle ifNil: [
		self assert: extent notNil.
		sourceRectangle := 0@0 extent: extent
	]
]

{ #category : #accessing }
FormSGAGPUTextureNode >> view [
	^ view
]

{ #category : #accessing }
FormSGAGPUTextureNode >> view: anObject [
	view := anObject.
	binding bindSampledTextureView: 0 view: view.
]
