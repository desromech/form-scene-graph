Extension { #name : #CheckboxMorph }

{ #category : #'*FormSceneGraph-Morphic' }
CheckboxMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
