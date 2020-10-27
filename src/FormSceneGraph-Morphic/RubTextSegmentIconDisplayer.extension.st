Extension { #name : #RubTextSegmentIconDisplayer }

{ #category : #'*FormSceneGraph-Morphic' }
RubTextSegmentIconDisplayer >> buildSceneGraphNodeWith: builder [
	| result clippedContent |
	result := super buildSceneGraphNodeWith: builder.
	self paragraph selectionStart ifNil: [ ^ result ].
	self paragraph selectionStop ifNil: [ ^ result ].
	self paragraph lines ifNil: [ ^ result ].
	clippedContent := builder withClippingBounds: self bounds build: [
			| tl br clippedNodes visibleRectangle |
			clippedNodes := OrderedCollection new.
			clippedNodes add: (builder rectangle: self verticalSeparatorBounds color: self verticalSeparatorColor).
			visibleRectangle := builder clippingBounds.
			tl := self lineIndexForPoint: visibleRectangle topLeft.
			br := self lineIndexForPoint: visibleRectangle bottomRight.
			tl to: br do: [ :i | 
				((self paragraphProvider segmentsAtLine: i) select: [ :s | s icon notNil ])
					ifNotEmpty: [ :segments | 
						| s pos iconNode|
						s := segments first.
						iconNode := s buildIconSceneGraphNodeAt: (pos := self iconPositionOfSegment: s) with: builder.
						iconNode isNullNode ifFalse: [ clippedNodes add: iconNode ].
						segments size > 1
							ifTrue: [ 
								| r ygap |
								ygap := s icon height + 1.
								r := pos + (0 @ ygap) corner: (pos x + 12) @ (pos y + ygap + 2).
								clippedNodes
									add: (builder rectangle: (r expandBy: 2) color: (Color white alpha: 0.4));
									add: (builder borderRectangle: r color: Color gray width: 2) ] ] ].
		builder containerWith: clippedNodes
	].
	^ result , clippedContent
]
