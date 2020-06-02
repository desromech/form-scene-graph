Class {
	#name : #FormSGTextNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGTextNode >> accept: visitor [
	^ visitor visitTextNode: self
]
