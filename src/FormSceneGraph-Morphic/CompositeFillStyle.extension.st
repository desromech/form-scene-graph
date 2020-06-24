Extension { #name : #CompositeFillStyle }

{ #category : #'*FormSceneGraph-Morphic' }
CompositeFillStyle >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	| result |
	result := builder null.
	self fillStyles do: [ :each |
		result := result , (each buildSceneGraphNodeForFilling: aRectangle with: builder)
	].
	^ result
]
