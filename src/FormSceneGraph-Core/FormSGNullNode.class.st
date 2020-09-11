"
I am a null node. My bounding box is empty, and I do not draw anything.
"
Class {
	#name : #FormSGNullNode,
	#superclass : #FormSGNode,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #accessing }
FormSGNullNode class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #visiting }
FormSGNullNode >> accept: visitor [
	^ visitor visitNullNode: self
]

{ #category : #'accessing - bounds' }
FormSGNullNode >> boundingBox [
	^ Rectangle empty
]

{ #category : #testing }
FormSGNullNode >> isNullNode [
	^ true
]
