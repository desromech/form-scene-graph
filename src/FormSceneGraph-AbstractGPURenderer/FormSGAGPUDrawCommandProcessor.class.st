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
		'useSubpixelBlending',
		'viewportRectangle',
		'projectionInvertedY',
		'linearSampler',
		'linearSamplerBinding',
		'textureFromFormDictionary',
		'textureWithModificationCountDictionary',
		'renderTargetDictionary',
		'texturedPipelineState',
		'subpixelPipelineState'
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
	^ self basicNew initializeWithDevice: device; yourself
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> activatePipelineState: newPipelineState [
	commandList usePipelineState: newPipelineState
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> colorBufferFormat [
	^ AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM "AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB"
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
		build.

	texturedPipelineState := self createPipelineStateBuilder
		attachShader: vertexShader;
		attachShader: (self compileShader: AGPU_FRAGMENT_SHADER source: self texturedFragmentShader);
		build.

	subpixelPipelineState := self createPipelineStateBuilder
		attachShader: vertexShader;
		attachShader: (self compileShader: AGPU_FRAGMENT_SHADER source: self subpixelFragmentShader);
		setBlendFunction: 1
			sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_INVERTED_SRC_1COLOR colorOperation: AGPU_BLENDING_OPERATION_ADD
			sourceAlphaFactor: AGPU_BLENDING_ONE destAlphaFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA alphaOperation: AGPU_BLENDING_OPERATION_ADD;
		build.
		
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
FormSGAGPUDrawCommandProcessor >> createSampler [
	linearSampler := device createSampler: (AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_LINEAR;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		max_lod: 10000.0;
		yourself).
	linearSamplerBinding := shaderSignature createShaderResourceBinding: 0.
	linearSamplerBinding bindSampler: 0 sampler: linearSampler
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
		
		"viewBoxTransformIndex" addBindingConstant;
		"gradientIndex" addBindingConstant;
		build
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> createTextureWithExtent: extent [
	^ self createTextureWithExtent: extent format: self colorBufferFormat
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> createTextureWithExtent: extent format: format [
	| texture view binding |
	texture := device createTexture: (AGPUTextureDescription new
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
	binding := shaderSignature createShaderResourceBinding: 2.
	binding bindSampledTextureView: 0 view: view.
	
	^ FormSGAGPUTexture new
		texture: texture;
		view: view;
		extent: extent;
		binding: binding;
		yourself.
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

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> enableTexturing [
	useSubpixelBlending ifTrue: [ 
		self activatePipelineState: subpixelPipelineState
	] ifFalse: [ 
		self activatePipelineState: texturedPipelineState
	].

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
	
	projectionInvertedY := device hasTopLeftNdcOrigin ~= 0.

	defaultRenderPass := self createRenderPassWithColor: Color transparent.
	self
		createShaderSignature;
		createSampler;
		createVertexLayout;
		createPipelineStates.
	frameStateTracker := FormSGAGPUFrameStateTracker for: self.

	textureFromFormDictionary := WeakKeyDictionary new.
	textureWithModificationCountDictionary := WeakKeyDictionary new.
	renderTargetDictionary := WeakKeyDictionary new.
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> noTexture [
	self activatePipelineState: colorPipelineState
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> processCommandListWithDependencies: mainSGCommandList mainRenderTarget: mainRenderTarget [
	| verticesOffsets indicesOffsets sgCommandLists |
	sgCommandLists := {mainSGCommandList}.
	frameStateTracker finishPreviousExecution.
	verticesOffsets := self uploadVerticesForSGCommandsLists: sgCommandLists.
	indicesOffsets := self uploadIndicesForSGCommandsLists: sgCommandLists.
	
	frameStateTracker
		buildCommandListWith: [ :theCommandList |
			[
				|renderTarget|
				renderTarget := mainRenderTarget.
				commandList := theCommandList.
				commandList
					setShaderSignature: shaderSignature;
					useShaderResources: linearSamplerBinding.
				frameStateTracker
					allocateUniformStorageForSGCommandLists: sgCommandLists;
					activateUniforms;
					activateVerticesAndIndices.

				self processSGCommandList: mainSGCommandList renderTarget: mainRenderTarget verticesOffset: verticesOffsets first indicesOffsets: indicesOffsets first.
				
			] ensure: [ commandList := nil]
		];
		submitToCommandQueue.

]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> processSGCommandList: sgCommandList renderTarget: renderTarget verticesOffset: verticesOffset indicesOffsets: indicesOffset [
	| extent viewBoxScale viewBoxOffset |
	baseVertex := verticesOffset.
	baseIndex := indicesOffset.
	
	extent := renderTarget extent.
	commandList
		beginRenderPass: renderTarget renderpass framebuffer: renderTarget framebuffer bundle_content: 0;
		setViewport: 0 y: 0 w: extent x h: extent y;
		setScissor: 0 y: 0 w: extent x h: extent y.

	viewportRectangle := 0@0 extent: extent.
	projectionInvertedY ifFalse: [ 
		viewBoxScale := (2.0 / extent x) @ (-2.0 / extent y).
		viewBoxOffset := -1.0 @ 1.0.
	] ifTrue: [ 
		viewBoxScale := (2.0 / extent x) @ (2.0 / extent y).
		viewBoxOffset := -1.0 @ -1.0.
	].
	frameStateTracker setViewBoxScale: viewBoxScale offset: viewBoxOffset.

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
FormSGAGPUDrawCommandProcessor >> setAthensSurfaceTextureWithModificationCount: command [
	| texture |
	texture := textureWithModificationCountDictionary at: command keyObject
		ifAbsentPut: [ self createTextureWithExtent: command athensSurface extent ].
	texture extent ~= command athensSurface extent ifTrue: [
		texture := textureWithModificationCountDictionary at: command keyObject
			put: (self createTextureWithExtent: command athensSurface extent)
	].

	texture uploadAthensSurface: command athensSurface withModificationCount: command modificationCount.

	self enableTexturing.
	texture recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: texture binding.
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setFormTexture: formTexture [
	| texture |
	texture := textureFromFormDictionary at: formTexture form ifAbsentPut: [
		(self createTextureWithExtent: formTexture form extent)
			uploadForm: formTexture form;
			yourself
	].

	self enableTexturing.
	texture recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: texture binding.
	
]

{ #category : #'as yet unclassified' }
FormSGAGPUDrawCommandProcessor >> setFormTextureWithModificationCount: command [
	| texture |
	texture := textureWithModificationCountDictionary at: command keyObject
		ifAbsentPut: [ self createTextureWithExtent: command form extent ].
	texture extent ~= command form extent ifTrue: [
		texture := textureWithModificationCountDictionary at: command keyObject
			put: (self createTextureWithExtent: command form extent)
	].

	texture uploadForm: command form withModificationCount: command modificationCount.

	self enableTexturing.
	texture recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: texture binding.
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

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> shaderSignature [
	^ shaderSignature
]

{ #category : #shaders }
FormSGAGPUDrawCommandProcessor >> subpixelFragmentShader [
	^ '
#version 450

layout(location=0) in vec4 inColor;	
layout(location=1) in vec2 inTexcoord;

layout(location=0, index = 0) out vec4 outColor;
layout(location=0, index = 1) out vec4 outColorMask;

layout (set=2, binding = 0) uniform texture2D activeTexture;
layout (set=0, binding = 0) uniform sampler activeSampler;

void main()
{ 
	vec3 colorMask = texture(sampler2D(activeTexture, activeSampler), inTexcoord).rgb;
	float alpha = max(colorMask.r, max(colorMask.g, colorMask.b));

	outColor = vec4(inColor.rgb*colorMask, alpha);
	outColorMask = vec4(colorMask, alpha);
}

'
]

{ #category : #shaders }
FormSGAGPUDrawCommandProcessor >> texturedFragmentShader [
	^ '
#version 450

layout(location=0) in vec4 inColor;	
layout(location=1) in vec2 inTexcoord;

layout(location=0) out vec4 outColor;
	
layout (set=2, binding = 0) uniform texture2D activeTexture;
layout (set=0, binding = 0) uniform sampler activeSampler;

void main()
{ 
	vec4 color = inColor * texture(sampler2D(activeTexture, activeSampler), inTexcoord);
	outColor = vec4(color.rgb*color.a, color.a);
}

'
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
FormSGAGPUDrawCommandProcessor >> useSubpixelDualOutputBlending [
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

layout(set=1, binding=0) uniform ViewBoxTransforms { 
	vec4 viewBoxTransforms[1000];
};	

layout(push_constant) uniform Indices { 
	uint viewBoxTransformIndex;
};

void main()
{ 
	vec4 viewBoxTransform = viewBoxTransforms[viewBoxTransformIndex];
	outColor = inColor; //vec4(pow(inColor.rgb, vec3(2.2)), inColor.a);
	outTexcoord = inTexcoord;
	gl_Position = vec4(inPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}

'

]
