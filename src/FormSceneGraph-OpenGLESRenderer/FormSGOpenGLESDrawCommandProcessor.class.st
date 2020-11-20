"
I am a draw command processor that internally uses OpenGL ES for drawing a scene graph.
"
Class {
	#name : #FormSGOpenGLESDrawCommandProcessor,
	#superclass : #FormSGGPUDrawCommandProcessor,
	#instVars : [
		'context',
		'gl',
		'vertexBuffer',
		'indexBuffer',
		'colorProgram',
		'activeProgram',
		'viewBoxScale',
		'viewBoxOffset',
		'viewportRectangle',
		'texturedProgram',
		'fontTextureAtlasCache',
		'renderTargetComposeProgram',
		'radialGradientProgram',
		'linearGradientProgram',
		'isSubpixelMask'
	],
	#pools : [
		'UFFIOpenGLConstants'
	],
	#category : #'FormSceneGraph-OpenGLESRenderer'
}

{ #category : #'instance creation' }
FormSGOpenGLESDrawCommandProcessor class >> for: aContext [
	^ self new initializeWithContext: aContext
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> activateProgram: program [
	activeProgram == program ifTrue: [ ^ self ].
	
	gl useProgram: program validHandle.
	program
		uniform: #viewBoxTransform float: viewBoxScale x float: viewBoxScale y float: viewBoxOffset x float: viewBoxOffset y;
		uniform: #activeTexture int: 0;
		uniform: #isSubpixelMask float: isSubpixelMask.
	activeProgram := program.

]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> activateVertexLayout [
	| vertexSize |
	vertexSize := ("position" 2 + "color" 4 + "texcoord" 2)*4.
	
	context gl
		enableVertexAttribArray: 0;
		vertexAttribPointer_index: 0 size: 2 type: GL_FLOAT normalized: GL_FALSE stride: vertexSize pointer: (ExternalAddress fromAddress: 0);
		
		enableVertexAttribArray: 1;
		vertexAttribPointer_index: 1 size: 4 type: GL_FLOAT normalized: GL_FALSE stride: vertexSize pointer: (ExternalAddress fromAddress: 8);
		
		enableVertexAttribArray: 2;
		vertexAttribPointer_index: 2 size: 2 type: GL_FLOAT normalized: GL_FALSE stride: vertexSize pointer: (ExternalAddress fromAddress: 24)
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> beginRenderPass: framebuffer clearColor: clearColor [
	framebuffer activate.
	^ self beginRenderPassWithExtent: framebuffer extent clearColor: clearColor
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> beginRenderPassWithExtent: framebufferExtent clearColor: clearColor [
	viewportRectangle := 0@0 extent: framebufferExtent.
	viewBoxScale := (2.0 / framebufferExtent x) @ (-2.0 / framebufferExtent y).
	viewBoxOffset := -1.0 @ 1.0.
	activeProgram := nil.
	isSubpixelMask := 0.0.

	gl
		viewport_x: 0 y: 0 width: framebufferExtent x height: framebufferExtent y;
		enable: GL_SCISSOR_TEST;
		scissor_x: 0 y: 0 width: framebufferExtent x height: framebufferExtent y;
				
		clearColor_red: clearColor red green: clearColor green blue: clearColor blue alpha: clearColor alpha;
		clear: GL_COLOR_BUFFER_BIT;

		enable: GL_BLEND.
	self useCompositeAlphaBlending
]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> colorFragmentShader [
	^ '
#version 100

varying highp vec4 fColor;

void main()
{ 
	gl_FragData[0] = vec4(fColor.rgb*fColor.a, fColor.a);
}

'
]

{ #category : #compiling }
FormSGOpenGLESDrawCommandProcessor >> compileShader: shaderSource type: shaderType [
	| shader |
	shader := UFFIOpenGLShaderHandle for: context.
	shader type: shaderType;
		generate;
		source: shaderSource withUnixLineEndings;
		compile.
	shader compileStatus ifFalse: [ 
		self error: shader infoLog
	].
	^ shader
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> drawElements: command [
	gl drawElements_mode: GL_TRIANGLES count: command indexCount type: GL_UNSIGNED_SHORT indices: (ExternalAddress fromAddress: command firstIndex * 2).
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> endRenderPass [
]

{ #category : #accessing }
FormSGOpenGLESDrawCommandProcessor >> fontTextureAtlasCache [
	^ fontTextureAtlasCache ifNil: [ fontTextureAtlasCache := FormSGFontTextureAtlasCache new ]
]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> gradientVertexShader [
	^ '
#version 100
attribute highp vec2 vPosition;
attribute highp vec2 vTexcoord;

uniform highp vec4 viewBoxTransform;
varying highp vec2 fTexcoord;

void main()
{ 
	fTexcoord = vTexcoord;
	gl_Position = vec4(vPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}
'
]

{ #category : #initialization }
FormSGOpenGLESDrawCommandProcessor >> initializeWithContext: aContext [
	context := aContext.
	gl := context gl.
	
	colorProgram := self programWithVertexShader: self vertexShader fragmentShader: self colorFragmentShader.
	texturedProgram := self programWithVertexShader: self vertexShader fragmentShader: self texturedFragmentShader.
	renderTargetComposeProgram := self programWithVertexShader: self renderTargetComposeVertexShader fragmentShader: self renderTargetComposeFragmentShader.
	radialGradientProgram := self programWithVertexShader: self gradientVertexShader fragmentShader: self radialGradientFragmentShader.
	linearGradientProgram := self programWithVertexShader: self gradientVertexShader fragmentShader: self linearGradientFragmentShader.
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> isSubpixelMask: factor [
	isSubpixelMask := factor.
	activeProgram ifNotNil: [
		activeProgram uniform: #isSubpixelMask float: isSubpixelMask
	]
]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> linearGradientFragmentShader [
	^ '
#version 100

varying highp vec2 fTexcoord;

uniform highp vec4 startColor;
uniform highp vec4 endColor;

uniform highp vec2 startPoint;
uniform highp vec2 endPoint;

void main()
{ 
	highp vec2 gradientVector = endPoint - startPoint;
	highp float alpha = dot(fTexcoord - startPoint, gradientVector) / max(dot(gradientVector, gradientVector), 0.000001);
	gl_FragData[0] = mix(startColor, endColor, alpha);
}

'
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> noTexture [
	self activateProgram: colorProgram.
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> processCommandListWithDependencies: mainCommandList mainFramebuffer: mainFramebuffer mainFramebufferExtent: mainFramebufferExtent [
	| sortedCommandList |
	sortedCommandList := FormSGOpenGLESCommandListSetBuilder new
		context: context;
		addCommandListWithDependencies: mainCommandList;
		sortedCommandLists.

	sortedCommandList do: [ :commandList |
		| passFramebuffer passExtent |
		commandList renderTargetCommandForRenderPass ifNotNil: [ :renderTargetCommand |
			passExtent := renderTargetCommand extent.
			passFramebuffer := context offscreenBufferExtent: passExtent hasColorBuffer: true isSRGB: context hasSRGB hasDepthBuffer: false hasStencilBuffer: false for: renderTargetCommand keyObject.
		] ifNil: [
			passExtent := mainFramebufferExtent.
			passFramebuffer := mainFramebuffer.
		].
	
		passFramebuffer
			ifNil: [gl bindFramebuffer_target: GL_FRAMEBUFFER framebuffer: 0]
			ifNotNil: [ passFramebuffer activate ].
		self
			beginRenderPassWithExtent: passExtent clearColor: Color transparent;
			processDrawCommandList: commandList;
			endRenderPass
	]
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> processDrawCommandList: commandList [
	self
		uploadVertices: commandList vertices;
		uploadIndices: commandList indices;
		activateVertexLayout.
		
	commandList drawCommands do: [ :each |
		each accept: self
	].

]

{ #category : #compiling }
FormSGOpenGLESDrawCommandProcessor >> programWithVertexShader: vertexSource fragmentShader: fragmentSource [
	^ self programWithVertexShader: vertexSource fragmentShader: fragmentSource vertexBindings: {
		#vPosition -> 0.
		#vColor -> 1.
		#vTexcoord -> 2.
	}
]

{ #category : #compiling }
FormSGOpenGLESDrawCommandProcessor >> programWithVertexShader: vertexSource fragmentShader: fragmentSource vertexBindings: vertexBindings [
	| vertexShader fragmentShader program |
	context asCurrentDo: [
		vertexShader := self compileShader: vertexSource type: GL_VERTEX_SHADER.
		fragmentShader := self compileShader: fragmentSource type: GL_FRAGMENT_SHADER.
		
		program := (UFFIOpenGLProgramHandle for: context) generate.
		vertexBindings do: [ :binding |
			program bindAttribute: binding key asString location: binding value
		].

		program
			attach: vertexShader;
			attach: fragmentShader.
	
		program link.
		program linkStatus ifFalse: [ 
			self error: program infoLog
		].
		
		^ program
	].

]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> radialGradientFragmentShader [
	^ '
#version 100

uniform highp vec4 startColor;
uniform highp vec4 endColor;

uniform highp vec2 centerPoint;
uniform highp vec2 focalPoint;
uniform highp vec4 radiuses;

varying highp vec2 fTexcoord;

void main()
{ 
	highp float radius = length(fTexcoord - centerPoint)	;
	if (radius < radius.x || radius > radiuses.w)
		discard;
		
	highp float alpha = clamp((radius - radiuses.y) / max(radiuses.z - radiuses.y, 0.00001), 0.0, 1.0);
	gl_FragData[0] = mix(startColor, endColor, alpha);
}

'
]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> renderTargetComposeFragmentShader [
	^ '
#version 100

uniform sampler2D activeTexture;
uniform highp float vertexColorInfluence;

varying highp vec4 fColor;
varying highp vec2 fTexcoord;

void main()
{ 
	highp vec4 textureColor = texture2D(activeTexture, fTexcoord).rgba;
	gl_FragData[0] = mix(textureColor, fColor * textureColor, vertexColorInfluence);
}

'
]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> renderTargetComposeVertexShader [
	context hasSRGB ifTrue: [ 
	^ '
#version 100
attribute highp vec2 vPosition;
attribute highp vec4 vColor;
attribute highp vec2 vTexcoord;

varying highp vec4 fColor;
varying highp vec2 fTexcoord;

uniform highp vec4 viewBoxTransform;

void main()
{ 
	fColor = vec4(pow(vColor.rgb, vec3(2.2)), vColor.a);
	fTexcoord = vTexcoord;
	gl_Position = vec4(vPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}

'
].

	^ '
#version 100
attribute highp vec2 vPosition;
attribute highp vec4 vColor;
attribute highp vec2 vTexcoord;

varying highp vec4 fColor;
varying highp vec2 fTexcoord;

uniform highp vec4 viewBoxTransform;

void main()
{ 
	fColor = vColor;
	fTexcoord = vTexcoord*vec2(1.0, -1.0) + vec2(0.0, 1.0);
	gl_Position = vec4(vPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}

'
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> setAthensSurfaceTextureWithModificationCount: command [
	| texture |
	texture := (context textureObjectWithModificationCountFor: command keyObject)
		uploadFromAthensSurface: command athensSurface withModificationCount: command modificationCount;
		yourself.

	self activateProgram: texturedProgram.
	gl bindTexture_target: GL_TEXTURE_2D texture: texture handle
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> setFormTexture: command [
	| texture |
	texture := context textureObjectFromForm: command form.
	self activateProgram: texturedProgram.
	gl bindTexture_target: GL_TEXTURE_2D texture: texture handle
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> setFormTextureWithModificationCount: command [
	| texture |
	texture := (context textureObjectWithModificationCountFor: command keyObject)
		uploadFromForm: command form withModificationCount: command modificationCount;
		yourself.

	self activateProgram: texturedProgram.
	gl bindTexture_target: GL_TEXTURE_2D texture: texture handle
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> setLinearGradientCommand: gradient [
	self activateProgram: linearGradientProgram.
	linearGradientProgram
		uniform: #startColor float: gradient startColor red float: gradient startColor green float: gradient startColor blue float: gradient startColor alpha;
		uniform: #endColor float: gradient endColor red float: gradient endColor green float: gradient endColor blue float: gradient endColor alpha;
		uniform: #startPoint float: gradient startPoint x asFloat float: gradient startPoint y asFloat;
		uniform: #endPoint float: gradient endPoint x asFloat float: gradient endPoint y asFloat

]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> setRadialGradientCommand: gradient [
	self activateProgram: radialGradientProgram.
	radialGradientProgram
		uniform: #startColor float: gradient startColor red float: gradient startColor green float: gradient startColor blue float: gradient startColor alpha;
		uniform: #endColor float: gradient endColor red float: gradient endColor green float: gradient endColor blue float: gradient endColor alpha;
		uniform: #centerPoint float: gradient center x asFloat float: gradient center y asFloat;
		uniform: #focalPoint float: gradient focalPoint x asFloat float: gradient focalPoint y asFloat;
		uniform: #radiuses float: gradient clipInnerRadius asFloat float: gradient innerRadius asFloat
			float: gradient outerRadius asFloat float: gradient clipOuterRadius asFloat
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> setRenderTargetWithModificationCount: renderTargetCommand [
	| fb |
	fb := context offscreenBufferExtent: renderTargetCommand extent hasColorBuffer: true isSRGB: context hasSRGB hasDepthBuffer: false hasStencilBuffer: false for: renderTargetCommand keyObject.

	self activateProgram: renderTargetComposeProgram.
	gl bindTexture_target: GL_TEXTURE_2D texture: fb colorTexture handle
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> setScissor: command [
	| viewClippedRectangle scissorMin scissorMax screenHeight |
	viewClippedRectangle := command rectangle intersect: viewportRectangle ifNone: [
		gl scissor_x: 0 y: 0 width: 0 height: 0.
		^ self
	].

	screenHeight := viewportRectangle height.
	scissorMin := viewClippedRectangle origin floor.
	scissorMax := viewClippedRectangle corner ceiling.
	gl scissor_x: scissorMin x y: screenHeight - scissorMax y width: scissorMax x - scissorMin x height: scissorMax y - scissorMin y.
]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> texturedFragmentShader [
	^ '
#version 100

uniform sampler2D activeTexture;
uniform highp float isSubpixelMask;

varying highp vec4 fColor;
varying highp vec2 fTexcoord;

void main()
{ 
	highp vec4 textureColor = texture2D(activeTexture, fTexcoord).bgra;
	highp vec4 color = fColor * textureColor;
	highp vec4 premultipliedColor = vec4(color.rgb*color.a, color.a);
	
	highp vec4 subpixelMaskColor = vec4(textureColor.rgb, max(textureColor.r, max(textureColor.g, textureColor.b)));
	
	gl_FragData[0] = mix(premultipliedColor, subpixelMaskColor, isSubpixelMask);
}

'
]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> texturedVertexShader [
	^ '
#version 100
attribute highp vec2 vPosition;
attribute highp vec4 vColor;
attribute highp vec2 vTexcoord;

varying highp vec4 fColor;
varying highp vec2 fTexcoord;

uniform highp vec4 viewBoxTransform;

void main()
{ 
	fColor = vColor;
	fTexcoord = vTexcoord;
	gl_Position = vec4(vPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}

'
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> uploadIndices: indices [
	| encodedIndices destOffset |
	encodedIndices := ByteArray new: indices size*2.
	destOffset := 0.
	indices do: [ :each |
		encodedIndices uint16AtOffset: destOffset put: each.
		destOffset := destOffset + 2
	].

	indexBuffer ifNil: [
		indexBuffer := (UFFIOpenGLBufferHandle for: context) generate
	].

	indexBuffer forTarget: GL_ELEMENT_ARRAY_BUFFER setData: encodedIndices withUsage: GL_STREAM_DRAW.
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> uploadModifiedTextureFontCachePages [
	self fontTextureAtlasCache modifiedPages do: [ :page |
		(context textureObjectWithModificationCountFor: page)
			uploadFromForm: page form withModificationCount: page modificationCount
	]
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> uploadVertices: vertices [
	| encodedVertices destOffset |
	encodedVertices := ByteArray new: vertices size*4.
	destOffset := 0.
	vertices do: [ :each |
		encodedVertices float32AtOffset: destOffset put: each.
		destOffset := destOffset + 4
	].

	vertexBuffer ifNil: [
		vertexBuffer := (UFFIOpenGLBufferHandle for: context) generate
	].

	vertexBuffer forTarget: GL_ARRAY_BUFFER setData: encodedVertices withUsage: GL_STREAM_DRAW.
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> useCompositeAlphaBlending [
	gl blendFuncSeparate_sfactorRGB: GL_ONE dfactorRGB: GL_ONE_MINUS_SRC_ALPHA sfactorAlpha: GL_ONE dfactorAlpha: GL_ONE_MINUS_SRC_ALPHA
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> useSubpixelFontFirstPassBlending [
	self isSubpixelMask: 1.0.
	gl blendFuncSeparate_sfactorRGB: GL_ZERO dfactorRGB: GL_ONE_MINUS_SRC_COLOR sfactorAlpha: GL_ONE dfactorAlpha: GL_ONE_MINUS_SRC_ALPHA
]

{ #category : #'as yet unclassified' }
FormSGOpenGLESDrawCommandProcessor >> useSubpixelFontSecondPassBlending [
	self isSubpixelMask: 0.0.
	gl blendFuncSeparate_sfactorRGB: GL_ONE dfactorRGB: GL_ONE sfactorAlpha: GL_ZERO dfactorAlpha: GL_ONE
]

{ #category : #shaders }
FormSGOpenGLESDrawCommandProcessor >> vertexShader [
	context hasSRGB ifTrue: [ 
	^ '
#version 100
attribute highp vec2 vPosition;
attribute highp vec4 vColor;
attribute highp vec2 vTexcoord;

varying highp vec4 fColor;
varying highp vec2 fTexcoord;

uniform highp vec4 viewBoxTransform;

void main()
{ 
	fColor = vec4(pow(vColor.rgb, vec3(2.2)), vColor.a);
	fTexcoord = vTexcoord;
	gl_Position = vec4(vPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}

'
].

	^ '
#version 100
attribute highp vec2 vPosition;
attribute highp vec4 vColor;
attribute highp vec2 vTexcoord;

varying highp vec4 fColor;
varying highp vec2 fTexcoord;

uniform highp vec4 viewBoxTransform;

void main()
{ 
	fColor = vColor;
	fTexcoord = vTexcoord;
	gl_Position = vec4(vPosition*viewBoxTransform.xy + viewBoxTransform.zw, 0.0, 1.0);
}

'
]
