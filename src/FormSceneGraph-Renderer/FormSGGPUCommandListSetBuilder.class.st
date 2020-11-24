"
I am builder for a set of command lists. I am used for topological sorting command list for render target dependencies.
"
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

{ #category : #hooks }
FormSGGPUCommandListSetBuilder >> makeCommandListBuilder [
	^ FormSGGPUCommandListBuilder new
]

{ #category : #accessing }
FormSGGPUCommandListSetBuilder >> sortedCommandLists [
	^ sortedCommandLists
]

{ #category : #adding }
FormSGGPUCommandListSetBuilder >> validateRenderTargetCommandsIfNeeded: renderTargetCommand [
	| renderTargetCommandList |
	(self isRenderTargetCommandValidated: renderTargetCommand) ifTrue: [ ^ self ].
	renderTargetCommandList := self makeCommandListBuilder.
	renderTargetCommandList buildForRenderTargetCommand: renderTargetCommand.
	self addCommandListWithDependencies: renderTargetCommandList
]
