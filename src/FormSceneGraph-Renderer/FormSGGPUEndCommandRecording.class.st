Class {
	#name : #FormSGGPUEndCommandRecording,
	#superclass : #FormSGGPUSingletonDrawCommand,
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #visiting }
FormSGGPUEndCommandRecording >> accept: visitor [
	^ visitor endCommandRecording
]

{ #category : #testing }
FormSGGPUEndCommandRecording >> isEndCommandRecording [
	^ true
]
