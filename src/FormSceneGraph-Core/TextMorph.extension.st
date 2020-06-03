Extension { #name : #TextMorph }

{ #category : #'*FormSceneGraph-Core' }
TextMorph >> buildSceneGraphNodeWith: builder [
	| result fauxBounds |
	result := super buildSceneGraphNodeWith: builder.
	(self startingIndex > text size)
		ifTrue: [ ^ result ].
	fauxBounds := self bounds topLeft corner: self innerBounds bottomRight.
	^ result , (self paragraph buildSceneGraphNodeWith: builder bounds: fauxBounds color: color)
]
