"
I am a node that draws a textured rectangle.
"
Class {
	#name : #FormSGTextureNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'isFullyOpaque',
		'form'
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
]

{ #category : #accessing }
FormSGTextureNode >> isFullyOpaque [
	^ isFullyOpaque
]

{ #category : #accessing }
FormSGTextureNode >> isFullyOpaque: anObject [
	isFullyOpaque := anObject
]
