Extension { #name : #RubLineNumberDisplayer }

{ #category : #'*FormSceneGraph-Morphic' }
RubLineNumberDisplayer >> buildSceneGraphNodeWith: builder [
	| prev right font lines visibleRectangle tcolor left result clippedContent |
	result := super buildSceneGraphNodeWith: builder.
	self paragraph selectionStart ifNil: [ ^ result ].
	self paragraph selectionStop ifNil: [ ^ result ].
	self paragraph lines ifNil: [ ^ result ].

	right := self bounds right.
	left := self bounds left.
	font := self fontToUse.
	prev := nil.
	lines := self lines.
	tcolor := self textColor.
	clippedContent := builder withClippingBounds: self bounds build: [
			| backBnd clippedNodes |
			clippedNodes := OrderedCollection new.
			clippedNodes add: (builder rectangle: self verticalSeparatorBounds color: self verticalSeparatorColor).
			visibleRectangle := builder clippingBounds.
			(self lineIndexForPoint: visibleRectangle topLeft) to: (self lineIndexForPoint: visibleRectangle bottomRight) do: [ :i | 
				| line |
				line := lines at: i.
				(self selectionStart == self selectionStop and: [self selectionStop textLine lineNumber = line lineNumber])
					ifTrue: [ 
						backBnd := self bounds.
						backBnd := (backBnd left) @ line top corner: self verticalSeparatorBounds left @ line bottom.
						backBnd := backBnd translateBy: 0 @ (self offset y negated + self bounds top).
						clippedNodes add: (builder rectangle: backBnd color: self selectionColorToUse) ].
				prev = line lineNumber
					ifFalse: [ 
						| lineMark lineBnd ygap |
						ygap := ((line lineHeight - font height) // 2 - 1) rounded.
						lineMark := line lineNumber asString.
						self side = #left
							ifTrue: [ 
								| width |
								width := (self fontToUse widthOfString: lineMark) + self horizontalGapAfter.
								lineBnd := (right - width) @ (line bottom - font height - ygap) corner: (right + width) @ line bottom ]
							ifFalse: [ lineBnd := (left + self horizontalGapBefore) @ (line bottom - font height - ygap) corner: right @ line bottom ].
						lineBnd := lineBnd translateBy: 0 @ (self offset y negated + self bounds top).
						clippedNodes add: (builder
							string: lineMark
							in: lineBnd
							font: font
							color: tcolor).
						prev := line lineNumber ] ].
				
		builder containerWith: clippedNodes
	].

	^ result , clippedContent
]
