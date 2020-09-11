"
I am a node that changes the opacity of its child. I work by multiplying the alpha factor of my children by my opacity factor.
"
Class {
	#name : #FormSGOpacityNode,
	#superclass : #FormSGChildAttributeNode,
	#instVars : [
		'opacityFactor'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGOpacityNode >> accept: visitor [
	^ visitor visitOpacityNode: self
]

{ #category : #testing }
FormSGOpacityNode >> isOpacityNode [
	^ true
]

{ #category : #accessing }
FormSGOpacityNode >> opacityFactor [
	^ opacityFactor
]

{ #category : #accessing }
FormSGOpacityNode >> opacityFactor: anObject [
	opacityFactor := anObject
]

{ #category : #printing }
FormSGOpacityNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' opacityFactor: '; print: opacityFactor
]
