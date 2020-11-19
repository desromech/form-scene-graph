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
		'fontTextureAtlasCache'
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

{ #category : #accessing }
FormSGGPUCommandListRenderer >> fontTextureAtlasCache [
	^ fontTextureAtlasCache
]

{ #category : #accessing }
FormSGGPUCommandListRenderer >> fontTextureAtlasCache: anObject [
	fontTextureAtlasCache := anObject
]

{ #category : #initialization }
FormSGGPUCommandListRenderer >> initialize [
	super initialize.
	currentTransform := FormSGAffineTransform identity.
	currentClipRectangle := Rectangle fullSpace.
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
	| rectangle |
	node color isTransparent ifTrue: [ ^ self ].
	
	rectangle := node rectangle.
	
	commandList
		noTexture;
		beginTriangles;
		color: node color;
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

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitContainerNode: node [
	self visitNodes: node children
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitNullNode: node [
	"Nothing is required here."
]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitTextNode: node [
	| scaledFont font rectangle convertedRectangle startPositionX startPositionY widthAndKernedWidth destPositionX destPositionY hasSubpixelAntialiasing stringCommandStartRecording stringCommandEndRecording |
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
	(surfaceScaleFactor closeTo: 1.0) ifFalse: [
		scaledFont := scaledFont withSizeIncrementedBy: (scaledFont pointSize*surfaceScaleFactor) - scaledFont pointSize
	].

	hasSubpixelAntialiasing := false.
	fontTextureAtlasCache processString: node string from: node firstIndex to: node lastIndex font: scaledFont subpixelAllowed: true entriesWith: [ :glyphEntry :character :nextCharacter |
		glyphEntry page ifNotNil: [ :page |
			| glyphForm sourceRectangle destRectangle |
			(hasSubpixelAntialiasing not and: [ glyphEntry hasSubpixelAntialiasing]) ifTrue: [
				commandList useSubpixelFontFirstPassBlending.
				stringCommandStartRecording := commandList beginCommandRecording.
				hasSubpixelAntialiasing := true.
			].
		
			glyphForm := glyphEntry glyphForm.
			sourceRectangle := glyphEntry rectangle.
			destRectangle := (destPositionX@destPositionY) + glyphForm offset extent: glyphForm extent.
			commandList
				setFormTexture: page form withModificationCount: page modificationCount;
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

		font 
			widthAndKernedWidthOfLeft: character 
			right: nextCharacter
			into: widthAndKernedWidth.
			
		destPositionX := destPositionX + (widthAndKernedWidth at: 2)
	].

	hasSubpixelAntialiasing ifTrue: [ 
		stringCommandEndRecording := commandList endCommandRecording.
		commandList
			useSubpixelFontSecondPassBlending;
			replayCommandsFrom: stringCommandStartRecording to: stringCommandEndRecording;
			useCompositeAlphaBlending
	]

]

{ #category : #visiting }
FormSGGPUCommandListRenderer >> visitTextureNode: node [
	| sourceRectangle rectangle extent sourceExtent texcoordScale |
	node form ifNil: [ ^ self ].

	rectangle := node rectangle.
	extent := rectangle extent.
	(extent x <= 0.0 or: [ extent y <= 0.0 ]) ifTrue: [ ^ self ].
		
	sourceRectangle := node validSourceRectangle.
	sourceExtent := sourceRectangle extent.
	(sourceExtent x <= 0.0 or: [ sourceExtent y <= 0.0 ]) ifTrue: [ ^ self ].
	
	texcoordScale := (1.0@1.0) / node form extent.
	
	commandList
		setFormTexture: node form;
		beginTriangles;
		color: Color white;
		vertexPosition: (currentTransform transformPoint: rectangle bottomLeft) texcoord: sourceRectangle bottomLeft*texcoordScale;
		vertexPosition: (currentTransform transformPoint: rectangle bottomRight) texcoord: sourceRectangle bottomRight*texcoordScale;
		vertexPosition: (currentTransform transformPoint: rectangle topRight) texcoord: sourceRectangle topRight*texcoordScale;
		vertexPosition: (currentTransform transformPoint: rectangle topLeft) texcoord: sourceRectangle topLeft*texcoordScale;
		addIndices: #(
			0 1 2
			2 3 0
		);
		endSubmesh
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
