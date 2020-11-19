Class {
	#name : #FormSGGPUBeginCommandRecording,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUBeginCommandRecording >> accept: visitor [
	^ visitor beginCommandRecording
]

{ #category : #testing }
FormSGGPUBeginCommandRecording >> isBeginCommandRecording [
	^ false
]
