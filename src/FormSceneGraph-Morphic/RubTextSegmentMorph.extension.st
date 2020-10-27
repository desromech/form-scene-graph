Extension { #name : #RubTextSegmentMorph }

{ #category : #'*FormSceneGraph-Morphic' }
RubTextSegmentMorph >> buildIconSceneGraphNodeAt: aPosition with: builder [
	self icon ifNil: [ ^ builder null ].
	^ builder textureForm: self icon at: aPosition
]

{ #category : #'*FormSceneGraph-Morphic' }
RubTextSegmentMorph >> computeInteriorRectangles [
	| firstCB lastCB firstLineIndex lastLineIndex firstLine lastLine |
	firstCB := self characterBlockForIndex: firstIndex.
	lastCB := self characterBlockForIndex: lastIndex.
	firstLineIndex := self lineIndexOfCharacterIndex: firstIndex.
	lastLineIndex := self lineIndexOfCharacterIndex: lastIndex.
	firstLine := self lines at: firstLineIndex.
	lastLine := self lines at: lastLineIndex.

	^ firstLine = lastLine ifTrue: [
		firstIndex = lastIndex ifTrue: [ 
			#()
		] ifFalse: [ 
			^ {firstCB bottomLeft corner: lastCB topLeft}
		]
	] ifFalse: [
		^ {
			firstCB bottomLeft corner: (self textArea right - self margins right) @ firstLine top.
			(self textArea left + self margins left) @ firstLine bottom corner: (self textArea right - self margins right) @ lastLine top.
			lastCB bottomLeft corner: (self textArea left + self margins left) @ lastLine top
		}
	]
]
