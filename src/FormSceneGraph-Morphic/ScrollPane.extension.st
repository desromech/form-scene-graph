Extension { #name : #ScrollPane }

{ #category : #'*FormSceneGraph-Morphic' }
ScrollPane >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
