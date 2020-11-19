Class {
	#name : #FormSGGPUSetFormTextureWithModificationCountCommand,
	#superclass : #FormSGGPUDrawCommand,
	#instVars : [
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
FormSGGPUSetFormTextureWithModificationCountCommand >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGGPUSetFormTextureWithModificationCountCommand >> modificationCount: anObject [
	modificationCount := anObject
]
