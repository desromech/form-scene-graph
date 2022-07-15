Extension { #name : #Point }

{ #category : #'*FormSceneGraph-SqueakCompatibility' }
Point >> closeTo: aPoint precision: aPrecision [
 	^ (x closeTo: aPoint x precision: aPrecision) and: [ y closeTo: aPoint y precision: aPrecision ]
]
