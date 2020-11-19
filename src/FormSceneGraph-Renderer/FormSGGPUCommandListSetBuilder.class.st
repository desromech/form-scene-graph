Class {
	#name : #FormSGGPUCommandListSetBuilder,
	#superclass : #Object,
	#instVars : [
		'sortedCommandLists',
		'visitedCommandLists'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #adding }
FormSGGPUCommandListSetBuilder >> addCommandListWithDependencies: commandList [
	(visitedCommandLists includes: commandList) ifTrue: [ ^ self ].
	
	commandList requiredRenderTargetCommands valuesDo: [ :each |
		self validateRenderTargetCommandsIfNeeded: each
	].

	sortedCommandLists add: commandList
]

{ #category : #initialization }
FormSGGPUCommandListSetBuilder >> initialize [
	super initialize.
	sortedCommandLists := OrderedCollection new.
	visitedCommandLists := IdentitySet new.
]

{ #category : #testing }
FormSGGPUCommandListSetBuilder >> isRenderTargetCommandValidated: renderTargetCommand [
	^ false
]

{ #category : #accessing }
FormSGGPUCommandListSetBuilder >> sortedCommandLists [
	^ sortedCommandLists
]

{ #category : #adding }
FormSGGPUCommandListSetBuilder >> validateRenderTargetCommandsIfNeeded: renderTargetCommand [
	| renderTargetCommandList |
	(self isRenderTargetCommandValidated: renderTargetCommand) ifTrue: [ ^ self ].
	renderTargetCommandList := FormSGGPUCommandListBuilder new.
	renderTargetCommandList buildForRenderTargetCommand: renderTargetCommand.
	self addCommandListWithDependencies: renderTargetCommandList
]
