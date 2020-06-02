Class {
	#name : #FormSGTranslationNode,
	#superclass : #FormSGChildAttributeNode,
	#instVars : [
		'translation'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGTranslationNode >> accept: visitor [
	^ visitor visitTranslationNode: self
]

{ #category : #'display box access' }
FormSGTranslationNode >> boundingBox [
	^ child boundingBox translateBy: translation
]

{ #category : #accessing }
FormSGTranslationNode >> translation [
	^ translation
]

{ #category : #accessing }
FormSGTranslationNode >> translation: anObject [
	translation := anObject
]
