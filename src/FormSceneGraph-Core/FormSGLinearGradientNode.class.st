"
I am a node that draws a rectangle with a linear gradient.
"
Class {
	#name : #FormSGLinearGradientNode,
	#superclass : #FormSGGradientNode,
	#instVars : [
		'startPoint',
		'endPoint'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGLinearGradientNode >> accept: visitor [
	^ visitor visitLinearGradientNode: self
]

{ #category : #accessing }
FormSGLinearGradientNode >> endPoint [
	^ endPoint
]

{ #category : #accessing }
FormSGLinearGradientNode >> endPoint: anObject [
	endPoint := anObject
]

{ #category : #testing }
FormSGLinearGradientNode >> isLinearGradientNode [
	^ true
]

{ #category : #accessing }
FormSGLinearGradientNode >> startPoint [
	^ startPoint
]

{ #category : #accessing }
FormSGLinearGradientNode >> startPoint: anObject [
	startPoint := anObject
]
