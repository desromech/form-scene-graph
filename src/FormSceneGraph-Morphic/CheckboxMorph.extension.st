Extension { #name : #CheckboxMorph }

{ #category : #'*FormSceneGraph-Morphic' }
CheckboxMorph >> listBuildSceneGraphWith: builder atRow: aRow bounds: drawBounds color: drawColor backgroundColor: backgroundColor from: aMorph [

	| result |
	self color: backgroundColor.
	self bounds: drawBounds.
	result := self buildFullSceneGraphWith: builder.
	aMorph addMorph: self.
	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
CheckboxMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
