"
I am an abstract node that draws a gradient shape.
"
Class {
	#name : #FormSGGradientNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'startColor',
		'endColor'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #testing }
FormSGGradientNode class >> isAbstract [
	^ self == FormSGGradientNode
]

{ #category : #accessing }
FormSGGradientNode >> endColor [
	^ endColor
]

{ #category : #accessing }
FormSGGradientNode >> endColor: anObject [
	endColor := anObject
]

{ #category : #testing }
FormSGGradientNode >> isGradientNode [
	^ true
]

{ #category : #accessing }
FormSGGradientNode >> startColor [
	^ startColor
]

{ #category : #accessing }
FormSGGradientNode >> startColor: anObject [
	startColor := anObject
]
