Extension { #name : #TextHighlightByBounds }

{ #category : #'*FormSceneGraph-Morphic' }
TextHighlightByBounds >> buildSceneGraphNodeWith: builder in: rect offset: o [
	"Draw the highlight on the given canvas for the given rectangle."

	| r result |
	r := self fillWidth
		ifTrue: [ rect left @ (self bounds top + rect top) corner: rect right @ (self bounds bottom + rect top) ]
		ifFalse: [ self bounds translateBy: rect topLeft ].
	r := r
		translateBy:
			(self fillWidth
				ifTrue: [ 0 @ o y negated ]
				ifFalse: [ o negated ]).
	result := builder null.
	self color isTransparent ifFalse: [ result := builder rectangle: r color: self color ].
	(self borderWidth > 0 and: [ self borderColor isTransparent not ])
		ifTrue: [ 
			(self borderSides includes: #top)
				ifTrue: [ result := result , (builder rectangle: (r withHeight: self borderWidth) color: self borderColor) ].
			(self borderSides includes: #right)
				ifTrue: [ result := result , (builder rectangle: (r withLeft: r right - self borderWidth) color: self borderColor) ].
			(self borderSides includes: #bottom)
				ifTrue: [ result := result , (builder rectangle: (r withTop: r bottom - self borderWidth) color: self borderColor) ].
			(self borderSides includes: #left)
				ifTrue: [ result := result , (builder rectangle: (r withWidth: self borderWidth) color: self borderColor) ] ].
	^ result
]
