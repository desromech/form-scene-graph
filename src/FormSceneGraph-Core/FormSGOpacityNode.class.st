Class {
	#name : #FormSGOpacityNode,
	#superclass : #FormSGChildAttributeNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGOpacityNode >> accept: visitor [
	^ visitor visitOpacityNode: self
]
