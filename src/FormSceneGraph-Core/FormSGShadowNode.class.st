"
I am a node that draws shadows that are casted by a rectangle.
"
Class {
	#name : #FormSGShadowNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'leftWidth',
		'rightWidth',
		'topWidth',
		'bottomWidth'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #testing }
FormSGShadowNode class >> isAbstract [
	^ self == FormSGShadowNode
]

{ #category : #accessing }
FormSGShadowNode >> bottomWidth [
	^ bottomWidth
]

{ #category : #accessing }
FormSGShadowNode >> bottomWidth: anObject [
	bottomWidth := anObject
]

{ #category : #testing }
FormSGShadowNode >> isShadowNode [
	^ true
]

{ #category : #accessing }
FormSGShadowNode >> leftWidth [
	^ leftWidth
]

{ #category : #accessing }
FormSGShadowNode >> leftWidth: anObject [
	leftWidth := anObject
]

{ #category : #accessing }
FormSGShadowNode >> rightWidth [
	^ rightWidth
]

{ #category : #accessing }
FormSGShadowNode >> rightWidth: anObject [
	rightWidth := anObject
]

{ #category : #accessing }
FormSGShadowNode >> topWidth [
	^ topWidth
]

{ #category : #accessing }
FormSGShadowNode >> topWidth: anObject [
	topWidth := anObject
]

{ #category : #accessing }
FormSGShadowNode >> width: shadowSize [
	leftWidth := rightWidth := bottomWidth := topWidth := shadowSize
]
