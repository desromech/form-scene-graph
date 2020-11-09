Extension { #name : #HandMorph }

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> buildSceneGraphNodeWith: builder [
	| cursor |
	self needsToBeDrawn ifFalse: [ ^ builder null ].
	cursor := temporaryCursor ifNil: [ NormalCursor ].
	^ builder texturedRectangle: (bounds topLeft extent: cursor extent) form: cursor
]

{ #category : #'*FormSceneGraph-Morphic' }
HandMorph >> computeDamageRectForNextFrame [
	| damageRect myBnds |
	damageRect := myBnds := self fullBounds.
	savedPatch ifNotNil: 
			[damageRect := myBnds merge: (savedPatch offset extent: savedPatch extent)].
	(savedPatch isNil or: [savedPatch extent ~= myBnds extent]) 
		ifTrue: 
			["allocate new patch form if needed"
			self flag: 'TODO: Remove this ugly hack'.
			savedPatch := Form extent: myBnds extent ].
	savedPatch offset: myBnds topLeft.
	hasChanged := false.
	^damageRect
]
