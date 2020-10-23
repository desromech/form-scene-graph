Extension { #name : #InfiniteForm }

{ #category : #'*FormSceneGraph-Morphic' }
InfiniteForm >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ builder texturedRectangle: aRectangle form: patternForm opaque: false repeated: true
]
