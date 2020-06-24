Extension { #name : #ImageFillStyle }

{ #category : #'*FormSceneGraph-Morphic' }
ImageFillStyle >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ 	self extent
		ifNil: [ builder texturedRectangle: (self origin extent: self form extent) form: self form ]
		ifNotNil: [ builder texturedRectangle: (self origin + self offset extent: self extent) form: self form ]
]
