Extension { #name : #AColorSelectorMorph }

{ #category : #'*FormSceneGraph-Morphic' }
AColorSelectorMorph >> buildSceneGraphNodeWith: builder [
	^ (builder rectangle: self innerBounds
		fillStyle: (InfiniteForm with: self hatchForm)) ,
		(super buildSceneGraphNodeWith: builder)
]
