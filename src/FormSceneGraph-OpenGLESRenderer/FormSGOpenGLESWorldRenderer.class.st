"
I am a world renderer that uses OpenGL ES for rendering.
"
Class {
	#name : #FormSGOpenGLESWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#instVars : [
		'context',
		'drawCommandProcessor',
		'srgbFramebuffer'
	],
	#pools : [
		'UFFIOpenGLConstants'
	],
	#category : #'FormSceneGraph-OpenGLESRenderer'
}

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> context [
	^ context
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	osWindow ifNil: [ ^ self ].
	self context asCurrentDo: [
		| commandList |
		context hasSRGB ifTrue: [ 
			srgbFramebuffer ifNil: [
				srgbFramebuffer := context offscreenBufferExtent: self drawingSurfaceExtent hasColorBuffer: true isSRGB: true hasDepthBuffer: false hasStencilBuffer: false
			].
			srgbFramebuffer extent: self drawingSurfaceExtent
		].
	
		commandList := FormSGGPUCommandListBuilder new.
		FormSGGPUCommandListRenderer new
			surfaceScaleFactor: self scaleFactor;
			fontTextureAtlasCache: self drawCommandProcessor fontTextureAtlasCache;
			render: newSceneGraph with: commandList transform: FormSGAffineTransform identity clippingBounds: (0@0 extent: self drawingSurfaceExtent).
		
		self drawCommandProcessor
			processCommandListWithDependencies: commandList
				mainFramebuffer: srgbFramebuffer mainFramebufferExtent: self drawingSurfaceExtent.

		context swapBuffers: osWindow
	].
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> doActivate [

	| attributes initialExtent |
	
	initialExtent := world worldState realWindowExtent ifNil: [976@665].

	attributes := OSWindowAttributes new.
	attributes
		extent: initialExtent;
		title: Smalltalk image imageFile fullName;
		windowCentered:true;
		icon: (self iconNamed: #pharoBig);
		glAttributes: self glAttributes.

	display := Form extent: initialExtent depth: 32.
	world extent: initialExtent.

	driver := self pickMostSuitableWindowDriver.
	attributes preferableDriver: driver.
	osWindow := OSWindow createWithAttributes: attributes eventHandler: (OSWindowMorphicEventHandler for: world).
	context := UFFIOpenGLESContext newWithAttributes: attributes glAttributes forWindow: osWindow.
	self drawCommandProcessor.
	osWindow focus. 
	
	world worldState doFullRepaint.
	world displayWorld.
	
	OSWindowClipboard new beDefault.
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> drawCommandProcessor [
	^ drawCommandProcessor ifNil: [ drawCommandProcessor := FormSGOpenGLESDrawCommandProcessor for: self context ]
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> glAttributes [
	^ OSWindowGLAttributes new
		setForOpenGLES20;
		depthSize: 0;
		stencilSize: 0;
		srgbFramebuffer: false;
		yourself
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	^ osWindow renderer
	
]
