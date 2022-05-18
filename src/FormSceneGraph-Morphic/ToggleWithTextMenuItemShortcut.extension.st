Extension { #name : #ToggleWithTextMenuItemShortcut }

{ #category : #'*FormSceneGraph-Morphic' }
ToggleWithTextMenuItemShortcut >> buildSceneGraphNodeWith: builder [
	| keyBounds |
	keyBounds := self boundsForKeyText: self keyText font: self owner fontToUse.
	^ self owner buildText: keyText sceneGraphNodeWith: builder in: keyBounds color: self color
]
