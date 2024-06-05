Extension { #name : 'AColorSelectorMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
AColorSelectorMorph >> buildSceneGraphNodeWith: builder [
	^ (builder rectangle: self innerBounds
		fillStyle: (InfiniteForm with: self hatchForm)) ,
		(super buildSceneGraphNodeWith: builder)
]
