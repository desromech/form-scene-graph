Extension { #name : #CompositeBorder }

{ #category : #'*FormSceneGraph-Morphic' }
CompositeBorder >> buildSceneGraphNodeForBorder: aRectangle with: builder [
	| result |
	result := builder null.
	borders do: [ :each |
		result := result , (each buildSceneGraphNodeForBorder: aRectangle with: builder)
	].
	^ result
]
