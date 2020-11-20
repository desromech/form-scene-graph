Class {
	#name : #FormSGAGPUDrawCommandProcessor,
	#superclass : #FormSGGPUDrawCommandProcessor,
	#instVars : [
		'device',
		'defaultRenderPass',
		'frameStateTracker',
		'fontTextureAtlasCache',
		'commandList',
		'baseVertex',
		'baseIndex',
		'shaderSignature',
		'vertexLayout',
		'colorPipelineState',
		'useSubpixelBlending'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor class >> drawThisWorld [
	<script>
	| sg fontTextureAtlasCache sgCommandList platform deviceOpenInfo device extent form drawCommandProcessor mainRenderTarget |
	sg := World buildFullSceneGraphWith: FormSGBuilder new.

	fontTextureAtlasCache := FormSGFontTextureAtlasCache new.
	sgCommandList := FormSGGPUCommandListBuilder  new.
	FormSGGPUCommandListRenderer new
		fontTextureAtlasCache: fontTextureAtlasCache;
		render: sg with: sgCommandList.

	platform := AGPU firstPlatform.
	deviceOpenInfo := AGPUDeviceOpenInfo new debug_layer: 1.
	device := platform openDevice: deviceOpenInfo.

	drawCommandProcessor := self for: device.
	extent := 1024@768.
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
	^ self basicNew initializeWithDevice: device; yourself
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> colorBufferFormat [
	^ AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB
]

{ #category : #shaders }
FormSGAGPUDrawCommandProcessor >> colorFragmentShader [
	^ '
#version 450

layout(location=0) in vec4 inColor;
layout(location=0) out vec4 outColor;
	
void main()
{ 
	outColor = vec4(inColor.rgb*inColor.a, inColor.a);
}

'
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> compileShader: shaderType source: shaderSource [
	| shaderCompiler sourceText |
	sourceText := shaderSource withUnixLineEndings utf8Encoded.
	shaderCompiler := device createOfflineShaderCompiler.
	^ [
		shaderCompiler
			setShaderSource: AGPU_SHADER_LANGUAGE_VGLSL stage: shaderType sourceText: sourceText	  sourceTextLength: sourceText size;
			compileShader: AGPU_SHADER_LANGUAGE_DEVICE_SHADER options: '';
			getResultAsShader
		] on: AGPUError do: [ :e |
			e errorCode = AGPU_COMPILATION_ERROR ifTrue: [ 
				| logLength logBuffer compilationError |
				logLength := shaderCompiler getCompilationLogLength.
				logBuffer := ExternalAddress allocate: logLength + 1.
				compilationError := [
					shaderCompiler getCompilationLog: logLength + 1 buffer: logBuffer.
					logBuffer readString.
				] ensure: [ logBuffer free ].
				self error: compilationError
			] ifFalse: [
				e signal
			]
		]
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> createPipelineStateBuilder [
	^ device createPipelineBuilder
		setShaderSignature: shaderSignature;
		setVertexLayout: vertexLayout;
		setRenderTargetCount: 1;	
		setRenderTargetFormat: 0 format: self colorBufferFormat;
		setDepthStencilFormat: AGPU_TEXTURE_FORMAT_UNKNOWN;
		setPrimitiveType: AGPU_TRIANGLES;
		setBlendState: 1 enabled: 1;
		setBlendFunction: 1
			sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA colorOperation: AGPU_BLENDING_OPERATION_ADD
			sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD;
		yourself
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> createPipelineStates [
	| vertexShader |
	vertexShader := self compileShader: AGPU_VERTEX_SHADER source: self vertexShader.
	colorPipelineState := self createPipelineStateBuilder
		attachShader: vertexShader;
		attachShader: (self compileShader: AGPU_FRAGMENT_SHADER source: self colorFragmentShader);
		build

		
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> createRenderPassWithColor: color [
	| colorAttachment |
	^ [
		| renderpassDescription |
		colorAttachment := AGPURenderpassColorAttachmentDescription externalNew.
		colorAttachment
			format: self colorBufferFormat;
			begin_action: AGPU_ATTACHMENT_CLEAR;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: color asAGPUColor4f;
			sample_count: 1;
			sample_quality: 0.
		renderpassDescription := AGPURenderpassDescription new.
		renderpassDescription
			color_attachment_count: 1;
			color_attachments: colorAttachment.
		device createRenderPass: renderpassDescription.
	] ensure: [colorAttachment free].

]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> createRenderTargetWithExtent: extent [
	| colorBuffer colorBufferView framebuffer |
	colorBuffer := device createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: extent x;
			height: extent y;
			depth: 1;
			layers: 1;
			miplevels: 1;
			format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
			usage_modes: (AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT bitOr: AGPU_TEXTURE_USAGE_READED_BACK);
			main_usage_mode: AGPU_TEXTURE_USAGE_READED_BACK;
			sample_count: 1).
	colorBufferView := colorBuffer getOrCreateFullView.
	framebuffer := device createFrameBuffer: extent x height: extent y colorCount: 1 colorViews: (AGPU packListOfReferences: {colorBufferView}) depthStencilView: nil.
	^ FormSGAGPURenderTarget new
		device: device;
		colorBuffer: colorBuffer;
		colorBufferView: colorBufferView;
		framebuffer: framebuffer;
		renderpass: defaultRenderPass;
		extent: extent;
		yourself
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> createShaderSignature [
	shaderSignature := device createShaderSignatureBuilder
		beginBindingBank: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 1;

		beginBindingBank: 100;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1;

		beginBindingBank: 1000;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		build
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> createVertexLayout [
	| layoutSpec strideBuffer |
	layoutSpec := 
		(AGPUVertexAttribDescription new
			binding: 0;
			format: AGPU_TEXTURE_FORMAT_R32G32_FLOAT;
			offset: 0;
			getHandle) ,
		(AGPUVertexAttribDescription new
			binding: 1;
			format: AGPU_TEXTURE_FORMAT_R32G32B32A32_FLOAT;
			offset: 8;
			getHandle),
		(AGPUVertexAttribDescription new
			binding: 2;
			format: AGPU_TEXTURE_FORMAT_R32G32_FLOAT;
			offset: 24;
			getHandle).
	
	strideBuffer := ByteArray new: 4.
	strideBuffer uint32AtOffset: 0 put: 32.
	
	vertexLayout := device createVertexLayout.
	vertexLayout addVertexAttributeBindings: 1 vertex_strides: strideBuffer attribute_count: 3 attributes: (AGPUVertexAttribDescription fromHandle: layoutSpec)

]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> defaultRenderPass [
	^ defaultRenderPass
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> device [
	^ device
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> drawElements: command [
	commandList drawElements: command indexCount instance_count: 1 first_index: command firstIndex + baseIndex base_vertex: baseVertex base_instance: 0
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> fontTextureAtlasCache [
	^ fontTextureAtlasCache ifNil: [ fontTextureAtlasCache := FormSGFontTextureAtlasCache new ]
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> fontTextureAtlasCache: aFontTextureAtlasCache [
	fontTextureAtlasCache := aFontTextureAtlasCache
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> initializeWithDevice: theDevice [
	device := theDevice.
	defaultRenderPass := self createRenderPassWithColor: Color transparent.
	self createShaderSignature.
	self createVertexLayout.
	self createPipelineStates.
	frameStateTracker := FormSGAGPUFrameStateTracker for: self.

]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> noTexture [
	commandList usePipelineState: colorPipelineState
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> processCommandListWithDependencies: mainSGCommandList mainRenderTarget: mainRenderTarget [
	| verticesOffsets indicesOffsets |
	verticesOffsets := self uploadVerticesForSGCommandsLists: {mainSGCommandList}.
	indicesOffsets := self uploadIndicesForSGCommandsLists: {mainSGCommandList}.
	
	frameStateTracker
		buildCommandListWith: [ :theCommandList |
			[
				|renderTarget|
				renderTarget := mainRenderTarget.
				commandList := theCommandList.
				commandList setShaderSignature: shaderSignature.
				frameStateTracker activateVerticesAndIndices.

				self processSGCommandList: mainSGCommandList renderTarget: mainRenderTarget verticesOffset: verticesOffsets first indicesOffsets: indicesOffsets first
			] ensure: [ commandList := nil]
		];
		submitToCommandQueue.

]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> processSGCommandList: sgCommandList renderTarget: renderTarget verticesOffset: verticesOffset indicesOffsets: indicesOffset [
	| extent |
	baseVertex := verticesOffset.
	baseIndex := indicesOffset.
	
	extent := renderTarget extent.
	commandList
		beginRenderPass: renderTarget renderpass framebuffer: renderTarget framebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: extent x h: extent y;
		setScissor: 0 y: 0 w: extent x h: extent y.

	self
		useCompositeAlphaBlending;
		noTexture.
	sgCommandList drawCommands do: [ :each |
		each accept: self
	].

	commandList
		endRenderPass
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setAthensSurfaceTextureWithModificationCount: athensSurfaceTexture [
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setFormTexture: formTexture [
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setFormTextureWithModificationCount: formTexture [
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setLinearGradientCommand: linearGradient [
	
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setRadialGradientCommand: radialGradient [
	
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setRenderTargetWithModificationCount: renderTargetValidationCommand [
	
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setScissor: command [
	
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> uploadIndicesForSGCommandsLists: sgCommandLists [
	| requiredSize offsets indexBuffer indexBufferAddress destOffset |
	requiredSize := 0.
	offsets := sgCommandLists collect: [ :each |
		| offset |
		offset := requiredSize.
		requiredSize := requiredSize + (each indices size * 2).
		offset // 2
	].

	indexBuffer := frameStateTracker ensureIndexBufferWithSize: requiredSize.
	indexBufferAddress := (indexBuffer mapBuffer: AGPU_WRITE_ONLY) getHandle.

	destOffset := 0.
	sgCommandLists do: [ :each |
		each indices do: [ :index |
			indexBufferAddress uint16AtOffset: destOffset put: index.
			destOffset := destOffset + 2
		]
	].
	self assert: destOffset = requiredSize.
	
	indexBuffer unmapBuffer.
	^ offsets
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> uploadVerticesForSGCommandsLists: sgCommandLists [
	| requiredSize offsets vertexBuffer vertexBufferAddress destOffset |
	requiredSize := 0.
	offsets := sgCommandLists collect: [ :each |
		| offset |
		offset := requiredSize.
		requiredSize := requiredSize + (each vertices size * 4).
		offset // 8
	].

	vertexBuffer := frameStateTracker ensureVertexBufferWithSize: requiredSize.
	vertexBufferAddress := (vertexBuffer mapBuffer: AGPU_WRITE_ONLY) getHandle.

	destOffset := 0.
	sgCommandLists do: [ :each |
		each vertices do: [ :vertex |
			vertexBufferAddress float32AtOffset: destOffset put: vertex.
			destOffset := destOffset + 4
		]
	].
	self assert: destOffset = requiredSize.
	
	vertexBuffer unmapBuffer.

	^ offsets
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> useCompositeAlphaBlending [
	useSubpixelBlending := false.
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> useSubpixelBlending [
	useSubpixelBlending := true.
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> useSubpixelFontFirstPassBlending [
	"This mode is unused"
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> useSubpixelFontSecondPassBlending [
	"This mode is unused"
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> vertexLayout [
	^ vertexLayout
]

{ #category : #shaders }
FormSGAGPUDrawCommandProcessor >> vertexShader [
	^ '
#version 450
layout(location=0) in vec2 inPosition;
layout(location=1) in vec4 inColor;
layout(location=2) in vec2 inTexcoord;

layout(location=0) out vec4 outColor;
layout(location=1) out vec2 outTexcoord;

void main()
{ 
	vec4 viewBoxTransform = vec4(1.0/1024.0, 1.0/1024.0, 0.0, 0.0);
	outColor = vec4(pow(inColor.rgb, vec3(2.2)), inColor.a);
	outTexcoord = inTexcoord;
	gl_Position = vec4(inPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}

'

]
