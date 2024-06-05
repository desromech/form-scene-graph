Extension { #name : 'RubColumnDisplayer' }

{ #category : '*FormSceneGraph-MorphicP12' }
RubColumnDisplayer >> buildSceneGraphNodeWith: builder [
	| cwidth col dsh lw cw dc nb bnds gap result columnNodes |
	result := super buildSceneGraphNodeWith: builder.
	bnds := self bounds.
	cwidth := self width.
	cw := self tabWidth.
	gap := self offset x \\ cw .
	col := cw + self margins left.
	dsh := self tabLineDashes.
	dc := self tabLineColor.
	lw := self tabLineWidth.
	nb := cwidth // cw.
	columnNodes := OrderedCollection new.
	nb timesRepeat: [ 
			| b |
			b :=  (bnds topLeft + (col @ 0) ) corner: (bnds bottomLeft + ((col + lw) @ 0) ).
			b := b translateBy: (((cw - gap) - cw)@ 0).
			columnNodes add: (builder borderRectangle: b color: dc width: 4).
			col := col + cw
	].
	^ result , (builder containerWith: columnNodes)
]
