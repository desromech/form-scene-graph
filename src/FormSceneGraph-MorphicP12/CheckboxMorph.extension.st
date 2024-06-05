Extension { #name : 'CheckboxMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
CheckboxMorph >> listBuildSceneGraphWith: builder atRow: aRow bounds: drawBounds color: drawColor backgroundColor: backgroundColor from: aMorph [

	| result |
	self color: backgroundColor.
	self bounds: drawBounds.
	result := self buildFullSceneGraphWith: builder.
	aMorph addMorph: self.
	^ result
]

{ #category : '*FormSceneGraph-MorphicP12' }
CheckboxMorph >> shouldDrawKeyboardFocusIndicator [
	^ self hasKeyboardFocus
]
