Extension { #name : 'AnimatedImageMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
AnimatedImageMorph >> buildSceneGraphNodeWith: builder [
	^ builder textureForm: activeForm at: self bounds origin
]
