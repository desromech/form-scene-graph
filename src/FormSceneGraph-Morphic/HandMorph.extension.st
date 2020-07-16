Extension { #name : #HandMorph }

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> buildSceneGraphNodeWith: builder [
	| cursor |
	self needsToBeDrawn ifFalse: [ ^ builder null ].
	cursor := temporaryCursor ifNil: [ NormalCursor ].
	^ builder texturedRectangle: (bounds topLeft extent: cursor extent) form: cursor
]
