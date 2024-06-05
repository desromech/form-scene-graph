Extension { #name : 'FTCellMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
FTCellMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	topSeparator
		ifTrue: [ result := builder horizontalLineFrom: bounds topLeft to: bounds topRight width: 1 color: self seperatorColor ].
	^ result
]
