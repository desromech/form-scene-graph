Class {
	#name : #FormSGColorNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'color'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGColorNode >> accept: visitor [
	^ visitor visitColorNode: self
]

{ #category : #accessing }
FormSGColorNode >> color [
	^ color
]

{ #category : #accessing }
FormSGColorNode >> color: anObject [
	color := anObject
]
