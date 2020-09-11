"
I am a node that clips its child with to a rectangle with rounded corners.
"
Class {
	#name : #FormSGRoundedClipNode,
	#superclass : #FormSGClipNode,
	#instVars : [
		'borderRadius'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGRoundedClipNode >> accept: visitor [
	^ visitor visitRoundedClipNode: self
]

{ #category : #accessing }
FormSGRoundedClipNode >> borderRadius [
	^ borderRadius
]

{ #category : #accessing }
FormSGRoundedClipNode >> borderRadius: anObject [
	borderRadius := anObject
]

{ #category : #testing }
FormSGRoundedClipNode >> isRoundedClipNode [
	^ true
]
