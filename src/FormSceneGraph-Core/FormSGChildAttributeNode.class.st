Class {
	#name : #FormSGChildAttributeNode,
	#superclass : #FormSGNode,
	#instVars : [
		'child'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #'display box access' }
FormSGChildAttributeNode >> boundingBox [
	^ child boundingBox
]

{ #category : #accessing }
FormSGChildAttributeNode >> child [
	^ child
]

{ #category : #accessing }
FormSGChildAttributeNode >> child: anObject [
	child := anObject
]

{ #category : #accessing }
FormSGChildAttributeNode >> children [
	^ { child }
]

{ #category : #accessing }
FormSGChildAttributeNode >> childrenDo: aBlock [
	aBlock value: child
]
