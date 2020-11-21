"
I am draw command processor that performs GPU rendering through by using the AbstractGPU library to communicate with Vulkan, Direct3D 12 and Metal.
"
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
		'subpixelPipelineState',
		'hasTopLeftNdcOrigin',
		'linearGradientPipelineState',
		'radialGradientPipelineState'
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

{ #category : #private }
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

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> colorGamma [
	^ 1.0
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
		
	linearGradientPipelineState := self createPipelineStateBuilder
		attachShader: vertexShader;
		attachShader: (self compileShader: AGPU_FRAGMENT_SHADER source: self linearGradientFragmentShader);
		build.

	radialGradientPipelineState := self createPipelineStateBuilder
		attachShader: vertexShader;
		attachShader: (self compileShader: AGPU_FRAGMENT_SHADER source: self radialGradientFragmentShader);
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

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> createRenderTargetWithExtent: extent [
	^ self createRenderTargetWithExtent: extent format: self colorBufferFormat
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> createRenderTargetWithExtent: extent format: format [
	| colorBuffer colorBufferView framebuffer binding |
	colorBuffer := device createTexture: (AGPUTextureDescription new
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
	binding := shaderSignature createShaderResourceBinding: 2.
	binding bindSampledTextureView: 0 view: colorBufferView.
	
	framebuffer := device createFrameBuffer: extent x height: extent y colorCount: 1 colorViews: (AGPU packListOfReferences: {colorBufferView}) depthStencilView: nil.
	^ FormSGAGPURenderTarget new
		device: device;
		colorBuffer: colorBuffer;
		colorBufferView: colorBufferView;
		binding: binding;
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
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1;

		beginBindingBank: 1000;
		addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1;
		
		"viewBoxTransformIndex" addBindingConstant;
		"gradientIndex" addBindingConstant;
		"colorGamma" addBindingConstant;
		"fontGamma" addBindingConstant;
		build
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> createTextureWithExtent: extent [
	^ self createTextureWithExtent: extent format: self colorBufferFormat
]

{ #category : #private }
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

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> drawElements: command [
	commandList drawElements: command indexCount instance_count: 1 first_index: command firstIndex + baseIndex base_vertex: baseVertex base_instance: 0
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> enableTexturing [
	useSubpixelBlending ifTrue: [ 
		self activatePipelineState: subpixelPipelineState
	] ifFalse: [ 
		self activatePipelineState: texturedPipelineState
	].

]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> fontGamma [
	^ 1.0
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> fontTextureAtlasCache [
	^ fontTextureAtlasCache ifNil: [ fontTextureAtlasCache := FormSGFontTextureAtlasCache new ]
]

{ #category : #accessing }
FormSGAGPUDrawCommandProcessor >> fontTextureAtlasCache: aFontTextureAtlasCache [
	fontTextureAtlasCache := aFontTextureAtlasCache
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> getOrCreateRenderTargetWithExtent: extent for: keyObject modificationCount: modificationCount [
	| renderTarget |
	renderTarget := renderTargetDictionary at: keyObject
		ifAbsentPut: [ self createRenderTargetWithExtent: extent ].
	(renderTarget extent ~= extent
	and: [ renderTarget modificationCount isNil or: [ renderTarget modificationCount < modificationCount ] ]) ifTrue: [
		renderTarget := renderTargetDictionary at: keyObject put: (self createRenderTargetWithExtent: extent)
	].
	^ renderTarget
]

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> getOrCreateTextureWithExtent: extent for: keyObject modificationCount: modificationCount [
	| texture |
	texture := textureWithModificationCountDictionary at: keyObject
		ifAbsentPut: [ self createTextureWithExtent: extent ].
	(texture extent ~= extent
	and: [ texture modificationCount isNil or: [ texture modificationCount < modificationCount ] ]) ifTrue: [
		texture := textureWithModificationCountDictionary at: keyObject put: (self createTextureWithExtent: extent)
	].
	^ texture
]

{ #category : #initialization }
FormSGAGPUDrawCommandProcessor >> initializeWithDevice: theDevice [
	device := theDevice.
	
	hasTopLeftNdcOrigin := device hasTopLeftNdcOrigin ~= 0.
	projectionInvertedY := hasTopLeftNdcOrigin.

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

{ #category : #testing }
FormSGAGPUDrawCommandProcessor >> isRenderTargetCommandValidated: command [
	| renderTarget |
	renderTarget := renderTargetDictionary at: command keyObject ifAbsent: [ ^ false ].
	^ renderTarget modificationCount isNotNil and: [renderTarget modificationCount >= command modificationCount]
]

{ #category : #shaders }
FormSGAGPUDrawCommandProcessor >> linearGradientFragmentShader [
	^ '
#version 450

layout(location=0) in vec4 inColor;
layout(location=1) in vec2 inTexcoord;
layout(location=0) out vec4 outColor;

struct LinearGradient {
	vec2 startPoint;
	vec2 endPoint;

	vec4 startColor;
	vec4 endColor;
};

layout(set=1, binding=1, std140) uniform LinearGradients { 
	LinearGradient linearGradients[1000];
};	

layout(push_constant) uniform Indices { 
	uint viewBoxTransformIndex;
	uint gradientIndex;
	float colorGamma;
};

void main()
{ 
	LinearGradient gradient = linearGradients[gradientIndex];
	vec2 gradientVector = gradient.endPoint - gradient.startPoint;
	float alpha = dot(inTexcoord - gradient.startPoint, gradientVector) / max(dot(gradientVector, gradientVector), 0.000001);

	vec4 startColor = vec4(pow(gradient.startColor.rgb, vec3(colorGamma)), gradient.startColor.a);
	vec4 endColor = vec4(pow(gradient.endColor.rgb, vec3(colorGamma)), gradient.endColor.a);
	vec4 resultColor = mix(startColor, endColor, alpha);

	outColor = vec4(resultColor.rgb*resultColor.a, resultColor.a);
}

'
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> noTexture [
	self activatePipelineState: colorPipelineState
]

{ #category : #api }
FormSGAGPUDrawCommandProcessor >> processCommandListWithDependencies: mainSGCommandList mainRenderTarget: mainRenderTarget [
	| verticesOffsets indicesOffsets sortedCommandList |
	sortedCommandList := FormSGAGPUCommandListSetBuilder new
		drawCommandProcessor: self;
		addCommandListWithDependencies: mainSGCommandList;
		sortedCommandLists.
	frameStateTracker finishPreviousExecution.
	verticesOffsets := self uploadVerticesForSGCommandsLists: sortedCommandList.
	indicesOffsets := self uploadIndicesForSGCommandsLists: sortedCommandList.
	
	frameStateTracker
		buildCommandListWith: [ :theCommandList |
			[
				commandList := theCommandList.
				commandList
					setShaderSignature: shaderSignature;
					useShaderResources: linearSamplerBinding.
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
		submitToCommandQueue.

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
	projectionInvertedY ifFalse: [ 
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

{ #category : #shaders }
FormSGAGPUDrawCommandProcessor >> radialGradientFragmentShader [
	^ '
#version 450

layout(location=0) in vec4 inColor;
layout(location=1) in vec2 inTexcoord;
layout(location=0) out vec4 outColor;

struct RadialGradient {
	vec2 center;
	vec2 focalPoint;

	float clipInnerRadius;
	float innerRadius;
	float outerRadius;
	float clipOuterRadius;

	vec4 startColor;
	vec4 endColor;
};

layout(set=1, binding=1, std140) uniform RadialGradients { 
	RadialGradient radialGradients[1000];
};	

layout(push_constant) uniform Indices { 
	uint viewBoxTransformIndex;
	uint gradientIndex;
	float colorGamma;
};

void main()
{ 
	RadialGradient gradient = radialGradients[gradientIndex];
	float radius = (length(inTexcoord - gradient.center) + length(inTexcoord - gradient.focalPoint))*0.5;
	if (radius < gradient.clipInnerRadius || radius > gradient.clipOuterRadius)
		discard;

	float alpha = clamp((radius - gradient.innerRadius) / max(gradient.outerRadius - gradient.innerRadius, 0.00001), 0.0, 1.0);

	vec4 startColor = vec4(pow(gradient.startColor.rgb, vec3(colorGamma)), gradient.startColor.a);
	vec4 endColor = vec4(pow(gradient.endColor.rgb, vec3(colorGamma)), gradient.endColor.a);
	vec4 resultColor = mix(startColor, endColor, alpha);

	outColor = vec4(resultColor.rgb*resultColor.a, resultColor.a);
}

'
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setAthensSurfaceTextureWithModificationCount: command [
	| texture |
	texture := self getOrCreateTextureWithExtent: command athensSurface extent for: command keyObject modificationCount: command modificationCount.
	texture uploadAthensSurface: command athensSurface withModificationCount: command modificationCount.

	self enableTexturing.
	texture recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: texture binding.
]

{ #category : #commands }
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

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setFormTextureWithModificationCount: command [
	| texture |
	texture := self getOrCreateTextureWithExtent: command form extent for: command keyObject modificationCount: command modificationCount.
	texture uploadForm: command form withModificationCount: command modificationCount.

	self enableTexturing.
	texture recordOnFrameStateTracker: frameStateTracker.
	commandList useShaderResources: texture binding.
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setLinearGradientCommand: command [
	self activatePipelineState: linearGradientPipelineState.
	frameStateTracker setLinearGradientStartPoint: command startPoint color: command startColor
		endPoint: command endPoint color: command endColor
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setRadialGradientCommand: command [
	self activatePipelineState: radialGradientPipelineState.
	frameStateTracker setRadialGradiantCenter: command center focalPoint: command focalPoint
		clipInnerRadius: command clipInnerRadius innerRadius: command innerRadius
		outerRadius: command outerRadius clipOuterRadius: command clipOuterRadius
		startColor: command startColor endColor: command endColor
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> setRenderTargetWithModificationCount: command [
	| renderTarget |
	renderTarget := self getOrCreateRenderTargetWithExtent: command extent for: command keyObject modificationCount: command modificationCount.

	self enableTexturing.
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
	
	hasTopLeftNdcOrigin ifTrue: [ 
		commandList setScissor: scissorMin x y: scissorMin y w: scissorMax x - scissorMin x h: scissorMax y - scissorMin y.
	] ifFalse: [ 
		commandList setScissor: scissorMin x y: screenHeight - scissorMax y w: scissorMax x - scissorMin x h: scissorMax y - scissorMin y.
	].

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

layout(push_constant) uniform Indices { 
	uint viewBoxTransformIndex;
	uint gradientIndex;
	float colorGamma;
	float fontGamma;
};

void main()
{ 
	vec3 colorMask = pow(texture(sampler2D(activeTexture, activeSampler), inTexcoord).rgb, vec3(fontGamma));
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

{ #category : #private }
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

{ #category : #private }
FormSGAGPUDrawCommandProcessor >> uploadVerticesForSGCommandsLists: sgCommandLists [
	| requiredSize offsets vertexBuffer vertexBufferAddress destOffset |
	requiredSize := 0.
	offsets := sgCommandLists collect: [ :each |
		| offset |
		offset := requiredSize.
		requiredSize := requiredSize + (each vertices size * 4).
		offset // 32
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

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> useCompositeAlphaBlending [
	useSubpixelBlending := false.
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> useSubpixelDualOutputBlending [
	useSubpixelBlending := true.
	
]

{ #category : #commands }
FormSGAGPUDrawCommandProcessor >> useSubpixelFontFirstPassBlending [
	"This mode is unused"
]

{ #category : #commands }
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

layout(set=1, binding=0, std140) uniform ViewBoxTransforms { 
	vec4 viewBoxTransforms[1000];
};	

layout(push_constant) uniform Indices { 
	uint viewBoxTransformIndex;
	uint gradientIndex;
	float colorGamma;
};

void main()
{
	vec4 viewBoxTransform = viewBoxTransforms[viewBoxTransformIndex];
	outColor = vec4(pow(inColor.rgb, vec3(colorGamma)), inColor.a);
	outTexcoord = inTexcoord;
	gl_Position = vec4(inPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}

'

]
