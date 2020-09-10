"
I am an abstract node that draws a gradient shape.
"
Class {
	#name : #FormSGGradientNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #testing }
FormSGGradientNode class >> isAbstract [
	^ self == FormSGGradientNode
]
