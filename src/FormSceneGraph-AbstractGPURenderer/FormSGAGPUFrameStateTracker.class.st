Class {
	#name : #FormSGAGPUFrameStateTracker,
	#superclass : #Object,
	#instVars : [
		'device',
		'commandQueue',
		'commandAllocator',
		'commandList',
		'fence',
		'indexBuffer',
		'indexBufferCapacity',
		'vertexBuffer',
		'vertexBufferCapacity',
		'vertexBufferSize',
		'indexBufferSize',
		'vertexBinding'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #'instance creation' }
FormSGAGPUFrameStateTracker class >> for: drawCommandProcessor [
	^ self basicNew initializeWithDrawCommandProcessor: drawCommandProcessor
]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> activateVerticesAndIndices [
	vertexBufferSize = 0 ifTrue: [ ^ self ].
	indexBufferSize = 0 ifTrue: [ ^ self ].
	
	commandList
		useIndexBuffer: indexBuffer;
		useVertexBinding: vertexBinding
]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> buildCommandListWith: aBlock [
	self finishPreviousExecution.
	
	commandAllocator reset.
	commandList reset: commandAllocator initial_pipeline_state: nil.
	[
		aBlock value: commandList
	] ensure: [
		commandList close
	]
]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> ensureIndexBufferWithSize: requiredSize [
	(indexBuffer isNotNil and: [indexBufferCapacity >= requiredSize]) ifTrue: [
		indexBufferSize := requiredSize.
		^ indexBuffer
	].

	indexBufferCapacity := (requiredSize max: 4096) alignedTo: 4096.
	indexBuffer := device createBuffer: (AGPUBufferDescription new
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST_TO_DEVICE;
		stride: 2;
		size: indexBufferCapacity;
		usage_modes: AGPU_ELEMENT_ARRAY_BUFFER;
		main_usage_mode: AGPU_ELEMENT_ARRAY_BUFFER;
		mapping_flags: AGPU_MAP_WRITE_BIT;
		yourself) initial_data: nil.
		
	indexBufferSize := requiredSize.
	^ indexBuffer

]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> ensureVertexBufferWithSize: requiredSize [
	(vertexBuffer isNotNil and: [vertexBufferCapacity >= requiredSize]) ifTrue: [
		vertexBufferSize := requiredSize.
		^ vertexBuffer
	].

	vertexBuffer ifNotNil: [
		vertexBuffer release.
		vertexBuffer := nil.
	].

	vertexBufferCapacity := (requiredSize max: 4096) alignedTo: 4096.
	vertexBuffer := device createBuffer: (AGPUBufferDescription new
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST_TO_DEVICE;
		stride: 48;
		size: vertexBufferCapacity;
		usage_modes: AGPU_ARRAY_BUFFER;
		main_usage_mode: AGPU_ARRAY_BUFFER;
		mapping_flags: AGPU_MAP_WRITE_BIT;
		yourself) initial_data: nil.
		
	vertexBinding bindVertexBuffers: 1 vertex_buffers: (AGPU packListOfReferences: {vertexBuffer}).

	vertexBufferSize := requiredSize.
	^ vertexBuffer
]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> finishPreviousExecution [
	fence ifNil: [ ^ self ].
	fence waitOnClient.
]

{ #category : #initialization }
FormSGAGPUFrameStateTracker >> initializeWithDrawCommandProcessor: drawCommandProcessor [
	device := drawCommandProcessor device.
	vertexBinding := device createVertexBinding: drawCommandProcessor vertexLayout.

	commandQueue := device getDefaultCommandQueue.
	commandAllocator := device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: commandQueue.
	commandList := device createCommandList: AGPU_COMMAND_LIST_TYPE_DIRECT allocator: commandAllocator initial_pipeline_state: nil.
	commandList close.

]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> submitToCommandQueue [
	fence ifNil: [
		fence := device createFence
	].
	commandQueue
		addCommandList: commandList;
		signalFence: fence.
]
