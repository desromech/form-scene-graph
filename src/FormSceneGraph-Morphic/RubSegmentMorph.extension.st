Extension { #name : #RubSegmentMorph }

{ #category : #'*FormSceneGraph-Morphic' }
RubSegmentMorph >> buildBorderSceneGraphNodeWith: builder [
	| result style |
	result := builder null.
	style := self borderStyle.
	self lineSegmentsDo: [ :p1 :p2 |
		result := result , (style buildSceneGraphNodeForLineStart: p1 end: p2 with: builder)
	].
	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
RubSegmentMorph >> buildSceneGraphNodeWith: builder [
	| fillStyle result |
	fillStyle := self fillStyle.
	result := builder null.
	self computeInteriorRectangles do: [ :each |
		result := result , (builder fillRectangle: each style: self fillStyle )
	].

	^ result , (self buildBorderSceneGraphNodeWith: builder)
]

{ #category : #'*FormSceneGraph-Morphic' }
RubSegmentMorph >> computeInteriorRectangles [
	^ #()
]
