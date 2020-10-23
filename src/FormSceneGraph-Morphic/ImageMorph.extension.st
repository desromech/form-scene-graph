Extension { #name : #ImageMorph }

{ #category : #'*FormSceneGraph-Morphic' }
ImageMorph >> buildSceneGraphNodeWith: builder [
	^ (builder textureForm: image at: self innerBounds origin opaque: self isOpaque) ,
		(builder borderRectangle: self bounds style: self borderStyle).
]
