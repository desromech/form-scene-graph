"
I am node that applies a translation to its child node.
"
Class {
	#name : #FormSGTranslationNode,
	#superclass : #FormSGChildAttributeNode,
	#instVars : [
		'translation'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGTranslationNode >> accept: visitor [
	^ visitor visitTranslationNode: self
]

{ #category : #'display box access' }
FormSGTranslationNode >> boundingBox [
	^ child boundingBox translateBy: translation
]

{ #category : #testing }
FormSGTranslationNode >> isTranslationNode [
	^ true
]

{ #category : #printing }
FormSGTranslationNode >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' translation: '; print: translation
]

{ #category : #accessing }
FormSGTranslationNode >> translation [
	^ translation
]

{ #category : #accessing }
FormSGTranslationNode >> translation: anObject [
	translation := anObject
]
