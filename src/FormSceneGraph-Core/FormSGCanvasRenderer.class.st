Class {
	#name : #FormSGCanvasRenderer,
	#superclass : #FormSGVisitor,
	#instVars : [
		'canvas',
		'currentTransform'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #rendering }
FormSGCanvasRenderer class >> render: node on: canvas [
	^ self new render: node on: canvas
]

{ #category : #rendering }
FormSGCanvasRenderer >> render: node on: aCanvas [
	canvas := aCanvas.
	currentTransform := FormSGAffineTransform identity.
	self visitNode: node.
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitBorderNode: node [
	canvas frameRectangle: node rectangle width: node width color: node color
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitClipNode: node [
	node child isTransformNode ifTrue: [
		canvas transformBy: node child transform asDisplayTransform clippingTo: node rectangle during: [:clippedCanvas |
			| oldCanvas |
			oldCanvas := canvas.
			[ 
				canvas := clippedCanvas.
				self visitNode: node child child
			] ensure: [ canvas := oldCanvas ]
		].
		^ self
	].

	canvas clipBy: node rectangle during: [:clippedCanvas |
		| oldCanvas |
		oldCanvas := canvas.
		[ 
			canvas := clippedCanvas.
			self visitNode: node child
		] ensure: [ canvas := oldCanvas ]
	]
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitColorNode: node [
	canvas fillRectangle: node rectangle color: node color
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitContainerNode: node [
	self visitNodes: node children
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitNullNode: node [
	"Nothing required"
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitTextNode: node [
	canvas drawString: node string from: node firstIndex to: node lastIndex
		in: node rectangle
		font: node font color: node color
		underline: node underline underlineColor: node underlineColor
		strikethrough: node strikethrough strikethroughColor: node strikethroughColor

]

{ #category : #visiting }
FormSGCanvasRenderer >> visitTextureNode: node [
	node isFullyOpaque ifTrue: [
		canvas drawImage: node form at: node rectangle origin
	] ifFalse: [ 
		canvas translucentImage: node form at: node rectangle origin
	].


]

{ #category : #visiting }
FormSGCanvasRenderer >> visitTransformNode: node [
	canvas transformBy: node child transform asDisplayTransform clippingTo: node boundingBox during: [:transformedCanvas |
		| oldCanvas |
		oldCanvas := canvas.
		[ 
			canvas := transformedCanvas.
			self visitNode: node child
		] ensure: [ canvas := oldCanvas ]
	]
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitTranslationNode: node [
	canvas translateBy: node translation during: [:translatedCanvas |
		| oldCanvas |
		oldCanvas := canvas.
		[ 
			canvas := translatedCanvas.
			self visitNode: node child
		] ensure: [ canvas := oldCanvas ]
	]
]
