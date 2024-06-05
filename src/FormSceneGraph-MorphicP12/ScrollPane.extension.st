Extension { #name : 'ScrollPane' }

{ #category : '*FormSceneGraph-MorphicP12' }
ScrollPane >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
