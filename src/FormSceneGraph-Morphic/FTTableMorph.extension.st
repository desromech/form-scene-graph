Extension { #name : #FTTableMorph }

{ #category : #'*FormSceneGraph-Morphic' }
FTTableMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
