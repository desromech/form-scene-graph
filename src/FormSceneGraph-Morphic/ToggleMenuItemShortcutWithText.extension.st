Extension { #name : #ToggleMenuItemShortcutWithText }

{ #category : #'*FormSceneGraph-Morphic' }
ToggleMenuItemShortcutWithText >> buildSceneGraphNodeWith: builder [
	| keyBounds |
	keyBounds := self boundsForKeyText: self keyText font: self owner fontToUse.
	^ self owner buildText: keyText sceneGraphNodeWith: builder in: keyBounds color: self color
]
