Class {
	#name : #FormSGRoundedClipNode,
	#superclass : #FormSGClipNode,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGRoundedClipNode >> accept: visitor [
	^ visitor visitRoundedClipNode: self
]
