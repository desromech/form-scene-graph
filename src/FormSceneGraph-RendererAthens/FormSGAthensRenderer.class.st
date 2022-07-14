"
I am a scene graph renderer that uses athens.
"
Class {
	#name : #FormSGAthensRenderer,
	#superclass : #FormSGRenderer,
	#instVars : [
		'canvas'
	],
	#category : #'FormSceneGraph-RendererAthens'
}

{ #category : #rendering }
FormSGAthensRenderer class >> render: node on: canvas [
	^ self new render: node on: canvas
]

{ #category : #rendering }
FormSGAthensRenderer class >> render: node withTransform: initialTransform on: canvas [
	^ self new render: node withTransform: initialTransform on: canvas
]

{ #category : #rendering }
FormSGAthensRenderer >> render: node on: aCanvas [
	canvas := aCanvas.
	self visitNode: node
]

{ #category : #rendering }
FormSGAthensRenderer >> render: node withTransform: transform on: aCanvas [
	canvas := aCanvas.
	canvas pathTransform restoreAfter: [
		canvas pathTransform multiplyBy: transform asAthensTransform.
		self visitNode: node
	]
]

{ #category : #visiting }
FormSGAthensRenderer >> transformRectangle: rectangle [
	| pathTransform bottomLeft bottomRight topLeft topRight |
	pathTransform := canvas pathTransform.
	bottomLeft := pathTransform transform: rectangle bottomLeft.
	bottomRight := pathTransform transform: rectangle bottomRight.
	topLeft := pathTransform transform: rectangle topLeft.
	topRight := pathTransform transform: rectangle topRight.
	^ Rectangle encompassing: { bottomLeft . bottomRight . topLeft . topRight }
]

{ #category : #visiting }
FormSGAthensRenderer >> visitAthensNode: node [
	| rectangle transformedRectangle surface logicalExtent surfaceExtent |
	rectangle := node rectangle.
	(rectangle isNil or: [rectangle isEmpty]) ifTrue: [ ^ self ].

	transformedRectangle := self transformRectangle: rectangle.
	logicalExtent := rectangle extent ceiling.
	surfaceExtent := (rectangle extent * surfaceScaleFactor) ceiling.
	(surfaceExtent x <= 1 or: [ surfaceExtent y <= 1 ]) ifTrue: [ ^ self ].
	
	surface := node validAthensCairoSurfaceWithExtent: surfaceExtent.
	surface ifNil: [ ^ self ].

	canvas pathTransform restoreAfter: [
		canvas paintTransform loadIdentity.

		canvas setPaint: surface.
		canvas pathTransform loadIdentity
			translateBy: transformedRectangle origin rounded.
		canvas drawShape: (0@0 extent: surfaceExtent).
	].


]

{ #category : #visiting }
FormSGAthensRenderer >> visitBorderNode: node [
	node color isTransparent ifTrue: [ ^ self ].
	
	canvas setPaint: node color.
	node borderRectanglesDo: [ :each |
		canvas drawShape: each
	]
	
]

{ #category : #visiting }
FormSGAthensRenderer >> visitCachedSubScene: node [
	| rectangle surface transformedRectangle logicalExtent surfaceExtent |
	rectangle := node rectangle.
	(rectangle isNil or: [rectangle isEmpty]) ifTrue: [ ^ self ].

	transformedRectangle := self transformRectangle: rectangle.
	surfaceExtent := (rectangle extent * surfaceScaleFactor) ceiling.
	(surfaceExtent x <= 1 or: [ surfaceExtent y <= 1 ]) ifTrue: [ ^ self ].

	logicalExtent := rectangle extent ceiling.
	surface := node validCachedAthensCairoSurfaceWithExtent: surfaceExtent surfaceScaleFactor: surfaceScaleFactor.
	surface ifNil: [ ^ self ].

	canvas pathTransform restoreAfter: [
		canvas paintTransform loadIdentity.

		canvas setPaint: surface.
		canvas pathTransform loadIdentity
			translateBy: transformedRectangle origin rounded.
		canvas drawShape: (0@0 extent: surfaceExtent).
	].

]

{ #category : #visiting }
FormSGAthensRenderer >> visitClipNode: node [
	canvas clipBy: node rectangle during: [ 
		self visitNode: node child
	]

]

{ #category : #visiting }
FormSGAthensRenderer >> visitColorNode: node [
	node color isTransparent ifTrue: [ ^ self ].
	
	canvas
		setPaint: node color;
		drawShape: node rectangle
	
]

{ #category : #visiting }
FormSGAthensRenderer >> visitContainerNode: node [
	node children do: [ :each | self visitNode: each ]
]

{ #category : #visiting }
FormSGAthensRenderer >> visitLinearGradientNode: node [
	| paint |
	(node startColor isTransparent and: [ node endColor isTransparent ]) ifTrue: [ ^ self ].
	
	paint := (LinearGradientPaint fromArray: {
		0 -> node startColor.
		1 -> node endColor.
		})
		start: node startPoint;
		stop: node endPoint;
		yourself.

	canvas paintTransform loadIdentity.
	canvas
		setPaint: paint;
		drawShape: node rectangle
	
]

{ #category : #visiting }
FormSGAthensRenderer >> visitNullNode: node [
	"Nothing is required here."
]

{ #category : #visiting }
FormSGAthensRenderer >> visitRadialGradientNode: node [
	| paint maxRadius |
	(node startColor isTransparent and: [ node endColor isTransparent ]) ifTrue: [ ^ self ].
	
	maxRadius := node maxRadius asFloat.
	paint := (RadialGradientPaint fromArray: {
		node clipInnerRadius / maxRadius -> Color transparent.
		node innerRadius / maxRadius -> node startColor.
		node outerRadius / maxRadius -> node endColor.
		node clipOuterRadius / maxRadius -> Color transparent.
		})
		center: node center asFloatPoint;
		focalPoint: node focalPoint asFloatPoint;
		radius: maxRadius;
		yourself.

	canvas paintTransform loadIdentity.
	canvas
		setPaint: paint;
		drawShape: node rectangle
	
]

{ #category : #visiting }
FormSGAthensRenderer >> visitTextNode: node [
	| font rectangle topLeftTextPoint stringWidthOffset |
	font := node font.
	font ifNil: [ ^ self ].
	rectangle := node rectangle.
	
	canvas setFont: font.
	canvas setPaint: node color.
	topLeftTextPoint := rectangle topLeft + (0 @ font ascent).
	canvas pathTransform restoreAfter: [
		canvas paintTransform loadIdentity.
		canvas pathTransform translateBy: topLeftTextPoint.
		canvas drawString: node string from: node firstIndex to: node lastIndex
	].
	
	(node underline or: [node strikethrough]) ifFalse: [ ^ self ].
	stringWidthOffset := font widthOfString: node string from: node firstIndex to: node lastIndex.
	(node underline and: [ node underlineColor isTransparent not ]) ifTrue: [
		| underlineThickness underlineTop |
	 	underlineThickness := font underlineThickness asFloat.
		underlineTop := font underlineTop asFloat.
		canvas
			setPaint: node underlineColor;
			drawShape: (topLeftTextPoint + (0@underlineTop) extent: stringWidthOffset@underlineThickness)
	].

	(node strikethrough and: [ node strikethroughColor isTransparent not ]) ifTrue: [
		| strikeoutThickness strikeoutTop |
	 	strikeoutThickness := font strikeoutThickness asFloat.
		strikeoutTop := font strikeoutTop asFloat.
		canvas
			setPaint: node strikethroughColor;
			drawShape: (topLeftTextPoint + (0@strikeoutTop) extent: stringWidthOffset@strikeoutThickness)
	].
]

{ #category : #visiting }
FormSGAthensRenderer >> visitTextureNode: node [
	| paint sourceRectangle rectangle extent sourceExtent |
	rectangle := node rectangle.
	extent := rectangle extent.
	(extent x <= 0.0 or: [ extent y <= 0.0 ]) ifTrue: [ ^ self ].
		
	paint := node form asAthensPaintOn: canvas.
	sourceRectangle := node validSourceRectangle.
	sourceExtent := sourceRectangle extent.
	(sourceExtent x <= 0.0 or: [ sourceExtent y <= 0.0 ]) ifTrue: [ ^ self ].
	
	node isRepeated ifTrue: [
		paint repeat
	] ifFalse: [
		paint noRepeat
	].

	canvas pathTransform restoreAfter: [
		canvas paintTransform
			loadIdentity.
		node isRepeated ifTrue: [
			paint repeat
		] ifFalse: [
			paint noRepeat.
			canvas paintTransform
				scaleBy: extent / sourceExtent;
				translateBy: sourceRectangle origin.
		].
		
		canvas setPaint: paint.
		canvas pathTransform translateBy: node rectangle origin.
		canvas drawShape: (0@0 extent: node rectangle extent).
	].

]

{ #category : #visiting }
FormSGAthensRenderer >> visitTransformNode: node [
	(node transform determinant closeTo: 0) ifTrue: [ ^ self ].
	canvas pathTransform restoreAfter: [
		canvas pathTransform multiplyBy: node transform asAthensTransform.
		self visitNode: node child
	]
]

{ #category : #visiting }
FormSGAthensRenderer >> visitTranslationNode: node [
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateBy: node translation.
		self visitNode: node child
	]
]
