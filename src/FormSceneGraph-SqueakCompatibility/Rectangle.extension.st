Extension { #name : #Rectangle }

{ #category : #'*FormSceneGraph-SqueakCompatibility' }
Rectangle >> closeTo: aRectangle [
 	^ (origin closeTo: aRectangle origin) and: [ corner closeTo: aRectangle corner ]
]

{ #category : #'*FormSceneGraph-SqueakCompatibility' }
Rectangle >> closeTo: aRectangle precision: aPrecision [
 	^ (origin closeTo: aRectangle origin precision: aPrecision) and: [
		corner closeTo: aRectangle corner precision: aPrecision ]
]

{ #category : #'*FormSceneGraph-SqueakCompatibility' }
Rectangle >> intersect: aRectangle ifNone: aBlock [
	"Answer a Rectangle that is the area in which the receiver overlaps with 
	aRectangle. 
	If there's no overlap, evaluate the block instead 
	"

	| aPoint left right top bottom |
	(self intersects: aRectangle)
		ifFalse: [ ^ aBlock value ].
	aPoint := aRectangle origin.
	left := aPoint x max: origin x.
	top := aPoint y max: origin y.
	aPoint := aRectangle corner.
	right := aPoint x min: corner x.
	bottom := aPoint y min: corner y.
	^ Rectangle origin: left @ top corner: right @ bottom
]
