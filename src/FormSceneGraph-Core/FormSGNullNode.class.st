Class {
	#name : #FormSGNullNode,
	#superclass : #FormSGNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGNullNode >> accept: visitor [
	^ visitor visitNullNode: self
]

{ #category : #'display box access' }
FormSGNullNode >> boundingBox [
	^ Rectangle empty
]

{ #category : #testing }
FormSGNullNode >> isNullNode [
	^ true
]
