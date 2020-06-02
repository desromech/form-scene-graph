Class {
	#name : #FormSGClipNode,
	#superclass : #FormSGNode,
	#instVars : [
		'child',
		'rectangle'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGClipNode >> accept: visitor [
	^ visitor visitClipNode: self
]

{ #category : #'display box access' }
FormSGClipNode >> boundingBox [
	rectangle isEmpty ifTrue: [ ^ rectangle ].
	^ rectangle intersect: child boundingBox ifNone: [ Rectangle empty]
]

{ #category : #accessing }
FormSGClipNode >> child [
	^ child
]

{ #category : #accessing }
FormSGClipNode >> child: anObject [
	child := anObject
]

{ #category : #accessing }
FormSGClipNode >> children [
	^ { child }
]

{ #category : #accessing }
FormSGClipNode >> childrenDo: aBlock [
	aBlock value: child
]

{ #category : #accessing }
FormSGClipNode >> rectangle [
	^ rectangle
]

{ #category : #accessing }
FormSGClipNode >> rectangle: anObject [
	rectangle := anObject
]
