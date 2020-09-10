"
I am a node that clips its child with to a rectangle with rounded corners.
"
Class {
	#name : #FormSGRoundedClipNode,
	#superclass : #FormSGClipNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGRoundedClipNode >> accept: visitor [
	^ visitor visitRoundedClipNode: self
]
