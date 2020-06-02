Class {
	#name : #FormSGLinearGradientNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGLinearGradientNode >> accept: visitor [
	^ visitor visitLinearGradientNode: self
]
