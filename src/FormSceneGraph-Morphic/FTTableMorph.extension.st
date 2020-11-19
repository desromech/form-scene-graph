Extension { #name : #FTTableMorph }

{ #category : #'*FormSceneGraph-Morphic' }
FTTableMorph >> shouldCacheSceneGraphSurface [
	^ true
]

{ #category : #'*FormSceneGraph-Morphic' }
FTTableMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
