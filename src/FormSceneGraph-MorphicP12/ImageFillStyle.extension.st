Extension { #name : 'ImageFillStyle' }

{ #category : '*FormSceneGraph-MorphicP12' }
ImageFillStyle >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ 	self extent
		ifNil: [ builder textureForm: self form at: self origin + self offset ]
		ifNotNil: [ builder texturedRectangle: (self origin + self offset extent: self extent) form: self form ]
]
