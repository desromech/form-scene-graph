"
I am a per frame state tracker. I am used for keeping track of the per frame GPU states and synchronization fences.
"
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

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> activateUniforms [
	commandList
		useShaderResources: uniformBinding
]

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> activateVerticesAndIndices [
	vertexBufferSize = 0 ifTrue: [ ^ self ].
	indexBufferSize = 0 ifTrue: [ ^ self ].
	
	commandList
		useIndexBuffer: indexBuffer;
		useVertexBinding: vertexBinding
]

{ #category : #allocation }
FormSGAGPUFrameStateTracker >> allocateUniformStorageForSGCommandLists: sgCommandLists [
	| viewBoxTransformDataSize linearGradientDataSize radialGradientDataSize |
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
	
	viewBoxTransformDataSize := expectedViewBoxTransformsCount * "4*4" 16 alignedTo: 256.
	linearGradientDataSize := linearGradientsCount * "12*4" 48 alignedTo: 256.
	radialGradientDataSize := radialGradientsCount * "16*4" 64 alignedTo: 256.
	self ensureUniformBufferWithSize: viewBoxTransformDataSize + linearGradientDataSize + radialGradientDataSize.
	
	uniformBinding
		bindUniformBufferRange: 0 uniform_buffer: uniformBuffer offset: 0 size: (viewBoxTransformDataSize max: 256);
		bindUniformBufferRange: 1 uniform_buffer: uniformBuffer offset: viewBoxTransformDataSize size: (linearGradientDataSize max: 256);
		bindUniformBufferRange: 2 uniform_buffer: uniformBuffer offset: viewBoxTransformDataSize + linearGradientDataSize size: (radialGradientDataSize max: 256)
]

{ #category : #'draw commands' }
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

{ #category : #allocation }
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

{ #category : #allocation }
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

{ #category : #allocation }
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

{ #category : #'draw commands' }
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

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> recordUsedResource: resource [
	usedResources add: resource
]

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> setColorGamma: gamma [
	commandList pushConstants: 8 size: 4 values: (FloatArray with: gamma).

]

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> setFontGamma: gamma [
	commandList pushConstants: 12 size: 4 values: (FloatArray with: gamma).

]

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> setLinearGradientStartPoint: startPoint color: startColor endPoint: endPoint color: endColor [
	linearGradientData
		add: startPoint x asFloat;
		add: startPoint y asFloat;
		add: endPoint x asFloat;
		add: endPoint y asFloat;
		
		add: startColor red;
		add: startColor green;
		add: startColor blue;
		add: startColor alpha;

		add: endColor red;
		add: endColor green;
		add: endColor blue;
		add: endColor alpha.
		
	commandList pushConstants: 4 size: 4 values: (WordArray with: linearGradientsCount).
	linearGradientsCount := linearGradientsCount + 1.
]

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> setRadialGradiantCenter: center focalPoint: focalPoint clipInnerRadius: clipInnerRadius innerRadius: innerRadius outerRadius: outerRadius clipOuterRadius: clipOuterRadius startColor: startColor endColor: endColor [ 
	radialGradientData
		add: center x asFloat;
		add: center y asFloat;
		add: focalPoint x asFloat;
		add: focalPoint y asFloat;

		add: clipInnerRadius asFloat;
		add: innerRadius asFloat;
		add: outerRadius asFloat;
		add: clipOuterRadius asFloat;
		
		add: startColor red;
		add: startColor green;
		add: startColor blue;
		add: startColor alpha;

		add: endColor red;
		add: endColor green;
		add: endColor blue;
		add: endColor alpha.
		
	commandList pushConstants: 4 size: 4 values: (WordArray with: radialGradientsCount).
	radialGradientsCount := radialGradientsCount + 1.
]

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> setViewBoxScale: scale offset: offset [
	viewBoxTransformsData
		add: scale x asFloat;
		add: scale y asFloat;
		add: offset x asFloat;
		add: offset y asFloat.
	commandList pushConstants: 0 size: 4 values: (WordArray with: viewBoxTransformsCount).
	viewBoxTransformsCount := viewBoxTransformsCount + 1.
]

{ #category : #'draw commands' }
FormSGAGPUFrameStateTracker >> submitToCommandQueue [
	fence ifNil: [
		fence := device createFence
	].
	commandQueue
		addCommandList: commandList;
		signalFence: fence.
]

{ #category : #'draw commands' }
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
	destOffset := destOffset alignedTo: 256.

	linearGradientData do: copyFloatBlock.
	destOffset := destOffset alignedTo: 256.

	radialGradientData do: copyFloatBlock.
	destOffset := destOffset alignedTo: 256.

	uniformBuffer unmapBuffer.
]
