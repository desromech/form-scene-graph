Class {
	#name : #FormSGExternallySynchronizedAGPUDrawCommandProcessorWithStateTracker,
	#superclass : #FormSGExternallySynchronizedAGPUDrawCommandProcessor,
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #private }
FormSGExternallySynchronizedAGPUDrawCommandProcessorWithStateTracker >> enableTexturing [
	hasTexture := true.
	useSubpixelBlending ifTrue: [
		hasDirectSubpixelBlending ifTrue: [ 
			commandList
				setFragmentStage: context subpixelFragmentShader entryPoint: 'main';
				setBlendState: -1 enabled: 1;
				setBlendFunction: 1
					sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_1COLOR colorOperation: AGPU_BLENDING_OPERATION_ADD
				sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD
		] ifFalse: [
			useSubpixelBlendingFirstPass ifTrue: [
				commandList
					setFragmentStage: context subpixelFirstPassFragmentShader entryPoint: 'main';
					setBlendState: -1 enabled: 1;
					setBlendFunction: 1
						sourceFactor: AGPU_BLENDING_ZERO destFactor: AGPU_BLENDING_INVERTED_SRC_COLOR colorOperation: AGPU_BLENDING_OPERATION_ADD
						sourceAlphaFactor: AGPU_BLENDING_ZERO destAlphaFactor: AGPU_BLENDING_ONE alphaOperation: AGPU_BLENDING_OPERATION_ADD
			] ifFalse: [
				commandList
					setFragmentStage: context subpixelSecondPassFragmentShader entryPoint: 'main';
					setBlendState: -1 enabled: 1;
					setBlendFunction: 1
						sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_ONE colorOperation: AGPU_BLENDING_OPERATION_ADD
						sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD
			]
		].
	] ifFalse: [
		hasFullyOpaqueBlending ifTrue: [ 
			commandList
				setFragmentStage: context fullyOpaqueTexturedFragmentShader entryPoint: 'main';
				setBlendState: -1 enabled: 0;
				setBlendFunction: 1
					sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_ZERO colorOperation: AGPU_BLENDING_OPERATION_ADD
					sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_ZERO alphaOperation: AGPU_BLENDING_OPERATION_ADD
		] ifFalse: [
			commandList
				setFragmentStage: context texturedFragmentShader entryPoint: 'main';
				setBlendState: -1 enabled: 1;
				setBlendFunction: 1
					sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA colorOperation: AGPU_BLENDING_OPERATION_ADD
					sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD
		].
	].
	blendingChanged := false.
]

{ #category : #private }
FormSGExternallySynchronizedAGPUDrawCommandProcessorWithStateTracker >> noTexture [
	hasTexture := false.
	blendingChanged := false.
	commandList
		setFragmentStage: context colorFragmentShader entryPoint: 'main';
		setBlendState: -1 enabled: 1;
		setBlendFunction: 1
			sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA colorOperation: AGPU_BLENDING_OPERATION_ADD
			sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD
]

{ #category : #api }
FormSGExternallySynchronizedAGPUDrawCommandProcessorWithStateTracker >> processCommandListWithDependencies: mainSGCommandList mainRenderTarget: mainRenderTarget thenCommitSurfaceWith: commitSurfaceBlock [
	| verticesOffsets indicesOffsets sortedCommandList |
	sortedCommandList := FormSGAGPUCommandListSetBuilder new
		drawCommandProcessor: self;
		addCommandListWithDependencies: mainSGCommandList;
		sortedCommandLists.

	frameStateTracker finishPreviousExecution.

	verticesOffsets := self uploadVerticesForSGCommandsLists: sortedCommandList.
	indicesOffsets := self uploadIndicesForSGCommandsLists: sortedCommandList.
	self uploadModifiedTextureFontCachePages.
	
	frameStateTracker
		buildCommandListWith: [ :theCommandList |
			[
				commandList := theCommandList.
				commandList
					resetGraphicsPipeline;
					setShaderSignature: context shaderSignature;
					useShaderResources: context linearSamplerBinding;
					setVertexStage: context vertexShader entryPoint: 'main';
					setVertexLayout: context vertexLayout;
					setPrimitiveType: AGPU_TRIANGLES.
				frameStateTracker
					allocateUniformStorageForSGCommandLists: sortedCommandList;
					activateUniforms;
					activateVerticesAndIndices.
					
				sortedCommandList doWithIndex: [ :each :index |
					| renderTarget |
					renderTarget := each renderTargetCommandForRenderPass
						ifNotNil: [ :passCommand |
							self getOrCreateRenderTargetWithExtent: passCommand extent for: passCommand keyObject modificationCount: passCommand modificationCount
						]
						ifNil: [ mainRenderTarget ].

					self processSGCommandList: each renderTarget: renderTarget
						verticesOffset: (verticesOffsets at: index)
						indicesOffsets: (indicesOffsets at: index).
				].

			] ensure: [ commandList := nil]
		];
		submitToCommandQueueThenCommitSurfaceWith: commitSurfaceBlock.
		
	frameIndex := (frameIndex + 1) % frameStateTrackers size.
	frameStateTracker := frameStateTrackers at: frameIndex + 1.

]

{ #category : #private }
FormSGExternallySynchronizedAGPUDrawCommandProcessorWithStateTracker >> setLinearGradientCommand: command [
	hasTexture := false.
	commandList setFragmentStage: context linearGradientFragmentShader entryPoint: 'main';
		setBlendState: -1 enabled: 1;
		setBlendFunction: 1
			sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA colorOperation: AGPU_BLENDING_OPERATION_ADD
			sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD.
	frameStateTracker setLinearGradientStartPoint: command startPoint color: command startColor
		endPoint: command endPoint color: command endColor
]

{ #category : #private }
FormSGExternallySynchronizedAGPUDrawCommandProcessorWithStateTracker >> setRadialGradientCommand: command [
	hasTexture := false.
	commandList setFragmentStage: context radialGradientFragmentShader entryPoint: 'main';
		setBlendState: -1 enabled: 1;
		setBlendFunction: 1
			sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA colorOperation: AGPU_BLENDING_OPERATION_ADD
			sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD.
	frameStateTracker setRadialGradiantCenter: command center focalPoint: command focalPoint
		clipInnerRadius: command clipInnerRadius innerRadius: command innerRadius
		outerRadius: command outerRadius clipOuterRadius: command clipOuterRadius
		startColor: command startColor endColor: command endColor
]

{ #category : #private }
FormSGExternallySynchronizedAGPUDrawCommandProcessorWithStateTracker >> setRenderTargetWithModificationCount: command [
	| renderTarget |
	renderTarget := self getOrCreateRenderTargetWithExtent: command extent for: command keyObject modificationCount: command modificationCount.

	hasTexture := false.
	commandList
		setFragmentStage: context premultipliedTexturedFragmentShader entryPoint: 'main';
		setBlendState: -1 enabled: 1;
		setBlendFunction: 1
			sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA colorOperation: AGPU_BLENDING_OPERATION_ADD
			sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD.
	renderTarget recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: renderTarget binding.
	
]
