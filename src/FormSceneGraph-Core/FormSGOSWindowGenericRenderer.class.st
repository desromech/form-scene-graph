Class {
	#name : #FormSGOSWindowGenericRenderer,
	#superclass : #FormSGVisitor,
	#instVars : [
		'renderer',
		'currentTranslation',
		'currentClipRectangle'
	],
	#category : #'FormSceneGraph-Core'
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
	self render: node with: theRenderer translation: 0@0 clippingBounds: clippingBounds
]

{ #category : #rendering }
FormSGOSWindowGenericRenderer >> render: node with: theRenderer translation: translation clippingBounds: clippingBounds [
	renderer := theRenderer.
	renderer useCompositeAlphaBlending.

	currentTranslation := translation.
	currentClipRectangle := clippingBounds.
	renderer clippingBounds: clippingBounds.
	self visitNode: node.
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> validateCachedSubScene: node renderTarget: renderTarget [
	renderer withRenderTarget: renderTarget do: [
		| translation |
		renderer
			color: Color transparent;
			clear.
		
		translation := node rectangle origin negated.
		self class new
			render: node child with: renderer
			translation: translation clippingBounds: (0@0 extent: node rectangle extent ceiling).
			
		renderer clippingBounds: currentClipRectangle.
	]
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitBorderNode: node [
	node color isTransparent ifTrue: [ ^ self ].
	
	renderer color: node color.
	node borderRectanglesDo: [ :rect |
		renderer fillRectangle: (rect translateBy: currentTranslation)
	].

]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitCachedSubScene: node [
	| rectangle requiredExtent renderTarget convertedRectangle |
	rectangle := node rectangle.
	rectangle ifNil: [ ^ self ].
	
	requiredExtent := rectangle extent ceiling.
	(requiredExtent x <= 0 or: [requiredExtent y <= 0]) ifTrue: [ ^ self ].
	
	renderTarget := renderer getOrCreateRenderTargetTextureFor: node withExtent: rectangle extent ceiling.
	renderTarget ifNil: [ ^ self visitNode: node clipChildNode ].
	
	renderTarget userData ~= node modificationCount ifTrue: [
		self validateCachedSubScene: node renderTarget: renderTarget.
		renderTarget userData: node modificationCount
	].

	convertedRectangle := node rectangle translateBy: currentTranslation.
	
	renderer color: Color white;
		drawTexture: renderTarget in: convertedRectangle

]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitClipNode: node [
	| convertedClipRectangle oldClipRectangle |
	convertedClipRectangle := node rectangle translateBy: currentTranslation.
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
		fillRectangle: (node rectangle translateBy: currentTranslation)
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
	| convertedRectangle |
	convertedRectangle := node rectangle translateBy: currentTranslation.
	(currentClipRectangle intersects: convertedRectangle) ifFalse: [ ^ self ].
	
	renderer drawString: node string from: node firstIndex to: node lastIndex
		in: convertedRectangle
		font: node font color: node color
		underline: node underline underlineColor: node underlineColor
		strikethrough: node strikethrough strikethroughColor: node strikethroughColor
		kern: node kern
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitTextureNode: node [
	| texture convertedRectangle |
	node form ifNil: [ ^ self ].
	convertedRectangle := node rectangle translateBy: currentTranslation.
	(currentClipRectangle intersects: convertedRectangle) ifFalse: [ ^ self ].

	texture := renderer getOrCreateStaticTextureFromForm: node form.
	texture ifNil: [ ^ self ].
	
	renderer color: Color white;
		drawTexture: texture in: convertedRectangle
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitTransformNode: node [
	node transform isTranslationOnly ifTrue: [ 
		^ self withTranslation: node transform translation do: [ 
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
FormSGOSWindowGenericRenderer >> withTranslation: newTranslation do: aBlock [
	| oldTranslation |
	oldTranslation := currentTranslation.
	currentTranslation := currentTranslation + newTranslation.
	aBlock ensure: [ currentTranslation := oldTranslation ].
]
