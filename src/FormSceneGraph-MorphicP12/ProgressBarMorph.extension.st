Extension { #name : 'ProgressBarMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
ProgressBarMorph >> buildSceneGraphNodeWith: builder [
	| area result |
	area := self innerBounds.
	result := builder rectangle: area fillStyle: self fillStyle.
	value > 0 ifTrue: [ 
		cachedWidth := self completedWidth.
		area := area origin extent: cachedWidth @ area height.
		result := result , (builder rectangle: area fillStyle: self barFillStyle)
	].
	result := result , (builder borderRectangle: self bounds style: self borderStyle).
	^ result
]
