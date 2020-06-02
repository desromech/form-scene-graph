Class {
	#name : #FormSGOutsetShadowNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGOutsetShadowNode >> accept: visitor [
	^ visitor visitOutsetShadowNode: self
]
