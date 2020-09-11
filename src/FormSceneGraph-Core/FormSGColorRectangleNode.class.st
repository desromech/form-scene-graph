"
I am a node that draws a colored rectangle.
"
Class {
	#name : #FormSGColorRectangleNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'color'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGColorRectangleNode >> accept: visitor [
	^ visitor visitColorNode: self
]

{ #category : #accessing }
FormSGColorRectangleNode >> color [
	^ color
]

{ #category : #accessing }
FormSGColorRectangleNode >> color: anObject [
	color := anObject
]

{ #category : #testing }
FormSGColorRectangleNode >> isColorRectangleNode [
	^ true
]

{ #category : #printing }
FormSGColorRectangleNode >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '; color: '; print: color
]
