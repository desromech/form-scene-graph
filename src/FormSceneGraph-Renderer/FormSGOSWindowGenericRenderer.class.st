"
I am a scene graph renderer that uses the OSWindow generic renderer API.
"
Class {
	#name : #FormSGOSWindowGenericRenderer,
	#superclass : #FormSGRenderer,
	#instVars : [
		'renderer',
		'currentTranslation',
		'currentClipRectangle',
		'currentScale',
		'fontTextureAtlasCache'
	],
	#category : #'FormSceneGraph-Renderer-Basic'
}

{ #category : #rendering }
FormSGOSWindowGenericRenderer class >> render: node with: renderer [
	^ self new render: node with: renderer
]

{ #category : #rendering }
FormSGOSWindowGenericRenderer class >> render: node with: renderer clippingBounds: clippingBounds [
	^ self new render: node with: renderer clippingBounds: clippingBounds
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> attemptRectangle: rectangle textureBlittingWithPrecision: texture extent: surfaceExtent [
	| attemptScaledPixelPerfectBlitting |
	attemptScaledPixelPerfectBlitting := currentScale closeTo: surfaceScaleFactor.
	renderer color: Color white.

	attemptScaledPixelPerfectBlitting ifTrue: [
		renderer drawTexture: texture in: ((self transformPosition: rectangle origin) rounded extent: surfaceExtent)
	] ifFalse: [ 
		renderer drawTexture: texture in: (self transformRectangle: rectangle)
	].
]

{ #category : #private }
FormSGOSWindowGenericRenderer >> blitFontPage: page glyphEntry: glyphEntry scaledGlyphEntry: scaledGlyphEntry destPosition: destPosition attemptScaledPixelPerfectBlitting: attemptScaledPixelPerfectBlitting [
	| glyphForm sourceRectangle destRectangle pageTexture |
	glyphForm := scaledGlyphEntry glyphForm.
	sourceRectangle := scaledGlyphEntry pixelRectangle.
	
	attemptScaledPixelPerfectBlitting ifTrue: [ 
		destRectangle := ((self transformPosition: destPosition) + glyphForm offset) rounded extent: glyphForm extent.
	] ifFalse: [ 
		destRectangle := self transformRectangle: ((destPosition + glyphEntry glyphForm offset) rounded extent: glyphEntry glyphForm extent).
	].

	pageTexture := (renderer getOrCreateTextureFor: page withExtent: page form extent)
		uploadForm: page form withModificationCount: page modificationCount;
		yourself.
	
	renderer drawTexture: pageTexture rectangle: sourceRectangle in: destRectangle

]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> drawTextNodeString: node font: font startPosition: startPosition [
	| scaledFont attemptScaledPixelPerfectBlitting hasSubpixelAntialiasing rectangle widthAndKernedWidth destPositionX destPositionY |
	scaledFont := font.
	(currentScale closeTo: 1.0) ifFalse: [
		scaledFont := scaledFont withSizeIncrementedBy: (scaledFont pointSize*currentScale) - scaledFont pointSize
	].
	attemptScaledPixelPerfectBlitting := scaledFont ~~ font and: [currentScale closeTo: surfaceScaleFactor ].
	hasSubpixelAntialiasing := false.

	rectangle := node rectangle.
	widthAndKernedWidth := Array new: 2.

	destPositionX := startPosition x.
	destPositionY := startPosition y.
	
	"First pass"
	renderer color: node color.

	fontTextureAtlasCache processString: node string from: node firstIndex to: node lastIndex font: font scaledFont: scaledFont subpixelAllowed: true entriesWith: [ :glyphEntry :scaledGlyphEntry :character :nextCharacter |
		scaledGlyphEntry page ifNotNil: [ :page |
			(hasSubpixelAntialiasing not and: [ scaledGlyphEntry hasSubpixelAntialiasing]) ifTrue: [
				renderer
					useSubpixelFontFirstPassBlending;
					color: Color white.
				hasSubpixelAntialiasing := true.
			].
		
			self blitFontPage: page glyphEntry: glyphEntry scaledGlyphEntry: scaledGlyphEntry destPosition: destPositionX@destPositionY attemptScaledPixelPerfectBlitting: attemptScaledPixelPerfectBlitting
		].

		font 
			widthAndKernedWidthOfLeft: character 
			right: nextCharacter
			into: widthAndKernedWidth.
			
		destPositionX := destPositionX + (widthAndKernedWidth at: 2)
	].

	"Second pass: "
	hasSubpixelAntialiasing ifFalse: [ ^ destPositionX @ destPositionY ].

	renderer
		color: node color;
		useSubpixelFontSecondPassBlending.

	destPositionX := startPosition x.
	destPositionY := startPosition y.

	fontTextureAtlasCache processString: node string from: node firstIndex to: node lastIndex font: font scaledFont: scaledFont subpixelAllowed: true entriesWith: [ :glyphEntry :scaledGlyphEntry :character :nextCharacter |
		scaledGlyphEntry page ifNotNil: [ :page |
			self blitFontPage: page glyphEntry: glyphEntry scaledGlyphEntry: scaledGlyphEntry destPosition: destPositionX@destPositionY attemptScaledPixelPerfectBlitting: attemptScaledPixelPerfectBlitting
		].

		font 
			widthAndKernedWidthOfLeft: character 
			right: nextCharacter
			into: widthAndKernedWidth.
			
		destPositionX := destPositionX + (widthAndKernedWidth at: 2)
	].

	renderer useCompositeAlphaBlending.
	^ destPositionX @ destPositionY
]

{ #category : #accessing }
FormSGOSWindowGenericRenderer >> fontTextureAtlasCache [
	^ fontTextureAtlasCache
]

{ #category : #accessing }
FormSGOSWindowGenericRenderer >> fontTextureAtlasCache: anObject [
	fontTextureAtlasCache := anObject
]

{ #category : #rendering }
FormSGOSWindowGenericRenderer >> render: node with: theRenderer [
	^ self render: node with: theRenderer clippingBounds: theRenderer fullClippingBounds
]

{ #category : #rendering }
FormSGOSWindowGenericRenderer >> render: node with: theRenderer clippingBounds: clippingBounds [
	self render: node with: theRenderer scaleFactor: 1.0 translation: 0@0 clippingBounds: clippingBounds
]

{ #category : #rendering }
FormSGOSWindowGenericRenderer >> render: node with: theRenderer scaleFactor: scaleFactor translation: translation clippingBounds: clippingBounds [
	renderer := theRenderer.
	renderer useCompositeAlphaBlending.

	currentScale := scaleFactor.
	currentTranslation := translation.
	currentClipRectangle := clippingBounds.
	renderer clippingBounds: clippingBounds.
	self visitNode: node.
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> renderCachedSubScene: node onRenderTarget: renderTarget [
	renderer withRenderTarget: renderTarget do: [
		| translation |
		renderer
			color: Color transparent;
			clear.
		
		translation := self transformVector: node rectangle origin negated.
		self class new
			surfaceScaleFactor: surfaceScaleFactor;
			fontTextureAtlasCache: fontTextureAtlasCache;
			render: node child with: renderer
			scaleFactor: currentScale translation: translation clippingBounds: (0@0 extent: renderTarget extent).
	].
	renderer
		clippingBounds: currentClipRectangle;
		useCompositeAlphaBlending
]

{ #category : #transformation }
FormSGOSWindowGenericRenderer >> transformPosition: aPosition [
	^ (currentScale * aPosition) + currentTranslation
]

{ #category : #transformation }
FormSGOSWindowGenericRenderer >> transformRectangle: rectangle [
	| bottomLeft bottomRight topLeft topRight |
	bottomLeft := (self transformPosition: rectangle bottomLeft) rounded.
	bottomRight := (self transformPosition: rectangle bottomRight) rounded.
	topLeft := (self transformPosition: rectangle topLeft) rounded.
	topRight := (self transformPosition: rectangle topRight) rounded.
	^ Rectangle encompassing: { bottomLeft . bottomRight . topLeft . topRight }
]

{ #category : #transformation }
FormSGOSWindowGenericRenderer >> transformVector: aVector [
	^ currentScale * aVector
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> validateCachedSubSceneRenderTarget: node extent: surfaceExtent [
	| renderTarget |
	renderTarget := renderer getOrCreateRenderTargetTextureFor: node withExtent: surfaceExtent.
	(renderTarget modificationCount isNotNil and: [ renderTarget modificationCount >= node modificationCount ]) ifTrue: [ ^ renderTarget ].

	self renderCachedSubScene: node onRenderTarget: renderTarget.
	renderTarget modificationCount: node modificationCount.
	
	^ renderTarget
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitAthensNode: node [
	| rectangle surface surfaceExtent texture |
	rectangle := node rectangle.
	(rectangle isNil or: [rectangle isEmpty]) ifTrue: [ ^ self ].

	surfaceExtent := (rectangle extent * surfaceScaleFactor) ceiling.
	(surfaceExtent x <= 1 or: [ surfaceExtent y <= 1 ]) ifTrue: [ ^ self ].
	
	surface := node validAthensCairoSurfaceWithExtent: surfaceExtent.
	surface ifNil: [ ^ self ].

	texture := (renderer getOrCreateTextureFor: node withExtent: surfaceExtent)
		uploadAthensSurface: surface withModificationCount: node modificationCount;
		yourself.

	self attemptRectangle: rectangle textureBlittingWithPrecision: texture extent: surfaceExtent.
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitBorderNode: node [
	node color isTransparent ifTrue: [ ^ self ].
	
	renderer color: node color.
	node borderRectanglesDo: [ :rect |
		renderer fillRectangle: (self transformRectangle: rect)
	].

]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitCachedSubScene: node [
	| rectangle surfaceExtent renderTarget |
	rectangle := node rectangle.
	rectangle ifNil: [ ^ self ].
	
	renderer supportsRenderTargets ifFalse: [ ^ self visitNode: node clipChildNode ].

	surfaceExtent := (rectangle extent * surfaceScaleFactor) ceiling.
	(surfaceExtent x <= 1 or: [ surfaceExtent y <= 1 ]) ifTrue: [ ^ self ].
	
	renderTarget := self validateCachedSubSceneRenderTarget: node extent: surfaceExtent.
	renderTarget ifNil: [ ^ self visitNode: node clipChildNode ].

	renderer usePremultipliedCompositeAlphaBlending.
	self attemptRectangle: rectangle textureBlittingWithPrecision: renderTarget extent: surfaceExtent.
	renderer useCompositeAlphaBlending.

]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitClipNode: node [
	| convertedClipRectangle oldClipRectangle |
	convertedClipRectangle := self transformRectangle: node rectangle.
	convertedClipRectangle := currentClipRectangle intersect: convertedClipRectangle ifNone: [ ^ self ].

	oldClipRectangle := currentClipRectangle.
	currentClipRectangle := convertedClipRectangle.
	renderer clippingBounds: currentClipRectangle.
	[
		self visitNode: node child
	] ensure: [
		currentClipRectangle := oldClipRectangle.
		renderer clippingBounds: currentClipRectangle.
	].

]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitColorNode: node [
	node color isTransparent ifTrue: [ ^ self ].
	renderer color: node color;
		fillRectangle: (self transformRectangle: node rectangle)
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitContainerNode: node [
	self visitNodes: node children
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitNullNode: node [
	"Nothing required"
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitTextNode: node [
	| convertedRectangle font rectangle startPosition destPosition |
	fontTextureAtlasCache ifNil: [ ^ self ].
	font := node font.
	font ifNil: [ ^ self ].

	convertedRectangle := self transformRectangle: node rectangle.
	(currentClipRectangle intersects: convertedRectangle) ifFalse: [ ^ self ].

	rectangle := node rectangle.
	startPosition := (rectangle left + node kern) @ (rectangle top + font ascent).	
	destPosition := self drawTextNodeString: node font: font startPosition: startPosition.
	
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitTextureNode: node [
	| texture convertedRectangle sourceRectangle sourceExtent rectangle textureRectangle |
	node form ifNil: [ ^ self ].
	rectangle := node rectangle.
	
	convertedRectangle := self transformRectangle: rectangle.
	(currentClipRectangle intersects: convertedRectangle) ifFalse: [ ^ self ].

	texture := renderer getOrCreateStaticTextureFromForm: node form.
	texture ifNil: [ ^ self ].

	sourceRectangle := node validSourceRectangle.
	sourceExtent := sourceRectangle extent.
	(sourceExtent x <= 0.0 or: [ sourceExtent y <= 0.0 ]) ifTrue: [ ^ self ].
	
	textureRectangle := node isRepeated
		ifTrue: [ sourceRectangle origin extent: rectangle extent / sourceExtent ]
		ifFalse: [ sourceRectangle ].

	renderer color: Color white;
		drawTexture: texture rectangle: textureRectangle in: convertedRectangle
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitTransformNode: node [
	node transform isTranslationAndPositiveScaleOnly ifTrue: [ 
		^ self withScale: node transform positiveScale andTranslation: node transform translation do: [ 
			self visitNode: node child
		]
	].

	self flag: 'TODO: Implement this properly'.
	self visitNode: node child
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitTranslationNode: node [
	^ self withTranslation: node translation do: [ 
		self visitNode: node child
	].
]

{ #category : #private }
FormSGOSWindowGenericRenderer >> withScale: newScale andTranslation: newTranslation do: aBlock [
	| oldTranslation oldScale |
	oldScale := currentScale.
	oldTranslation := currentTranslation.

	currentScale := currentScale*newScale.
	currentTranslation := currentTranslation + (newTranslation*oldScale).
	aBlock ensure: [
		currentTranslation := oldTranslation.
		currentScale := oldScale.
	].
]

{ #category : #private }
FormSGOSWindowGenericRenderer >> withTranslation: newTranslation do: aBlock [
	| oldTranslation |
	oldTranslation := currentTranslation.
	currentTranslation := currentTranslation + (self transformVector: newTranslation).
	aBlock ensure: [ currentTranslation := oldTranslation ].
]
