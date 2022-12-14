"
I am a per-frame state tracker that uses an externally managed command list. Actual per frame synchronization must be performed by an external user.
"
Class {
	#name : #FormSGExternallySynchronizedAGPUFrameStateTracker,
	#superclass : #FormSGAGPUFrameStateTracker,
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #'draw commands' }
FormSGExternallySynchronizedAGPUFrameStateTracker >> buildCommandListWith: aBlock [
	aBlock value: commandList.
	self submitUniformData
]

{ #category : #accessing }
FormSGExternallySynchronizedAGPUFrameStateTracker >> commandList [
	^ commandList
]

{ #category : #accessing }
FormSGExternallySynchronizedAGPUFrameStateTracker >> commandList: aCommandList [
	commandList := aCommandList
]

{ #category : #'draw commands' }
FormSGExternallySynchronizedAGPUFrameStateTracker >> finishPreviousExecution [
	usedResources removeAll.
]

{ #category : #'draw commands' }
FormSGExternallySynchronizedAGPUFrameStateTracker >> submitToCommandQueueThenCommitSurfaceWith: commitSurfaceBlock [
	"Nothing is required here"
]
