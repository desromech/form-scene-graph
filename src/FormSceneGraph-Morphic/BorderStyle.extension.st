Extension { #name : #BorderStyle }

{ #category : #'*FormSceneGraph-Morphic' }
BorderStyle >> buildSceneGraphNodeForBorder: aRectangle with: builder [
	^ builder borderRectangle: aRectangle color: self color width: self width
]
