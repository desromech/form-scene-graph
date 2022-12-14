"
I am draw command processor that performs GPU rendering through by using the AbstractGPU library to communicate with Vulkan, Direct3D 12 and Metal.
"
Class {
	#name : #FormSGAGPUDrawCommandProcessor,
	#superclass : #FormSGGPUDrawCommandProcessor,
	#instVars : [
		'context',
		'useSubpixelBlending',
		'hasFullyOpaqueBlending',
		'frameStateTracker',
		'commandList',
		'baseIndex',
		'baseVertex',
		'viewportRectangle',
		'frameStateTrackers',
		'frameIndex',
		'useSubpixelBlendingFirstPass',
		'hasDirectSubpixelBlending',
		'blendingChanged',
		'hasTexture'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor class >> defaultFrameBufferingCount [
	^ 2
]

{ #category : #'sample script' }
FormSGAGPUDrawCommandProcessor class >> drawThisWorld [
	<script>
	| sg fontTextureAtlasCache sgCommandList platform deviceOpenInfo device extent form drawCommandProcessor mainRenderTarget |
	sg := World buildFullSceneGraphWith: FormSGBuilder new.

	fontTextureAtlasCache := FormSGFontTextureAtlasCache new.
	sgCommandList := FormSGGPUCommandListBuilder  new.
	FormSGGPUCommandListRenderer new
		fontTextureAtlasCache: fontTextureAtlasCache;
		hasDirectSubpixelBlending: true;
		render: sg with: sgCommandList.

	platform := AGPU firstPlatform.
	deviceOpenInfo := AGPUDeviceOpenInfo new debug_layer: 1.
	device := platform openDevice: deviceOpenInfo.

	drawCommandProcessor := self for: device.
	extent := World extent ceiling.
	mainRenderTarget := drawCommandProcessor createRenderTargetWithExtent: extent.

	drawCommandProcessor
		processCommandListWithDependencies: sgCommandList mainRenderTarget: mainRenderTarget.
	device getDefaultCommandQueue finishExecution.
	
	form := Form extent: extent depth: 32.
	form unhibernate.
	mainRenderTarget colorBuffer readTextureData: 0 arrayIndex: 0 pitch: extent x *4 slicePitch: extent x * extent y * 4 buffer: form bits.
	form asMorph inspect
]

{ #category : #'instance creation' }
FormSGAGPUDrawCommandProcessor class >> for: device [
	^ self forContext: (FormSGAGPUDrawCommandProcessorContext for: device)
]

{ #category : #'instance creation' }
FormSGAGPUDrawCommandProcessor class >> forContext: context [
	^ self forContext: context withFrameBufferingCount: self defaultFrameBufferingCount
]

{ #category : #'instance creation' }
FormSGAGPUDrawCommandProcessor class >> forContext: context withFrameBufferingCount: frameBufferingCount [
	^ self basicNew
		initializeWithContext: context frameBufferingCount: frameBufferingCount;
		yourself
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> activatePipelineState: newPipelineState [
	commandList usePipelineState: newPipelineState
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> colorBufferFormat [
	^ context colorBufferFormat
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> colorGamma [
	^ context colorGamma
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> context [
	^ context
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> createRenderTargetWithExtent: extent [
	^ self createRenderTargetWithExtent: extent format: self colorBufferFormat
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> createRenderTargetWithExtent: extent colorBuffer: colorBuffer colorBufferView: colorBufferView framebuffer: framebuffer [
	| binding |
	binding := nil.
	colorBufferView ifNotNil: [ 
		binding := context shaderSignature createShaderResourceBinding: 2.
		binding bindSampledTextureView: 0 view: colorBufferView.
	].
	
	^ FormSGAGPURenderTarget new
		device: context device;
		colorBuffer: colorBuffer;
		colorBufferView: colorBufferView;
		binding: binding;
		framebuffer: framebuffer;
		renderpass: context defaultRenderPass;
		extent: extent;
		yourself
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> createRenderTargetWithExtent: extent format: format [
	| colorBuffer colorBufferView framebuffer |
	colorBuffer := context device createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: extent x;
			height: extent y;
			depth: 1;
			layers: 1;
			miplevels: 1;
			format: format;
			usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT | AGPU_TEXTURE_USAGE_READED_BACK | AGPU_TEXTURE_USAGE_SAMPLED);
			main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
			sample_count: 1).
	colorBufferView := colorBuffer getOrCreateFullView.
	framebuffer := context device createFrameBuffer: extent x height: extent y colorCount: 1 colorViews: (AGPU packListOfReferences: {colorBufferView}) depthStencilView: nil.
	^ self createRenderTargetWithExtent: extent colorBuffer: colorBuffer colorBufferView: colorBufferView framebuffer: framebuffer
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> createTextureWithExtent: extent [
	^ self createTextureWithExtent: extent format: self colorBufferFormat
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> createTextureWithExtent: extent format: format [
	| texture view binding |
	texture := context device createTexture: (AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: extent x;
		height: extent y;
		depth: 1;
		layers: 1;
		miplevels: 1;
		format: format;
		usage_modes: AGPU_TEXTURE_USAGE_UPLOADED | AGPU_TEXTURE_USAGE_SAMPLED;
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		sample_count: 1).
		
	view := texture getOrCreateFullView.
	binding := context shaderSignature createShaderResourceBinding: 2.
	binding bindSampledTextureView: 0 view: view.
	
	^ FormSGAGPUTexture new
		texture: texture;
		view: view;
		extent: extent;
		binding: binding;
		yourself.
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> defaultRenderPass [
	^ context defaultRenderPass
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> device [
	^ context device
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> drawElements: command [
	self validateState.
	commandList drawElements: command indexCount instance_count: 1 first_index: command firstIndex + baseIndex base_vertex: baseVertex base_instance: 0
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> enableTexturing [
	hasTexture := true.
	useSubpixelBlending ifTrue: [
		hasDirectSubpixelBlending ifTrue: [ 
			self activatePipelineState: context subpixelPipelineState
		] ifFalse: [
			useSubpixelBlendingFirstPass ifTrue: [
				self activatePipelineState: context subpixelFirstPassPipelineState
			] ifFalse: [
				self activatePipelineState: context subpixelSecondPassPipelineState
			]
		].
	] ifFalse: [
		hasFullyOpaqueBlending ifTrue: [ 
			self activatePipelineState: context fullyOpaqueTexturedPipelineState
		] ifFalse: [
			self activatePipelineState: context texturedPipelineState
		].
	].
	blendingChanged := false.
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> fontGamma [
	^ context fontGamma
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> fontTextureAtlasCache [
	^ context fontTextureAtlasCache
]

{ #category : #hooks }
FormSGAGPUDrawCommandProcessor >> frameStateTrackerClass [
	^ FormSGStandaloneAGPUFrameStateTracker
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> getOrCreateRenderTargetWithExtent: extent for: keyObject modificationCount: modificationCount [
	| renderTarget |
	renderTarget := context renderTargetDictionary at: keyObject
		ifAbsentPut: [ self createRenderTargetWithExtent: extent ].
	renderTarget extent ~= extent ifTrue: [
		renderTarget := context renderTargetDictionary at: keyObject put: (self createRenderTargetWithExtent: extent)
	].
	^ renderTarget
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> getOrCreateTextureWithExtent: extent for: keyObject modificationCount: modificationCount format: textureFormat [
	| texture |
	texture := context textureWithModificationCountDictionary at: keyObject
		ifAbsentPut: [ self createTextureWithExtent: extent format: textureFormat ].
	texture extent ~= extent ifTrue: [
		texture := context textureWithModificationCountDictionary at: keyObject put: (self createTextureWithExtent: extent format: textureFormat)
	].
	^ texture
]

{ #category : #testing }
FormSGAGPUDrawCommandProcessor >> hasDirectSubpixelBlending [
	^ hasDirectSubpixelBlending
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> initializeWithContext: theContext frameBufferingCount: frameBufferingCount [
	context := theContext.
	hasDirectSubpixelBlending := context hasDirectSubpixelBlending.
	frameStateTrackers := (1 to: frameBufferingCount) collect: [ :i | self frameStateTrackerClass for: self ].
	frameStateTracker := frameStateTrackers first.
	frameIndex := 0.
]

{ #category : #testing }
FormSGAGPUDrawCommandProcessor >> isRenderTargetCommandValidated: command [
	| renderTarget |
	renderTarget := context renderTargetDictionary at: command keyObject ifAbsent: [ ^ false ].
	^ renderTarget modificationCount notNil and: [
	renderTarget modificationCount >= command modificationCount and: [
	renderTarget extent = command extent ]]
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> noTexture [
	hasTexture := false.
	blendingChanged := false.
	self activatePipelineState: context colorPipelineState.
]

{ #category : #api }
FormSGAGPUDrawCommandProcessor >> processCommandListWithDependencies: mainSGCommandList mainRenderTarget: mainRenderTarget [
	self processCommandListWithDependencies: mainSGCommandList mainRenderTarget: mainRenderTarget thenCommitSurfaceWith: []
]

{ #category : #api }
FormSGAGPUDrawCommandProcessor >> processCommandListWithDependencies: mainSGCommandList mainRenderTarget: mainRenderTarget thenCommitSurfaceWith: commitSurfaceBlock [
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
					setShaderSignature: context shaderSignature;
					useShaderResources: context linearSamplerBinding.
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
FormSGAGPUDrawCommandProcessor >> processSGCommandList: sgCommandList renderTarget: renderTarget verticesOffset: verticesOffset indicesOffsets: indicesOffset [
	| extent viewBoxScale viewBoxOffset |
	baseVertex := verticesOffset.
	baseIndex := indicesOffset.
	sgCommandList renderTargetCommandForRenderPass ifNotNil: [ :rpCommand |
		(renderTarget modificationCount isNil or: [renderTarget modificationCount < rpCommand modificationCount]) ifTrue: [
			renderTarget modificationCount: rpCommand modificationCount
		]
	].
	
	extent := renderTarget extent.
	commandList
		beginRenderPass: renderTarget renderpass framebuffer: renderTarget framebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: extent x h: extent y;
		setScissor: 0 y: 0 w: extent x h: extent y.

	viewportRectangle := 0@0 extent: extent.
	context projectionInvertedY ifFalse: [ 
		viewBoxScale := (2.0 / extent x) @ (-2.0 / extent y).
		viewBoxOffset := -1.0 @ 1.0.
	] ifTrue: [ 
		viewBoxScale := (2.0 / extent x) @ (2.0 / extent y).
		viewBoxOffset := -1.0 @ -1.0.
	].
	frameStateTracker
		setColorGamma: self colorGamma;
		setFontGamma: self fontGamma;
		setViewBoxScale: viewBoxScale offset: viewBoxOffset.

	self
		useCompositeAlphaBlending;
		noTexture.
	sgCommandList drawCommands do: [ :each |
		each accept: self
	].

	commandList
		endRenderPass
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> setAGPUTextureNode: textureNode [
	self assert: textureNode binding notNil.
	frameStateTracker
		recordUsedResource: textureNode texture;
		recordUsedResource: textureNode view;
		recordUsedResource: textureNode binding.
	commandList useShaderResources: textureNode binding.
	self enableTexturing.

]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setAthensSurfaceTextureWithModificationCount: command [
	| texture |
	texture := self getOrCreateTextureWithExtent: command athensSurface extent for: command keyObject modificationCount: command modificationCount format: self colorBufferFormat.
	texture uploadAthensSurface: command athensSurface withModificationCount: command modificationCount.

	self enableTexturing.
	texture recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: texture binding.
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setFormTexture: formTexture [
	| texture |
	texture := context textureFromFormDictionary at: formTexture form ifAbsentPut: [
		(self createTextureWithExtent: formTexture form extent)
			uploadForm: formTexture form;
			yourself
	].

	self enableTexturing.
	texture recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: texture binding.
	
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setFormTextureWithModificationCount: command [
	| texture textureFormat |
	textureFormat := self colorBufferFormat.
	command isLinearTexture ifTrue: [ textureFormat := AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM ].
	texture := self getOrCreateTextureWithExtent: command form extent for: command keyObject modificationCount: command modificationCount format: textureFormat.
	texture uploadForm: command form withModificationCount: command modificationCount.

	self enableTexturing.
	texture recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: texture binding.
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setLinearGradientCommand: command [
	hasTexture := false.
	self activatePipelineState: context linearGradientPipelineState.
	frameStateTracker setLinearGradientStartPoint: command startPoint color: command startColor
		endPoint: command endPoint color: command endColor
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setRadialGradientCommand: command [
	hasTexture := false.
	self activatePipelineState: context radialGradientPipelineState.
	frameStateTracker setRadialGradiantCenter: command center focalPoint: command focalPoint
		clipInnerRadius: command clipInnerRadius innerRadius: command innerRadius
		outerRadius: command outerRadius clipOuterRadius: command clipOuterRadius
		startColor: command startColor endColor: command endColor
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setRenderTargetWithModificationCount: command [
	| renderTarget |
	renderTarget := self getOrCreateRenderTargetWithExtent: command extent for: command keyObject modificationCount: command modificationCount.

	hasTexture := false.
	self activatePipelineState: context premultipliedTexturedPipelineState.
	renderTarget recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: renderTarget binding.
	
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setScissor: command [
	| viewClippedRectangle scissorMin scissorMax screenHeight |
	viewClippedRectangle := command rectangle intersect: viewportRectangle ifNone: [
		commandList setScissor: 0 y: 0 w: 0 h: 0.
		^ self
	].

	screenHeight := viewportRectangle height.
	scissorMin := viewClippedRectangle origin floor.
	scissorMax := viewClippedRectangle corner ceiling.
	
	commandList setScissor: scissorMin x y: scissorMin y w: scissorMax x - scissorMin x h: scissorMax y - scissorMin y.
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> uploadIndicesForSGCommandsLists: sgCommandLists [
	| requiredSize offsets indexBuffer destOffset encodedIndices |
	requiredSize := 0.
	offsets := sgCommandLists collect: [ :each |
		| offset |
		offset := requiredSize.
		requiredSize := requiredSize + (each indices size * 2).
		offset // 2
	].

	indexBuffer := frameStateTracker ensureIndexBufferWithSize: requiredSize.

	encodedIndices := ByteArray new: requiredSize.
	destOffset := 0.
	sgCommandLists do: [ :each |
		each indices do: [ :index |
			encodedIndices uint16AtOffset: destOffset put: index.
			destOffset := destOffset + 2
		]
	].
	self assert: destOffset = requiredSize.

	indexBuffer uploadBufferData: 0 size: requiredSize data: encodedIndices.
	^ offsets
]

{ #category : #api }
FormSGAGPUDrawCommandProcessor >> uploadModifiedTextureFontCachePages [
	self fontTextureAtlasCache modifiedPages do: [ :page |
		(self getOrCreateTextureWithExtent: page form extent for: page modificationCount: page modificationCount format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM)
			uploadForm: page form withModificationCount: page modificationCount
	]
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> uploadVerticesForSGCommandsLists: sgCommandLists [
	| requiredSize offsets vertexBuffer destOffset encodedVertices |
	requiredSize := 0.
	offsets := sgCommandLists collect: [ :each |
		| offset |
		offset := requiredSize.
		requiredSize := requiredSize + (each vertices size * 4).
		offset // 32
	].

	vertexBuffer := frameStateTracker ensureVertexBufferWithSize: requiredSize.

	encodedVertices := ByteArray new: requiredSize.
	destOffset := 0.
	sgCommandLists do: [ :each |
		each vertices do: [ :vertex |
			encodedVertices float32AtOffset: destOffset put: vertex.
			destOffset := destOffset + 4
		]
	].
	self assert: destOffset = requiredSize.

	vertexBuffer uploadBufferData: 0 size: requiredSize data: encodedVertices.

	^ offsets
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> useCompositeAlphaBlending [
	useSubpixelBlending := false.
	hasFullyOpaqueBlending := false.
	blendingChanged := true.
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> useFullyOpaqueBlending [
	useSubpixelBlending := false.
	hasFullyOpaqueBlending := true.
	blendingChanged := true.
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> useSubpixelDualOutputBlending [
	self assert: hasDirectSubpixelBlending. 
	useSubpixelBlending := true.
	blendingChanged := true.
	
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> useSubpixelFontFirstPassBlending [
	self assert: hasDirectSubpixelBlending not.
	useSubpixelBlending := true.
	useSubpixelBlendingFirstPass := true.
	blendingChanged := true.
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> useSubpixelFontSecondPassBlending [
	self assert: hasDirectSubpixelBlending not.
	useSubpixelBlending := true.
	useSubpixelBlendingFirstPass := false.
	blendingChanged := true.
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> validateState [
	(blendingChanged and: [ hasTexture ]) ifTrue: [ 
		self enableTexturing
	].

]
