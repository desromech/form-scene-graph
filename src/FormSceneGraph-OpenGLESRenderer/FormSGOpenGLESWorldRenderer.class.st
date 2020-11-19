"
I am a world renderer that uses OpenGL ES for rendering.
"
Class {
	#name : #FormSGOpenGLESWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#instVars : [
		'context',
		'drawCommandProcessor',
		'fontTextureAtlasCache',
		'srgbFramebuffer'
	],
	#pools : [
		'UFFIOpenGLConstants'
	],
	#category : #'FormSceneGraph-OpenGLESRenderer'
}

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> context [
	^ context ifNil: [ context := UFFIOpenGLESContext globalContext ]
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	osWindow ifNil: [ ^ self ].
	self context withWindow: osWindow do: [
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
			uploadModifiedTextureFontCachePages;
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
		glAttributes: self context glAttributes.

	display := Form extent: initialExtent depth: 32.
	world extent: initialExtent.

	driver := self pickMostSuitableWindowDriver.
	attributes preferableDriver: driver.
	osWindow := OSWindow createWithAttributes: attributes eventHandler: (OSWindowMorphicEventHandler for: world).
	
	osWindow focus. 
	
	world worldState doFullRepaint.
	world displayWorld.
	
	OSWindowClipboard new beDefault.
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> drawCommandProcessor [
	^ drawCommandProcessor ifNil: [ drawCommandProcessor := FormSGOpenGLESDrawCommandProcessor for: self context ]
]

{ #category : #accessing }
FormSGOpenGLESWorldRenderer >> fontTextureAtlasCache [
	^ fontTextureAtlasCache
]

{ #category : #accessing }
FormSGOpenGLESWorldRenderer >> fontTextureAtlasCache: anObject [
	fontTextureAtlasCache := anObject
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	^ nil
	
]
