Extension { #name : 'RubCodeSizeFeedback' }

{ #category : '*FormSceneGraph-MorphicP12' }
RubCodeSizeFeedback >> buildSceneGraphNodeWith: builder [
	| font s result |
	result := super buildSceneGraphNodeWith: builder.
	color = self normalColor ifTrue: [ ^ result ].
	font := self paragraph textStyle defaultFont.
	s := self textSize asString.
	^ result , (builder
		string: s
		in: (self bounds withTop: self bounds bottom - font height)
		font: font
		color: self stringColor)
]
