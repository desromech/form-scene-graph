"
I am a per-frame state tracker meant to be used in a standalone way by managing its own command list and synchronization fences.
"
Class {
	#name : #FormSGStandaloneAGPUFrameStateTracker,
	#superclass : #FormSGAGPUFrameStateTracker,
	#instVars : [
		'commandQueue',
		'commandAllocator',
		'fence'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #'draw commands' }
FormSGStandaloneAGPUFrameStateTracker >> buildCommandListWith: aBlock [
	commandAllocator reset.
	commandList reset: commandAllocator initial_pipeline_state: nil.
	[
		aBlock value: commandList
	] ensure: [
		commandList close
	].

	self submitUniformData
]

{ #category : #'draw commands' }
FormSGStandaloneAGPUFrameStateTracker >> finishPreviousExecution [
	fence ifNil: [ ^ self ].
	fence waitOnClient.
	usedResources removeAll.
]

{ #category : #'draw commands' }
FormSGStandaloneAGPUFrameStateTracker >> initializeWithDrawCommandProcessor: drawCommandProcessor [
	super initializeWithDrawCommandProcessor: drawCommandProcessor.
		
	commandQueue := device getDefaultCommandQueue.
	commandAllocator := device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: commandQueue.
	commandList := device createCommandList: AGPU_COMMAND_LIST_TYPE_DIRECT allocator: commandAllocator initial_pipeline_state: nil.
	commandList close.
]

{ #category : #'draw commands' }
FormSGStandaloneAGPUFrameStateTracker >> submitToCommandQueueThenCommitSurfaceWith: commitSurfaceBlock [
	fence ifNil: [
		fence := device createFence
	].
	commandQueue addCommandList: commandList.
	commitSurfaceBlock value.
	commandQueue signalFence: fence.
]
