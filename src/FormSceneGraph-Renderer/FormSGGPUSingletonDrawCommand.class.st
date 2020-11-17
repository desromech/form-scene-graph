"
I am a stateless singleton GPU draw command. I am a singleton for saving memory.
"
Class {
	#name : #FormSGGPUSingletonDrawCommand,
	#superclass : #FormSGGPUDrawCommand,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #testing }
FormSGGPUSingletonDrawCommand class >> isAbstract [
	^ self == FormSGGPUSingletonDrawCommand
]

{ #category : #accessing }
FormSGGPUSingletonDrawCommand class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
