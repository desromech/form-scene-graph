Extension { #name : #StringMorph }

{ #category : #'*FormSceneGraph-Morphic' }
StringMorph >> buildSceneGraphNodeWith: builder [
	| emphasisCode |
	emphasisCode := emphasis ifNil: [ 0 ].
	^ (builder fillRectangle: self bounds style: self backgroundColor),
	 (builder string: self contents 
		in: self stringBounds 
		font: self fontToUse 
		color: self stringColor
		underline: (emphasisCode bitAnd: 2r100) ~~ 0
		underlineColor: self underlineColor 
		strikethrough: (emphasisCode bitAnd: 2r10000) ~~ 0
		strikethroughColor: self strikethroughColor)
]
