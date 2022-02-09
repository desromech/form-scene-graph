"
I am a scene graph renderer that uses the BitBlt canvas for rendering.
"
Class {
	#name : #FormSGCanvasRenderer,
	#superclass : #FormSGRenderer,
	#instVars : [
		'canvas',
		'currentTransform'
	],
	#category : #'FormSceneGraph-Renderer-Basic'
}

{ #category : #rendering }
FormSGCanvasRenderer class >> render: node on: canvas [
	^ self new render: node on: canvas
]

{ #category : #rendering }
FormSGCanvasRenderer class >> render: node withTransform: initialTransform on: canvas [
	^ self new render: node withTransform: initialTransform on: canvas
]

{ #category : #rendering }
FormSGCanvasRenderer >> render: node on: aCanvas [
	self render: node withTransform: FormSGAffineTransform identity on: aCanvas
]

{ #category : #rendering }
FormSGCanvasRenderer >> render: node withTransform: initialTransform on: aCanvas [
	canvas := aCanvas.
	currentTransform := initialTransform.
	self visitNode: node.
]

{ #category : #transformation }
FormSGCanvasRenderer >> transformRectangle: aRectangle [
	^ aRectangle
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitBorderNode: node [
	node color isTransparent ifTrue: [ ^ self ].
	
	node borderRectanglesDo: [ :rect |
		canvas fillRectangle: (currentTransform transformRectangle: rect) color: node color
	].
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitCachedSubScene: node [
	| form rectangle surfaceExtent |
	rectangle := node rectangle.
	node rectangle ifNil: [ ^ self ].

	surfaceExtent := (rectangle extent * surfaceScaleFactor) ceiling.

	form := node validCachedFormWithExtent: surfaceExtent.
	form ifNil: [ ^ self ].
	
	canvas translucentImage: form at: node rectangle origin
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
	canvas fillRectangle: (currentTransform transformRectangle: node rectangle) color: node color
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
		in: (currentTransform transformRectangle: node rectangle)
		font: node font color: node color
		underline: node underline underlineColor: node underlineColor
		strikethrough: node strikethrough strikethroughColor: node strikethroughColor
		kern: node kern

]

{ #category : #visiting }
FormSGCanvasRenderer >> visitTextureNode: node [
	node isFullyOpaque ifTrue: [
		canvas drawImage: node form at: (currentTransform transformPoint: node rectangle origin)
	] ifFalse: [ 
		canvas translucentImage: node form at: (currentTransform transformPoint: node rectangle origin)
	].


]

{ #category : #visiting }
FormSGCanvasRenderer >> visitTransformNode: node [
	| oldTransform |
	oldTransform := currentTransform.
	currentTransform := currentTransform transformTransform: node transform.
	[ 
		self visitNode: node child
	] ensure: [ currentTransform := oldTransform ].
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitTranslationNode: node [
	| oldTransform |
	oldTransform := currentTransform.
	currentTransform := currentTransform transformTransform: (FormSGAffineTransform translation: node translation).
	[ 
		self visitNode: node child
	] ensure: [ currentTransform := oldTransform ].
]

{ #category : #visiting }
FormSGCanvasRenderer >> withCanvas: newCanvas do: aBlock [
	| oldCanvas |
	oldCanvas := canvas.
	[ 
		canvas := newCanvas.
		aBlock value
	] ensure: [ canvas := oldCanvas ]

]
