"
I am a node that draws a rectangle with a linear gradient.
"
Class {
	#name : #FormSGLinearGradientNode,
	#superclass : #FormSGGradientNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGLinearGradientNode >> accept: visitor [
	^ visitor visitLinearGradientNode: self
]
