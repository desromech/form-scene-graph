Extension { #name : #ImageMorph }

{ #category : #'*FormSceneGraph-Morphic' }
ImageMorph >> buildSceneGraphNodeWith: builder [
	^ (builder texturedRectangle: self innerBounds form: image opaque: self isOpaque) ,
		(builder borderRectangle: self bounds style: self borderStyle).
]
