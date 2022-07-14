"
I am a world renderer that uses the AbstractGPU low level graphics API wrapper.
"
Class {
	#name : #FormSGAGPUWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#instVars : [
		'device',
		'drawCommandProcessor',
		'swapChain',
		'swapChainExtent',
		'isOutOfDate'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'FormSceneGraph-AbstractGPURendererMorphic'
}

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> device [
	^ device ifNil: [ device := AGPU mainDevice ]
]

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	| backBuffer mainRenderTarget sgCommandList |
	osWindow ifNil: [ ^ self ].
	self validateSwapChain ifFalse: [ ^ self ].

	backBuffer := swapChain getCurrentBackBuffer.
	mainRenderTarget := FormSGAGPURenderTarget new
		device: self device;
		framebuffer: backBuffer;
		extent: self drawingSurfaceExtent;
		renderpass: self drawCommandProcessor defaultRenderPass;
		yourself.

	sgCommandList := FormSGAGPUCommandListBuilder new.
	
	FormSGAGPUCommandListRenderer new
		surfaceScaleFactor: self scaleFactor;
		fontTextureAtlasCache: self drawCommandProcessor fontTextureAtlasCache;
		hasDirectSubpixelBlending: self drawCommandProcessor hasDirectSubpixelBlending;
		render: newSceneGraph with: sgCommandList transform: FormSGAffineTransform identity clippingBounds: (0@0 extent: self drawingSurfaceExtent).
	
	self drawCommandProcessor
		processCommandListWithDependencies: sgCommandList mainRenderTarget: mainRenderTarget thenCommitSurfaceWith: [ self swapBuffers ]
]

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> drawCommandProcessor [
	^ drawCommandProcessor ifNil: [ drawCommandProcessor := FormSGAGPUDrawCommandProcessor for: self device ]
]

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> drawingSurfaceExtent [
	(swapChain notNil and: [ swapChain isNull not ]) ifTrue: [ 
		^ swapChain getWidth @ swapChain getHeight
	].

	^ osWindow ifNil: [ 1@1 ] ifNotNil: [ osWindow extent ]
]

{ #category : #activation }
FormSGAGPUWorldRenderer >> initialize [
	super initialize.
	isOutOfDate := true.
]

{ #category : #testing }
FormSGAGPUWorldRenderer >> isAGPUWorldRenderer [
	^ true
]

{ #category : #'instance creation' }
FormSGAGPUWorldRenderer >> newBuilderWithExtent: extent [
	^ (FormSGAGPUBuilder extent: extent)
		device: self device;
		drawCommandProcessor: self drawCommandProcessor;
		yourself
]

{ #category : #initialization }
FormSGAGPUWorldRenderer >> osWindowRenderer [
	^ nil
]

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> swapBuffers [
	[ 
		swapChain swapBuffers
	] on: AGPUError do: [ :ex |
		| errorCode |
		errorCode := ex errorCode.
		(errorCode = AGPU_OUT_OF_DATE or: [ errorCode = AGPU_SUBOPTIMAL ]) ifTrue: [
			errorCode = AGPU_OUT_OF_DATE ifTrue: [ isOutOfDate := true].
		] ifFalse: [ 
			ex signal
		]
	]
]

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> validateSwapChain [
	| oldSwapChain requiredExtent swapChainInfo platformSpecificHandle |
	requiredExtent := self windowExtent.
	(swapChain notNil and: [ swapChainExtent = requiredExtent and: [isOutOfDate not]]) ifTrue: [ ^ true ].
	
	swapChainInfo := AGPUSwapChainCreateInfo new
		buffer_count: 2;
		colorbuffer_format: self drawCommandProcessor colorBufferFormat;
		width: requiredExtent x;
		height: requiredExtent y;
		flags: AGPU_SWAP_CHAIN_FLAG_APPLY_SCALE_FACTOR_FOR_HI_DPI;
		yourself.

	AGPU shouldUseVSync ifTrue: [ 
		swapChainInfo presentation_mode: AGPU_SWAP_CHAIN_PRESENTATION_MODE_FIFO
	] ifFalse: [ 
		swapChainInfo presentation_mode: AGPU_SWAP_CHAIN_PRESENTATION_MODE_MAILBOX.
		swapChainInfo fallback_presentation_mode: AGPU_SWAP_CHAIN_PRESENTATION_MODE_IMMEDIATE.
	].

	platformSpecificHandle := osWindow platformSpecificHandle.
	platformSpecificHandle window ifNotNil: [ :handle | swapChainInfo window: handle ].
	platformSpecificHandle surface ifNotNil: [ :handle | swapChainInfo surface: handle ].

	oldSwapChain := swapChain.
	oldSwapChain ifNotNil: [
		device finishExecution.
		swapChainInfo old_swap_chain: oldSwapChain handle
	].

	swapChain := device createSwapChain: device getDefaultCommandQueue swapChainInfo: swapChainInfo.
	swapChainExtent := requiredExtent.
	oldSwapChain ifNotNil: [ oldSwapChain release ].
	isOutOfDate := false.

	^ swapChain notNil
]
