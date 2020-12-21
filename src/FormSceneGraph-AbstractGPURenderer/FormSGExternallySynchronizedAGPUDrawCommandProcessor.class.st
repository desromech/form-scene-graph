"
I am AGPU draw command processor whose command list management, synchronization and submission is handled externally.
"
Class {
	#name : #FormSGExternallySynchronizedAGPUDrawCommandProcessor,
	#superclass : #FormSGAGPUDrawCommandProcessor,
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #accessing }
FormSGExternallySynchronizedAGPUDrawCommandProcessor >> commandList: theCommandList [
	frameStateTracker commandList: theCommandList
]

{ #category : #hooks }
FormSGExternallySynchronizedAGPUDrawCommandProcessor >> frameStateTrackerClass [
	^ FormSGExternallySynchronizedAGPUFrameStateTracker
]
