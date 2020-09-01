Class {
	#name : #FormSGAthensRenderer,
	#superclass : #FormSGVisitor,
	#instVars : [
		'canvas'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #rendering }
FormSGAthensRenderer class >> render: node on: canvas [
	^ self new render: node on: canvas
]

{ #category : #rendering }
FormSGAthensRenderer >> render: node on: aCanvas [
	canvas := aCanvas.
	self visitNode: node
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
FormSGAthensRenderer >> visitBorderNode: node [
	node color isTransparent ifTrue: [ ^ self ].
	
	canvas setPaint: node color.
	node borderRectanglesDo: [ :each |
		canvas drawShape: each
	]
	
]

{ #category : #visiting }
FormSGAthensRenderer >> visitClipNode: node [
	"self visitNode: node child."
	| originalTransform transformedRectangle |
	originalTransform := canvas pathTransform copy.
	transformedRectangle := self transformRectangle: node rectangle.
	canvas pathTransform restoreAfter: [ 
		canvas pathTransform loadIdentity.
		canvas clipBy: transformedRectangle during: [ 
			canvas pathTransform loadAffineTransform: originalTransform.
			self visitNode: node child
		]
	].

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
FormSGAthensRenderer >> visitNullNode: node [
	"Nothing is required here."
]

{ #category : #visiting }
FormSGAthensRenderer >> visitTextNode: node [
	node font ifNil: [ ^ self ].
	
	canvas setFont: node font.
	canvas setPaint: node color.
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateBy: node rectangle origin + (0@ node font ascent).
		canvas drawString: node string from: node firstIndex to: node lastIndex
	].
]

{ #category : #visiting }
FormSGAthensRenderer >> visitTextureNode: node [
	canvas pathTransform restoreAfter: [
		canvas setPaint: node form.
		canvas pathTransform translateBy: node rectangle origin.
		canvas drawShape: (0@0 extent: node rectangle extent).
	].


]

{ #category : #visiting }
FormSGAthensRenderer >> visitTransformNode: node [
	"canvas pathTransform restoreAfter: [
		canvas pathTransform translateBy: node transform translation.
		self visitNode: node child
	]"
]

{ #category : #visiting }
FormSGAthensRenderer >> visitTranslationNode: node [
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateBy: node translation.
		self visitNode: node child
	]
]
