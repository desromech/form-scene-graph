Class {
	#name : #FormSGTextureNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGTextureNode >> accept: visitor [
	^ visitor visitTextureNode: self
]
