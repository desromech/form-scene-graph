Class {
	#name : #FormSGBorderNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'color',
		'width'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGBorderNode >> accept: visitor [
	^ visitor visitBorderNode: self
]

{ #category : #accessing }
FormSGBorderNode >> color [
	^ color
]

{ #category : #accessing }
FormSGBorderNode >> color: anObject [
	color := anObject
]

{ #category : #accessing }
FormSGBorderNode >> width [
	^ width
]

{ #category : #accessing }
FormSGBorderNode >> width: anObject [
	width := anObject
]
