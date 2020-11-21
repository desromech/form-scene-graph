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
		'vertexBinding',
		'uniformBinding',
		'viewBoxTransformsData',
		'uniformBuffer',
		'uniformBufferCapacity',
		'viewBoxTransformsCount',
		'expectedViewBoxTransformsCount',
		'expectedLinearGradientsCount',
		'expectedRadialGradientsCount',
		'linearGradientsCount',
		'radialGradientsCount',
		'radialGradientData',
		'linearGradientData',
		'usedResources'
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
FormSGAGPUFrameStateTracker >> activateUniforms [
	commandList
		useShaderResources: uniformBinding
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
FormSGAGPUFrameStateTracker >> allocateUniformStorageForSGCommandLists: sgCommandLists [
	| viewBoxTransformDataSize |
	expectedViewBoxTransformsCount := sgCommandLists size.
	expectedLinearGradientsCount := 0.
	expectedRadialGradientsCount := 0.
	sgCommandLists do: [ :sgCommandList |
		sgCommandList drawCommands do: [ :each |
			each isSetLinearGradient ifTrue: [
				expectedLinearGradientsCount := expectedLinearGradientsCount + 1
			].

			each isSetRadialGradient ifTrue: [
				expectedRadialGradientsCount := expectedRadialGradientsCount + 1
			].
		]
	].

	viewBoxTransformsData removeAll.
	viewBoxTransformsCount := 0.
	
	radialGradientData removeAll.
	radialGradientsCount := 0.

	linearGradientData removeAll.
	linearGradientsCount := 0.
	
	viewBoxTransformDataSize := expectedViewBoxTransformsCount*16.
	self ensureUniformBufferWithSize: viewBoxTransformDataSize.
	
	uniformBinding bindUniformBufferRange: 0 uniform_buffer: uniformBuffer offset: 0 size: viewBoxTransformDataSize
]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> buildCommandListWith: aBlock [
	commandAllocator reset.
	commandList reset: commandAllocator initial_pipeline_state: nil.
	[
		aBlock value: commandList
	] ensure: [
		commandList close
	].

	self submitUniformData
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
FormSGAGPUFrameStateTracker >> ensureUniformBufferWithSize: requiredSize [
	(uniformBuffer isNotNil and: [uniformBufferCapacity >= requiredSize]) ifTrue: [
		^ uniformBuffer
	].

	uniformBuffer ifNotNil: [
		uniformBuffer release.
		uniformBuffer := nil.
	].

	uniformBufferCapacity := (requiredSize max: 4096) alignedTo: 4096.
	uniformBuffer := device createBuffer: (AGPUBufferDescription new
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST_TO_DEVICE;
		size: uniformBufferCapacity;
		usage_modes: AGPU_UNIFORM_BUFFER;
		main_usage_mode: AGPU_UNIFORM_BUFFER;
		mapping_flags: AGPU_MAP_WRITE_BIT;
		yourself) initial_data: nil.
		
	^ uniformBuffer
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
	usedResources removeAll.
]

{ #category : #initialization }
FormSGAGPUFrameStateTracker >> initializeWithDrawCommandProcessor: drawCommandProcessor [
	device := drawCommandProcessor device.
	vertexBinding := device createVertexBinding: drawCommandProcessor vertexLayout.

	uniformBinding := drawCommandProcessor shaderSignature createShaderResourceBinding: 1.
	viewBoxTransformsData := OrderedCollection new.
	linearGradientData := OrderedCollection new.
	radialGradientData := OrderedCollection new.
	usedResources := IdentitySet new.
	
	commandQueue := device getDefaultCommandQueue.
	commandAllocator := device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: commandQueue.
	commandList := device createCommandList: AGPU_COMMAND_LIST_TYPE_DIRECT allocator: commandAllocator initial_pipeline_state: nil.
	commandList close.
	
]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> recordUsedResource: resource [
	usedResources add: resource
]

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> setViewBoxScale: scale offset: offset [
	viewBoxTransformsData
		add: scale x asFloat;
		add: scale y asFloat;
		add: offset x asFloat;
		add: offset y asFloat.
	commandList pushConstants: 0 size: 4 values: (WordArray with: viewBoxTransformsCount).
	viewBoxTransformsCount := viewBoxTransformsCount + 1.
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

{ #category : #'as yet unclassified' }
FormSGAGPUFrameStateTracker >> submitUniformData [
	| destOffset copyFloatBlock uniformBufferAddress |
	self assert: viewBoxTransformsCount = expectedViewBoxTransformsCount.
	self assert: radialGradientsCount = expectedRadialGradientsCount.
	self assert: linearGradientsCount = expectedLinearGradientsCount.
	(viewBoxTransformsData isEmpty and: [ linearGradientData isEmpty and: [ radialGradientData isEmpty ] ]) ifTrue: [ ^ self ].

	uniformBufferAddress := (uniformBuffer mapBuffer: AGPU_WRITE_ONLY) getHandle.

	destOffset := 0.
	copyFloatBlock := [ :float |
		uniformBufferAddress float32AtOffset: destOffset put: float.
		destOffset := destOffset + 4
	].

	viewBoxTransformsData do: copyFloatBlock.
	linearGradientData do: copyFloatBlock.
	radialGradientData do: copyFloatBlock.

	uniformBuffer unmapBuffer.
]
