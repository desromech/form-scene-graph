Class {
	#name : #FormSGRepeatingGradientNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGRepeatingGradientNode >> accept: visitor [
	^ visitor visitRepeatingGradientNode: self
]
