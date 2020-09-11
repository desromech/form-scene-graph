"
I am a node that draws a rectangle with a linear gradient that is repeating.
"
Class {
	#name : #FormSGRepeatingLinearGradientNode,
	#superclass : #FormSGLinearGradientNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGRepeatingLinearGradientNode >> accept: visitor [
	^ visitor visitRepeatingGradientNode: self
]

{ #category : #testing }
FormSGRepeatingLinearGradientNode >> isRepeatingLinearGradientNode [
	^ true
]
