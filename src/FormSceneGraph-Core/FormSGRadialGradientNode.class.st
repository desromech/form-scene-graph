"
I am a node that draws a circle with a radial gradient which is encompassed in a rectangle.
"
Class {
	#name : #FormSGRadialGradientNode,
	#superclass : #FormSGGradientNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGRadialGradientNode >> accept: visitor [
	^ visitor visitRadialGradientNode: self
]
