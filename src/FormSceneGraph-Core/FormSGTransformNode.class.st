Class {
	#name : #FormSGTransformNode,
	#superclass : #FormSGChildAttributeNode,
	#instVars : [
		'transform'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGTransformNode >> accept: visitor [
	^ visitor visitTransformNode: self
]

{ #category : #'display box access' }
FormSGTransformNode >> boundingBox [
	^ transform transformRectangle: child boundingBox
]

{ #category : #accessing }
FormSGTransformNode >> transform [
	^ transform
]

{ #category : #accessing }
FormSGTransformNode >> transform: anObject [
	transform := anObject
]
