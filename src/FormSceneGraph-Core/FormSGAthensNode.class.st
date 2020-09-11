"
I am a node that draws shapes with athens. My content is clipped into my bounding box.
"
Class {
	#name : #FormSGAthensNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGAthensNode >> accept: visitor [
	^ visitor visitAthensNode: self
]

{ #category : #testing }
FormSGAthensNode >> isAthensNode [
	^ true
]
