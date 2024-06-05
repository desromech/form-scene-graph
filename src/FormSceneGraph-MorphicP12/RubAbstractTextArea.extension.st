Extension { #name : 'RubAbstractTextArea' }

{ #category : '*FormSceneGraph-MorphicP12' }
RubAbstractTextArea >> buildChildrenSceneGraphNodeWith: builder [
	| result |
	result := super buildChildrenSceneGraphNodeWith: builder.
	^ result , (self paragraph buildSceneGraphNodeWith: builder bounds: self drawingBounds color: self textColor).

]

{ #category : '*FormSceneGraph-MorphicP12' }
RubAbstractTextArea >> shouldDrawKeyboardFocusIndicator [
	^ (scrollPane isNil and: [ self readOnly not and: [ self hasKeyboardFocus or: [ self hasFindReplaceFocus ] ] ])
]
