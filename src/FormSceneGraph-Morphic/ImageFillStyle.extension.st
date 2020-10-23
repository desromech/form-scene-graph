Extension { #name : #ImageFillStyle }

{ #category : #'*FormSceneGraph-Morphic' }
ImageFillStyle >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ 	self extent
		ifNil: [ builder textureForm: self form at: self]
		ifNotNil: [ builder texturedRectangle: (self origin + self offset extent: self extent) form: self form ]
]
