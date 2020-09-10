"
I am a node that draws a rectangle with a linear gradient that is repeating.
"
Class {
	#name : #FormSGRepeatingLinearGradientNode,
	#superclass : #FormSGGradientNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGRepeatingLinearGradientNode >> accept: visitor [
	^ visitor visitRepeatingGradientNode: self
]
