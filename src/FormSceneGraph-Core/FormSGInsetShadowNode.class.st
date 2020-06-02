Class {
	#name : #FormSGInsetShadowNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGInsetShadowNode >> accept: visitor [
	^ visitor visitInsetShadowNode: self
]
