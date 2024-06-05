Extension { #name : 'PluggableButtonMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
PluggableButtonMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
