Extension { #name : #PluggableButtonMorph }

{ #category : #'*FormSceneGraph-Morphic' }
PluggableButtonMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
