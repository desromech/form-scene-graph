Class {
	#name : #FormSGRectangleNode,
	#superclass : #FormSGNode,
	#instVars : [
		'rectangle'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #'display box access' }
FormSGRectangleNode >> boundingBox [
	^ rectangle
]

{ #category : #accessing }
FormSGRectangleNode >> rectangle [
	^ rectangle
]

{ #category : #accessing }
FormSGRectangleNode >> rectangle: anObject [
	rectangle := anObject
]
