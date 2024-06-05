Extension { #name : 'FTTableMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
FTTableMorph >> shouldCacheSceneGraphSurface [
	^ true
]

{ #category : '*FormSceneGraph-MorphicP12' }
FTTableMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
