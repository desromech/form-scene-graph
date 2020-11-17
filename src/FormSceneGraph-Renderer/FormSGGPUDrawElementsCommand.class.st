"
I am a GPU command for drawing indexed elements.
"
Class {
	#name : #FormSGGPUDrawElementsCommand,
	#superclass : #FormSGGPUDrawCommand,
	#instVars : [
		'firstIndex',
		'indexCount'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUDrawElementsCommand >> accept: visitor [
	^ visitor drawElements: self
]

{ #category : #accessing }
FormSGGPUDrawElementsCommand >> firstIndex [
	^ firstIndex
]

{ #category : #accessing }
FormSGGPUDrawElementsCommand >> firstIndex: anObject [
	firstIndex := anObject
]

{ #category : #accessing }
FormSGGPUDrawElementsCommand >> indexCount [
	^ indexCount
]

{ #category : #accessing }
FormSGGPUDrawElementsCommand >> indexCount: anObject [
	indexCount := anObject
]

{ #category : #testing }
FormSGGPUDrawElementsCommand >> isDrawElements [
	^ true
]
