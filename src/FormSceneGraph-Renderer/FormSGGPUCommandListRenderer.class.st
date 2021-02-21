"
I am a GPU based renderer that builds buffers and command lists for GPU based renderers.
"
Class {
	#name : #FormSGGPUCommandListRenderer,
	#superclass : #FormSGRenderer,
	#instVars : [
		'currentTransform',
		'currentClipRectangle',
		'commandList',
		'fontTextureAtlasCache',
		'hasDirectSubpixelBlending'
	],
	#category : #'FormSceneGraph-Renderer-GPU'
}

{ #category : #testing }
FormSGGPUCommandListRenderer class >> isAbstract [
	^ self == FormSGGPUCommandListRenderer
]

{ #category : #rendering }
FormSGGPUCommandListRenderer class >> render: sceneNode with: commandListBuilder [
	^ self new render: sceneNode with: commandListBuilder
]

{ #category : #rendering }
FormSGGPUCommandListRenderer class >> render: sceneNode with: commandListBuilder transform: initialTransform clippingBounds: initialClippingBounds [
	^ self new render: sceneNode with: commandListBuilder transform: initialTransform clippingBounds: initialClippingBounds
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> attemptRectangleBlittingWithPrecision: rectangle extent: surfaceExtent [
	commandList
		beginTriangles;
		color: Color white.
			
	self shouldAttemptScaledPixelPerfectBlitting ifTrue: [
		| blitRectangle |
		blitRectangle := (currentTransform transformPoint: rectangle origin) rounded extent: surfaceExtent.
		commandList
			vertexPosition: blitRectangle bottomLeft texcoord: 0.0@1.0;
			vertexPosition: blitRectangle bottomRight texcoord: 1.0@1.0;
			vertexPosition: blitRectangle topRight texcoord: 1.0@0.0;
			vertexPosition: blitRectangle topLeft texcoord: 0.0@0.0
	] ifFalse: [ 
		commandList
			vertexPosition: (currentTransform transformPoint: rectangle bottomLeft) texcoord: 0.0@1.0;
			vertexPosition: (currentTransform transformPoint: rectangle bottomRight) texcoord: 1.0@1.0;
			vertexPosition: (currentTransform transformPoint: rectangle topRight) texcoord: 1.0@0.0;
			vertexPosition: (currentTransform transformPoint: rectangle topLeft) texcoord: 0.0@0.0
	].

	commandList
		addIndices: #(
			0 1 2
			2 3 0
		);
		endSubmesh
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> drawRectangle: rectangle color: color [
	color isTransparent ifTrue: [ ^ self ].
	
	commandList
		noTexture;
		beginTriangles;
		color: color;
		vertexPosition: (currentTransform transformPoint: rectangle bottomLeft);
		vertexPosition: (currentTransform transformPoint: rectangle bottomRight);
		vertexPosition: (currentTransform transformPoint: rectangle topRight);
		vertexPosition: (currentTransform transformPoint: rectangle topLeft);
		addIndices: #(
			0 1 2
			2 3 0
		);
		endSubmesh
]

{ #category : #accessing }
FormSGGPUCommandListRenderer >> fontTextureAtlasCache [
	^ fontTextureAtlasCache
]

{ #category : #accessing }
FormSGGPUCommandListRenderer >> fontTextureAtlasCache: anObject [
	fontTextureAtlasCache := anObject
]

{ #category : #accessing }
FormSGGPUCommandListRenderer >> hasDirectSubpixelBlending [
	^ hasDirectSubpixelBlending
]

{ #category : #accessing }
FormSGGPUCommandListRenderer >> hasDirectSubpixelBlending: anObject [
	hasDirectSubpixelBlending := anObject
]

{ #category : #initialization }
FormSGGPUCommandListRenderer >> initialize [
	super initialize.
	currentTransform := FormSGAffineTransform identity.
	currentClipRectangle := Rectangle fullSpace.
	hasDirectSubpixelBlending := false.
]

{ #category : #rendering }
FormSGGPUCommandListRenderer >> render: sceneNode with: theCommandListBuilder [
	commandList := theCommandListBuilder.
	commandList setScissor: currentClipRectangle.
	self visitNode: sceneNode
]

{ #category : #rendering }
FormSGGPUCommandListRenderer >> render: sceneNode with: theCommandListBuilder transform: initialTransform clippingBounds: initialClippingBounds [
	currentTransform := initialTransform.
	currentClipRectangle := initialClippingBounds.
	self render: sceneNode with: theCommandListBuilder
]

{ #category : #asserting }
FormSGGPUCommandListRenderer >> shouldAttemptScaledPixelPerfectBlitting [
	^ currentTransform hasNoRotationAndScale: surfaceScaleFactor
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> validateCachedSubSceneRenderTarget: node extent: extent [
	commandList setRenderTargetTextureWithExtent: extent for: node withModificationCount: node modificationCount renderedWith: [:subsceneCommandList |
		| translation |
		translation := node rectangle origin negated rounded.
		self shouldAttemptScaledPixelPerfectBlitting ifTrue: [
			translation := translation rounded
		].
		
		self class new
			fontTextureAtlasCache: fontTextureAtlasCache;
			surfaceScaleFactor: surfaceScaleFactor;
			hasDirectSubpixelBlending: hasDirectSubpixelBlending;
			render: node clipChildNode
				with: subsceneCommandList
				transform: (FormSGAffineTransform scale: surfaceScaleFactor) * (FormSGAffineTransform translation: translation)
				clippingBounds: (0@0 extent: extent).
	].
	^ true
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitAthensNode: node [
	| rectangle surface surfaceExtent |
	rectangle := node rectangle.
	(rectangle isNil or: [rectangle isEmpty]) ifTrue: [ ^ self ].

	surfaceExtent := (rectangle extent * surfaceScaleFactor) ceiling.
	(surfaceExtent x <= 1 or: [ surfaceExtent y <= 1 ]) ifTrue: [ ^ self ].
	
	surface := node validAthensCairoSurfaceWithExtent: surfaceExtent.
	surface ifNil: [ ^ self ].

	commandList
		setAthensSurfaceTexture: surface for: node withModificationCount: node modificationCount.
	
	self attemptRectangleBlittingWithPrecision: rectangle extent: surfaceExtent
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitBorderNode: node [
	| rectangle interiorRectangle |
	node color isTransparent ifTrue: [ ^ self ].
	
	rectangle := node rectangle.
	interiorRectangle := node interiorRectangle.

	commandList
		noTexture;
		beginTriangles;
		color: node color;
		"0" vertexPosition: (currentTransform transformPoint: rectangle bottomLeft);
		"1" vertexPosition: (currentTransform transformPoint: rectangle bottomRight);
		"2" vertexPosition: (currentTransform transformPoint: rectangle topRight);
		"3" vertexPosition: (currentTransform transformPoint: rectangle topLeft);

		"4" vertexPosition: (currentTransform transformPoint: interiorRectangle bottomLeft);
		"5" vertexPosition: (currentTransform transformPoint: interiorRectangle bottomRight);
		"6" vertexPosition: (currentTransform transformPoint: interiorRectangle topRight);
		"7" vertexPosition: (currentTransform transformPoint: interiorRectangle topLeft);

		addIndices: #(
			"Bottom"
			0 1 5
			5 4 0

			"Right"
			1 2 6
			6 5 1

			"Top"
			2 3 7
			7 6 2

			"Left"
			3 0 4
			4 7 3
		);
		endSubmesh
		
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitCachedSubScene: node [
	| rectangle surfaceExtent |
	rectangle := node rectangle.
	(rectangle isNil or: [rectangle isEmpty]) ifTrue: [ ^ self ].

	surfaceExtent := (rectangle extent * surfaceScaleFactor) ceiling.
	(surfaceExtent x <= 1 or: [ surfaceExtent y <= 1 ]) ifTrue: [ ^ self ].

	(self validateCachedSubSceneRenderTarget: node extent: surfaceExtent) ifFalse: [ ^ self ].
	self attemptRectangleBlittingWithPrecision: rectangle extent: surfaceExtent
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitClipNode: node [
	| convertedClipRectangle oldClipRectangle |
	convertedClipRectangle := currentTransform transformRectangle: node rectangle.
	convertedClipRectangle := currentClipRectangle intersect: convertedClipRectangle ifNone: [ ^ self ].

	oldClipRectangle := currentClipRectangle.
	currentClipRectangle := convertedClipRectangle.
	commandList setScissor: currentClipRectangle.
	[
		self visitNode: node child
	] ensure: [
		currentClipRectangle := oldClipRectangle.
		commandList setScissor: currentClipRectangle.
	].

]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitColorNode: node [
	self drawRectangle: node rectangle color: node color
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitContainerNode: node [
	self visitNodes: node children
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitLinearGradientNode: node [
	| rectangle |
	(node startColor isTransparent and: [ node endColor isTransparent ]) ifTrue: [ ^ self ].
			
	rectangle := node rectangle.
	commandList
		setLinearGradiantStartPoint: node startPoint color: node startColor endPoint: node endPoint color: node endColor;
		beginTriangles;
		color: Color white;
		vertexPosition: (currentTransform transformPoint: rectangle bottomLeft) texcoord: rectangle bottomLeft;
		vertexPosition: (currentTransform transformPoint: rectangle bottomRight) texcoord: rectangle bottomRight;
		vertexPosition: (currentTransform transformPoint: rectangle topRight) texcoord: rectangle topRight;
		vertexPosition: (currentTransform transformPoint: rectangle topLeft) texcoord: rectangle topLeft;
		addIndices: #(
			0 1 2
			2 3 0
		);
		endSubmesh
	
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitNullNode: node [
	"Nothing is required here."
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitRadialGradientNode: node [
	| rectangle |
	(node startColor isTransparent and: [ node endColor isTransparent ]) ifTrue: [ ^ self ].
			
	rectangle := node rectangle.
	commandList
		setRadialGradiantCenter: node center focalPoint: node focalPoint
			clipInnerRadius: node clipInnerRadius innerRadius: node innerRadius
			outerRadius: node outerRadius clipOuterRadius: node outerRadius
			startColor: node startColor endColor: node endColor;
		beginTriangles;
		color: Color white;
		vertexPosition: (currentTransform transformPoint: rectangle bottomLeft) texcoord: rectangle bottomLeft;
		vertexPosition: (currentTransform transformPoint: rectangle bottomRight) texcoord: rectangle bottomRight;
		vertexPosition: (currentTransform transformPoint: rectangle topRight) texcoord: rectangle topRight;
		vertexPosition: (currentTransform transformPoint: rectangle topLeft) texcoord: rectangle topLeft;
		addIndices: #(
			0 1 2
			2 3 0
		);
		endSubmesh
	
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitTextNode: node [
	| scaledFont font rectangle convertedRectangle startPositionX startPositionY widthAndKernedWidth destPositionX destPositionY hasSubpixelAntialiasing stringCommandStartRecording stringCommandEndRecording attemptScaledPixelPerfectBlitting |
	node color isTransparent ifTrue: [ ^ self ].

	font := node font.
	font ifNil: [ ^ self ].

	fontTextureAtlasCache ifNil: [ ^ self ].

	rectangle := node rectangle.
	convertedRectangle := currentTransform transformRectangle: node rectangle.
	(currentClipRectangle intersects: convertedRectangle) ifFalse: [ ^ self ].

	startPositionX := rectangle left + node kern.
	startPositionY := rectangle top + font ascent.
	
	widthAndKernedWidth := Array new: 2.

	destPositionX := startPositionX.
	destPositionY := startPositionY.

	commandList
		color: node color.

	scaledFont := font.
	attemptScaledPixelPerfectBlitting := self shouldAttemptScaledPixelPerfectBlitting.
	(surfaceScaleFactor closeTo: 1.0) ifFalse: [
		scaledFont := scaledFont withSizeIncrementedBy: (scaledFont pointSize*surfaceScaleFactor) - scaledFont pointSize.
		attemptScaledPixelPerfectBlitting := attemptScaledPixelPerfectBlitting and: [scaledFont ~~ font] .
	].

	hasSubpixelAntialiasing := false.
	fontTextureAtlasCache processString: node string from: node firstIndex to: node lastIndex font: font scaledFont: scaledFont subpixelAllowed: true entriesWith: [ :glyphEntry :scaledGlyphEntry :character :nextCharacter |
		scaledGlyphEntry page ifNotNil: [ :page |
			| glyphForm sourceRectangle destRectangle |
			(hasSubpixelAntialiasing not and: [ scaledGlyphEntry hasSubpixelAntialiasing]) ifTrue: [
				
				hasDirectSubpixelBlending ifTrue: [ 
					commandList useSubpixelDualOutputBlending.
				] ifFalse: [ 
					commandList useSubpixelFontFirstPassBlending.
					stringCommandStartRecording := commandList beginCommandRecording.
				].
				hasSubpixelAntialiasing := true.
			].
		
			glyphForm := scaledGlyphEntry glyphForm.
			sourceRectangle := scaledGlyphEntry rectangle.
			
			attemptScaledPixelPerfectBlitting ifTrue: [ 
				destRectangle := ((currentTransform transformPoint: destPositionX@destPositionY) + glyphForm offset) rounded extent: glyphForm extent.
				commandList
					setFormTexture: page form for: page withModificationCount: page modificationCount isLinearTexture: true;
					beginTriangles;
					vertexPosition: destRectangle bottomLeft texcoord: sourceRectangle bottomLeft;
					vertexPosition: destRectangle bottomRight texcoord: sourceRectangle bottomRight;
					vertexPosition: destRectangle topRight texcoord: sourceRectangle topRight;
					vertexPosition: destRectangle topLeft texcoord: sourceRectangle topLeft;
					addIndices: #(
						0 1 2
						2 3 0
					);
					endSubmesh
			] ifFalse: [ 
				destRectangle := ((destPositionX@destPositionY) + glyphEntry glyphForm offset) rounded extent: glyphEntry glyphForm extent.
				commandList
					setFormTexture: page form for: page withModificationCount: page modificationCount isLinearTexture: true;
					beginTriangles;
					vertexPosition: (currentTransform transformPoint: destRectangle bottomLeft) texcoord: sourceRectangle bottomLeft;
					vertexPosition: (currentTransform transformPoint: destRectangle bottomRight) texcoord: sourceRectangle bottomRight;
					vertexPosition: (currentTransform transformPoint: destRectangle topRight) texcoord: sourceRectangle topRight;
					vertexPosition: (currentTransform transformPoint: destRectangle topLeft) texcoord: sourceRectangle topLeft;
					addIndices: #(
						0 1 2
						2 3 0
					);
					endSubmesh
			].
		].

		font 
			widthAndKernedWidthOfLeft: character 
			right: nextCharacter
			into: widthAndKernedWidth.
			
		destPositionX := destPositionX + (widthAndKernedWidth at: 2)
	].

	hasSubpixelAntialiasing ifTrue: [ 
		hasDirectSubpixelBlending ifFalse: [ 
			stringCommandEndRecording := commandList endCommandRecording.
			commandList
				useSubpixelFontSecondPassBlending;
				replayCommandsFrom: stringCommandStartRecording to: stringCommandEndRecording.
		].
		commandList useCompositeAlphaBlending
	].

	node underline ifTrue: [
		| underlineThickness underlineTop |
	 	underlineThickness := font underlineThickness asFloat.
		underlineTop := font underlineTop asFloat.
		self drawRectangle:
			(startPositionX @ (startPositionY + underlineTop) corner: destPositionX @ (destPositionY + underlineTop + underlineThickness))
			color: node underlineColor
	].

	node strikethrough ifTrue: [ 
		| strikeoutThickness strikeoutTop |
	 	strikeoutThickness := font strikeoutThickness asFloat.
		strikeoutTop := font strikeoutTop asFloat.
		self drawRectangle:
			(startPositionX @ (startPositionY + strikeoutTop) corner: destPositionX @ (destPositionY + strikeoutTop + strikeoutThickness))
			color: node underlineColor
	].

]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitTextureNode: node [
	| sourceRectangle rectangle extent sourceExtent texcoordScale textureRectangle |
	node form ifNil: [ ^ self ].

	rectangle := node rectangle.
	extent := rectangle extent.
	(extent x <= 0.0 or: [ extent y <= 0.0 ]) ifTrue: [ ^ self ].
		
	sourceRectangle := node validSourceRectangle.
	sourceExtent := sourceRectangle extent.
	(sourceExtent x <= 0.0 or: [ sourceExtent y <= 0.0 ]) ifTrue: [ ^ self ].
	
	texcoordScale := (1.0@1.0) / node form extent.

	textureRectangle := node isRepeated
		ifTrue: [ sourceRectangle origin extent: rectangle extent / sourceExtent ]
		ifFalse: [ sourceRectangle origin*texcoordScale corner: sourceRectangle corner*texcoordScale ].
	
	node isFullyOpaque ifTrue: [ 
		commandList useFullyOpaqueBlending
	].

	commandList
		setFormTexture: node form;
		beginTriangles;
		color: Color white;
		vertexPosition: (currentTransform transformPoint: rectangle bottomLeft) texcoord: textureRectangle bottomLeft;
		vertexPosition: (currentTransform transformPoint: rectangle bottomRight) texcoord: textureRectangle bottomRight;
		vertexPosition: (currentTransform transformPoint: rectangle topRight) texcoord: textureRectangle topRight;
		vertexPosition: (currentTransform transformPoint: rectangle topLeft) texcoord: textureRectangle topLeft;
		addIndices: #(
			0 1 2
			2 3 0
		);
		endSubmesh.
		
	node isFullyOpaque ifTrue: [ 
		commandList useCompositeAlphaBlending
	].

]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitTransformNode: node [
	| oldTransform |
	(node transform determinant closeTo: 0) ifTrue: [ ^ self ].
	oldTransform := currentTransform.
	currentTransform := currentTransform transformTransform: node transform.
	[ 
		self visitNode: node child
	] ensure: [
		currentTransform := oldTransform
	]
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitTranslationNode: node [
	| oldTransform |
	oldTransform := currentTransform.
	currentTransform := currentTransform transformTransform: (FormSGAffineTransform translation: node translation).
	[ 
		self visitNode: node child
	] ensure: [
		currentTransform := oldTransform
	]

]
