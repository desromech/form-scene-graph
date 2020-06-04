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
	renderer := theRenderer.
	renderer useCompositeAlphaBlending.

	currentTranslation := 0@0.
	currentClipRectangle := clippingBounds.
	renderer clippingBounds: clippingBounds.
	self visitNode: node.
]

{ #category : #visiting }
FormSGOSWindowGenericRenderer >> visitBorderNode: node [
	| roundedWidth translatedRectangle |
	node color isTransparent ifTrue: [ ^ self ].
	roundedWidth := (node width + 0.5) floor.
	roundedWidth <= 0 ifTrue: [ ^ self ].
	translatedRectangle := node rectangle translateBy: currentTranslation.

	renderer color: node color.
	roundedWidth = 1 ifTrue: [
		renderer drawRectangle: translatedRectangle
	] ifFalse: [
		(translatedRectangle areasOutside: (translatedRectangle insetBy: roundedWidth)) do: [:edgeStrip |
			renderer fillRectangle: edgeStrip
		].
	]

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

{ #category : #'as yet unclassified' }
FormSGOSWindowGenericRenderer >> withTranslation: newTranslation do: aBlock [
	| oldTranslation |
	oldTranslation := currentTranslation.
	currentTranslation := newTranslation.
	aBlock ensure: [ currentTranslation := oldTranslation ].
]
