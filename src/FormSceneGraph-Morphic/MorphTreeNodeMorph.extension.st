Extension { #name : #MorphTreeNodeMorph }

{ #category : #'*FormSceneGraph-Morphic' }
MorphTreeNodeMorph >> buildCheckSceneGraphNodeWith: builder [
	| topLeft icon |
	topLeft := self computeCheckTopLeft.
	icon := self retrieveCheckIcon.
	^ builder textureForm: icon at: topLeft
]

{ #category : #'*FormSceneGraph-Morphic' }
MorphTreeNodeMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := builder null.
	container withHLines ifTrue: [
		result := builder frameRectangle: self selectionFrame width: 1
			colors: {Color veryLightGray. Color transparent} dashes: #(1 2)
	].
	self hasToggle ifTrue: [
		result := result , (self buildToggleSceneGraphNodeWith: builder in: self toggleRectangle)
	].
	container listManager isCheckList ifTrue: [
		result := result , (self buildCheckSceneGraphNodeWith: builder)
	].
	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
MorphTreeNodeMorph >> buildToggleSceneGraphNodeWith: builder in: aRectangle [
	| aForm centeringOffset |
	aForm := self toggleImageForm.
	centeringOffset := ((aRectangle height - aForm extent y) / 2.0) truncated.
	^ builder textureForm: aForm at: (aRectangle topLeft translateBy: 0 @ centeringOffset)
]
