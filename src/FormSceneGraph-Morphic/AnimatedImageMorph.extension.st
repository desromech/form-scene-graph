Extension { #name : #AnimatedImageMorph }

{ #category : #'*FormSceneGraph-Morphic' }
AnimatedImageMorph >> buildSceneGraphNodeWith: builder [
	^ builder textureForm: activeForm at: self bounds origin
]
