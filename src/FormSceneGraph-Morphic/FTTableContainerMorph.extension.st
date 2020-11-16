Extension { #name : #FTTableContainerMorph }

{ #category : #'*FormSceneGraph-Morphic' }
FTTableContainerMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	self drawRowsOn: nil.
	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
FTTableContainerMorph >> shouldCacheSceneGraphSurface [
	^ true
]
