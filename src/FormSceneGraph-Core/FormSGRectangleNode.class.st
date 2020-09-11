"
I am an abstract node that draws a shape that is emcompassed in a bounding box.
"
Class {
	#name : #FormSGRectangleNode,
	#superclass : #FormSGNode,
	#instVars : [
		'rectangle'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #testing }
FormSGRectangleNode class >> isAbstract [
	^ self == FormSGRectangleNode
]

{ #category : #'accessing - bounds' }
FormSGRectangleNode >> boundingBox [
	^ rectangle
]

{ #category : #testing }
FormSGRectangleNode >> isRectangleNode [
	^ true
]

{ #category : #printing }
FormSGRectangleNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' rectangle: '; print: rectangle
]

{ #category : #accessing }
FormSGRectangleNode >> rectangle [
	^ rectangle
]

{ #category : #accessing }
FormSGRectangleNode >> rectangle: anObject [
	rectangle := anObject
]
