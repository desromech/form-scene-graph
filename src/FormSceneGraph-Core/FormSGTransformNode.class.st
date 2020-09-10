"
I am a node that applies a general affine transform to its child.
"
Class {
	#name : #FormSGTransformNode,
	#superclass : #FormSGChildAttributeNode,
	#instVars : [
		'transform'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGTransformNode >> accept: visitor [
	^ visitor visitTransformNode: self
]

{ #category : #'display box access' }
FormSGTransformNode >> boundingBox [
	^ transform transformRectangle: child boundingBox
]

{ #category : #testing }
FormSGTransformNode >> isTransformNode [
	^ true
]

{ #category : #printing }
FormSGTransformNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' transform: '; print: transform
]

{ #category : #accessing }
FormSGTransformNode >> transform [
	^ transform
]

{ #category : #accessing }
FormSGTransformNode >> transform: anObject [
	transform := anObject
]
