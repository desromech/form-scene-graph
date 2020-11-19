Class {
	#name : #FormSGGPUSetFormTextureWithModificationCountCommand,
	#superclass : #FormSGGPUDrawCommand,
	#instVars : [
		'keyObject',
		'form',
		'modificationCount'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUSetFormTextureWithModificationCountCommand >> accept: visitor [
	^ visitor setFormTextureWithModificationCount: self
]

{ #category : #accessing }
FormSGGPUSetFormTextureWithModificationCountCommand >> form [
	^ form
]

{ #category : #accessing }
FormSGGPUSetFormTextureWithModificationCountCommand >> form: anObject [
	form := anObject
]

{ #category : #testing }
FormSGGPUSetFormTextureWithModificationCountCommand >> isSetFormTextureWithModificationCount [
	^ true
]

{ #category : #accessing }
FormSGGPUSetFormTextureWithModificationCountCommand >> keyObject [
	^ keyObject
]

{ #category : #accessing }
FormSGGPUSetFormTextureWithModificationCountCommand >> keyObject: anObject [
	keyObject := anObject
]

{ #category : #accessing }
FormSGGPUSetFormTextureWithModificationCountCommand >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGGPUSetFormTextureWithModificationCountCommand >> modificationCount: anObject [
	modificationCount := anObject
]
