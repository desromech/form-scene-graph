"
I am a wrapper on top of an scene graph node that connects with the OSWindowGenericRenderer interface.
"
Class {
	#name : #FormSGOSWindowGenericRendererScene,
	#superclass : #OSWindowGenericRendererScene,
	#instVars : [
		'rootNode',
		'fontTextureAtlasCache',
		'renderTarget',
		'renderTargetExtent',
		'surfaceScaleFactor'
	],
	#category : #'FormSceneGraph-RendererOSWindow'
}

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> composeRenderTargetInto: renderer [
	| fullBounds |
	fullBounds := 0@0 extent: renderTargetExtent.
	renderer
		clippingBounds: fullBounds;
		useNoBlending;
		color: Color white;
		drawTexture: renderTarget in: fullBounds;
		present
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> doRenderRectangle: rectangle with: renderer [
	renderer clippingBounds: rectangle.
	renderer
		color: Color transparent;
		useNoBlending;
		fillRectangle: rectangle.
	
	rootNode ifNotNil: [
		self fontTextureAtlasCache beginFrame.
		FormSGOSWindowGenericRendererTextPreparationVisitor new
			surfaceScaleFactor: self surfaceScaleFactor;
			fontTextureAtlasCache: fontTextureAtlasCache;
			renderer: renderer;
			visitNode: rootNode.
		self fontTextureAtlasCache modifiedPages do: [ :each |
			(renderer getOrCreateTextureFor: each withExtent: each form extent)
				uploadForm: each form withModificationCount: each modificationCount
		].

		FormSGOSWindowGenericRenderer new
			surfaceScaleFactor: self surfaceScaleFactor;
			fontTextureAtlasCache: fontTextureAtlasCache;
			render: rootNode with: renderer clippingBounds: rectangle.
	].

]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> fontTextureAtlasCache [
	^ fontTextureAtlasCache ifNil: [ fontTextureAtlasCache := FormSGFontTextureAtlasCache new ]
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> fontTextureAtlasCache: anObject [
	fontTextureAtlasCache := anObject
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> renderAllWith: renderer [
	self withRenderer: renderer drawInMainRenderTargetWith: [
		self doRenderRectangle: (0@0 extent: renderer pixelExtent) with: renderer
	].
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> renderRectangle: rectangle with: renderer [
	(self validateRenderTargetFor: renderer) ifFalse: [ ^ self renderAllWith: renderer ].

	renderer withRenderTarget: renderTarget do: [
		self doRenderRectangle: rectangle with: renderer.
	].

	self composeRenderTargetInto: renderer
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> rootNode [
	^ rootNode
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> rootNode: anObject [
	rootNode := anObject
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> surfaceScaleFactor [
	^ surfaceScaleFactor ifNil: [ surfaceScaleFactor := 1.0 ]
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> surfaceScaleFactor: aNumber [
	surfaceScaleFactor := aNumber
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> validateRenderTargetFor: renderer [
	"This optimization is not working yet."
	| requiredExtent |
	requiredExtent := renderer pixelExtent.
	(renderTarget notNil and: [ renderTargetExtent = requiredExtent ]) ifTrue: [ ^ true ].
	
	renderTarget := renderer createRenderTargetTextureWithExtent: requiredExtent.
	renderTargetExtent := requiredExtent.
	^ renderTarget notNil
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> withRenderer: renderer drawInMainRenderTargetWith: aBlock [
	(self validateRenderTargetFor: renderer) ifTrue: [
		renderer withRenderTarget: renderTarget do: aBlock.
		self composeRenderTargetInto: renderer
	] ifFalse: [
		aBlock value.
		renderer present
	]
]
