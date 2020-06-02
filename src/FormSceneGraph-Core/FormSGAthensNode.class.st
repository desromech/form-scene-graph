Class {
	#name : #FormSGAthensNode,
	#superclass : #FormSGRectangleNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGAthensNode >> accept: visitor [
	^ visitor visitAthensNode: self
]
