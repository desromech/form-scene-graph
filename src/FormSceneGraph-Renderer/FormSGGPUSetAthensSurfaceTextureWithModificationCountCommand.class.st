Class {
	#name : #FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand,
	#superclass : #FormSGGPUDrawCommand,
	#instVars : [
		'keyObject',
		'athensSurface',
		'modificationCount'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #testing }
FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand >> accept: visitor [
	^ visitor setAthensSurfaceTextureWithModificationCount: self
]

{ #category : #accessing }
FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand >> athensSurface [
	^ athensSurface
]

{ #category : #accessing }
FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand >> athensSurface: anObject [
	athensSurface := anObject
]

{ #category : #testing }
FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand >> isSetAthensSurfaceTextureWithModificationCount [
	^ true
]

{ #category : #accessing }
FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand >> keyObject [
	^ keyObject
]

{ #category : #accessing }
FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand >> keyObject: anObject [
	keyObject := anObject
]

{ #category : #accessing }
FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand >> modificationCount [
	^ modificationCount
]

{ #category : #accessing }
FormSGGPUSetAthensSurfaceTextureWithModificationCountCommand >> modificationCount: anObject [
	modificationCount := anObject
]
