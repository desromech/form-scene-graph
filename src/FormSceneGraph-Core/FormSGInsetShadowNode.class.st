"
I am a node that draws a shadow that is casted into the interior of the rectangle.
"
Class {
	#name : #FormSGInsetShadowNode,
	#superclass : #FormSGShadowNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGInsetShadowNode >> accept: visitor [
	^ visitor visitInsetShadowNode: self
]

{ #category : #testing }
FormSGInsetShadowNode >> isInsetShadowNode [
	^ true
]
