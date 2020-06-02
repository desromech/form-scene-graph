Extension { #name : #Color }

{ #category : #'*FormSceneGraph-Morphic' }
Color >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ builder solidRectangle: aRectangle color: self
]
