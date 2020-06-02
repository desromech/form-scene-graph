Extension { #name : #TransformMorph }

{ #category : #'*FormSceneGraph-Morphic' }
TransformMorph >> buildSceneGraphClippingFor: submorphNodes with: builder [
	| result |
	submorphNodes ifEmpty: [ ^ builder null ].

	result := builder containerWith: submorphNodes.
	result := transform isPureTranslation
		ifTrue: [ builder translate: result with: transform asFormSGTransform translation ]
		ifFalse: [ builder transform: result with: transform asFormSGTransform ].
	self clipSubmorphs ifTrue: [ result := builder clip: result withRectangle: self clippingBounds ].
	^ result
]
