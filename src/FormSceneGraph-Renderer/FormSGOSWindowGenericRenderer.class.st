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
		'currentScale'
	],
	#category : #'FormSceneGraph-Renderer'
}

{ #category : #rendering }
FormSGOSWindowGenericRenderer class >> render: node with: renderer [
	^ self new render: node with: renderer
]

{ #category : #rendering }
FormSGOSWindowGenericRenderer class >> render: node with: renderer clippingBounds: clippingBounds [
	^ self new render: node with: renderer clippingBounds: clippingBounds
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

{ #category : #transformation }
FormSGOSWindowGenericRenderer >> transformPosition: aPosition [
	^ (currentScale * aPosition) + currentTranslation
]

{ #category : #transformation }
FormSGOSWindowGenericRenderer >> transformRectangle: rectangle [
	| bottomLeft bottomRight topLeft topRight |
	bottomLeft := self transformPosition: rectangle bottomLeft.
	bottomRight := self transformPosition: rectangle bottomRight.
	topLeft := self transformPosition: rectangle topLeft.
	topRight := self transformPosition: rectangle topRight.
	^ Rectangle encompassing: { bottomLeft . bottomRight . topLeft . topRight }
]

{ #category : #transformation }
FormSGOSWindowGenericRenderer >> transformVector: aPosition [
	^ currentScale * aPosition
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> validateCachedSubScene: node renderTarget: renderTarget [
	renderer withRenderTarget: renderTarget do: [
		| convertedRectangle translation |
		renderer
			color: (Color r: ((Time microsecondClockValue*1e-6) sin * 0.5 + 0.5) g: 0.0 b: 0.0 alpha: 1.0);
			clear.
		
		convertedRectangle := self transformRectangle: node rectangle.
		translation := convertedRectangle origin negated.
		self class new
			render: node child with: renderer
			scaleFactor: currentScale translation: translation clippingBounds: (0@0 extent: convertedRectangle extent ceiling).
	].
	renderer
		clippingBounds: currentClipRectangle;
		useCompositeAlphaBlending
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
	| rectangle requiredExtent renderTarget |
	rectangle := node rectangle.
	rectangle ifNil: [ ^ self ].
	rectangle := self transformRectangle: rectangle.
	
	requiredExtent := rectangle extent ceiling.
	(requiredExtent x <= 0 or: [requiredExtent y <= 0]) ifTrue: [ ^ self ].

	self flag: 'TODO: Fix this caching support.'.
	true ifTrue: [ ^ self visitNode: node clipChildNode ].
	
	renderTarget := renderer getOrCreateRenderTargetTextureFor: node withExtent: rectangle extent ceiling.
	renderTarget ifNil: [ ^ self visitNode: node clipChildNode ].
	
	renderTarget userData ~= node modificationCount ifTrue: [
		self validateCachedSubScene: node renderTarget: renderTarget.
		renderTarget userData: node modificationCount
	].

	renderer color: Color white;
		drawTexture: renderTarget in: rectangle
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
	| convertedRectangle scaledFont |
	node font ifNil: [ ^ nil ].
	convertedRectangle := self transformRectangle: node rectangle.
	(currentClipRectangle intersects: convertedRectangle) ifFalse: [ ^ self ].
	scaledFont := node font.
	(currentScale closeTo: 1.0) ifFalse: [
		scaledFont := scaledFont withSizeIncrementedBy: (scaledFont pointSize*currentScale) - scaledFont pointSize
	].

	renderer drawString: node string from: node firstIndex to: node lastIndex
		in: convertedRectangle
		font: scaledFont color: node color
		underline: node underline underlineColor: node underlineColor
		strikethrough: node strikethrough strikethroughColor: node strikethroughColor
		kern: node kern
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitTextureNode: node [
	| texture convertedRectangle |
	node form ifNil: [ ^ self ].
	convertedRectangle := self transformRectangle: node rectangle.
	(currentClipRectangle intersects: convertedRectangle) ifFalse: [ ^ self ].

	texture := renderer getOrCreateStaticTextureFromForm: node form.
	texture ifNil: [ ^ self ].
	
	renderer color: Color white;
		drawTexture: texture in: convertedRectangle
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
	currentTranslation := currentTranslation + (oldScale * newTranslation).
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
