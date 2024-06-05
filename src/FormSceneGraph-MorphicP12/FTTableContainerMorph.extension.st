Extension { #name : 'FTTableContainerMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
FTTableContainerMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	self drawRowsOn: nil.
	^ result
]
