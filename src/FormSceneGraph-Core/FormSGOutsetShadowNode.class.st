"
I am a a node that draws a a shadow that is casted into outside of the rectangle.
"
Class {
	#name : #FormSGOutsetShadowNode,
	#superclass : #FormSGShadowNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGOutsetShadowNode >> accept: visitor [
	^ visitor visitOutsetShadowNode: self
]

{ #category : #testing }
FormSGOutsetShadowNode >> isOutsetShadowNode [
	^ true
]
