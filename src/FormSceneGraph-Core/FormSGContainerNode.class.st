Class {
	#name : #FormSGContainerNode,
	#superclass : #FormSGNode,
	#instVars : [
		'children'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #copying }
FormSGContainerNode >> , otherNode [
	otherNode isNullNode ifTrue: [ ^ self ].
	otherNode isContainerNode ifTrue: [ ^ self copy children: children , otherNode children; yourself ].
	^ self copy children: children , {otherNode}
]

{ #category : #visiting }
FormSGContainerNode >> accept: visitor [
	^ visitor visitContainerNode: self
]

{ #category : #'display box access' }
FormSGContainerNode >> boundingBox [
	| result |
	result := Rectangle empty.
	children do: [ :each |
		result := result mergeAllowingEmpty: each boundingBox
	].
	^ result
]

{ #category : #accessing }
FormSGContainerNode >> children [
	^ children
]

{ #category : #accessing }
FormSGContainerNode >> children: anObject [
	children := anObject
]

{ #category : #accessing }
FormSGContainerNode >> childrenDo: aBlock [
	children do: aBlock
]

{ #category : #testing }
FormSGContainerNode >> isContainerNode [
	^ true
]
