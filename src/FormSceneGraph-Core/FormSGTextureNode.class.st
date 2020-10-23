"
I am a node that draws a textured rectangle.
"
Class {
	#name : #FormSGTextureNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'isFullyOpaque',
		'isRepeated',
		'form',
		'sourceRectangle'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGTextureNode >> accept: visitor [
	^ visitor visitTextureNode: self
]

{ #category : #accessing }
FormSGTextureNode >> form [
	^ form
]

{ #category : #accessing }
FormSGTextureNode >> form: anObject [
	form := anObject
]

{ #category : #initialization }
FormSGTextureNode >> initialize [
	isFullyOpaque := false.
	isRepeated := false.
]

{ #category : #accessing }
FormSGTextureNode >> isFullyOpaque [
	^ isFullyOpaque
]

{ #category : #accessing }
FormSGTextureNode >> isFullyOpaque: anObject [
	isFullyOpaque := anObject
]

{ #category : #accessing }
FormSGTextureNode >> isRepeated [
	^ isRepeated
]

{ #category : #accessing }
FormSGTextureNode >> isRepeated: anObject [
	isRepeated := anObject
]

{ #category : #testing }
FormSGTextureNode >> isTextureNode [
	^ true
]

{ #category : #accessing }
FormSGTextureNode >> sourceRectangle [
	^ sourceRectangle
]

{ #category : #accessing }
FormSGTextureNode >> sourceRectangle: anObject [
	sourceRectangle := anObject
]

{ #category : #accessing }
FormSGTextureNode >> validSourceRectangle [
	^ sourceRectangle ifNil: [ form boundingBox ]
]
