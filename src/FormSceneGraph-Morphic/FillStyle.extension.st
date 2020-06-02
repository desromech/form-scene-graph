Extension { #name : #FillStyle }

{ #category : #'*FormSceneGraph-Morphic' }
FillStyle >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ builder solidRectangle: aRectangle color: self asColor
]
