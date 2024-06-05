Extension { #name : 'InfiniteForm' }

{ #category : '*FormSceneGraph-MorphicP12' }
InfiniteForm >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ builder texturedRectangle: aRectangle form: patternForm opaque: false repeated: true
]
