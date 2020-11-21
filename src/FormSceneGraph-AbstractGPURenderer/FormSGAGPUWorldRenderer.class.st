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
		'swapChainExtent'
	],
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> device [
	^ device ifNil: [
		| platform deviceOpenInfo |
		platform := AGPU firstPlatform.
		deviceOpenInfo := AGPUDeviceOpenInfo new debug_layer: 1.
		device := platform openDevice: deviceOpenInfo.
	]
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
		extent: swapChainExtent;
		renderpass: self drawCommandProcessor defaultRenderPass;
		yourself.

	sgCommandList := FormSGGPUCommandListBuilder new.
	
	FormSGGPUCommandListRenderer new
		surfaceScaleFactor: self scaleFactor;
		fontTextureAtlasCache: self drawCommandProcessor fontTextureAtlasCache;
		hasDirectSubpixelBlending: true;
		render: newSceneGraph with: sgCommandList transform: FormSGAffineTransform identity clippingBounds: (0@0 extent: self drawingSurfaceExtent).
	
	self drawCommandProcessor
		processCommandListWithDependencies: sgCommandList mainRenderTarget: mainRenderTarget.

	swapChain swapBuffers
]

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> drawCommandProcessor [
	^ drawCommandProcessor ifNil: [ drawCommandProcessor := FormSGAGPUDrawCommandProcessor for: self device ]
]

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> drawingSurfaceExtent [
	^ osWindow ifNil: [ 1@1 ] ifNotNil: [ osWindow extent ]
]

{ #category : #initialization }
FormSGAGPUWorldRenderer >> osWindowRenderer [
	^ nil
]

{ #category : #'scale factor' }
FormSGAGPUWorldRenderer >> validateSwapChain [
	| oldSwapChain requiredExtent swapChainInfo platformSpecificHandle |
	requiredExtent := self drawingSurfaceExtent.
	(swapChain isNotNil and: [ swapChainExtent = requiredExtent ]) ifTrue: [ ^ true ].
	
	swapChainInfo := AGPUSwapChainCreateInfo new
		buffer_count: 2;
		colorbuffer_format: self drawCommandProcessor colorBufferFormat;
		width: requiredExtent x;
		height: requiredExtent y;
		yourself.

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

	^ swapChain isNotNil
]
