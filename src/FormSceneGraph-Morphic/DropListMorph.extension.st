Extension { #name : #DropListMorph }

{ #category : #'*FormSceneGraph-Morphic' }
DropListMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
