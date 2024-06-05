Extension { #name : 'RubTextScrollPane' }

{ #category : '*FormSceneGraph-MorphicP12' }
RubTextScrollPane >> shouldDrawKeyboardFocusIndicator [
	self textArea readOnly ifTrue: [ ^ false ].
	self drawFocusBorder ifFalse: [ ^ false ].
	^ (self hasKeyboardFocus or: [ self textArea hasFindReplaceFocus ]) 
]
