Extension { #name : #EmbossedStringMorph }

{ #category : #'*FormSceneGraph-Morphic' }
EmbossedStringMorph >> buildSceneGraphNodeWith: builder [
	| result box |
	self style == #plain ifTrue: [^super buildSceneGraphNodeWith: builder].

	result := builder null.
	box := self bounds.
	(self style == #inset or: [self style == #insetNoHighlight]) ifTrue: [
		self style == #insetNoHighlight ifFalse: [
			result := builder string: self contents in: (box translateBy: 1) font: self fontToUse color: self color veryMuchLighter.
		].

		result := result ,
			(builder string: self contents in: (box translateBy: -1) font: self fontToUse color: self color muchDarker),
			(builder string: self contents in: box font: self fontToUse color: self color)
	] ifFalse: [
		self style == #raisedNoHighlight ifFalse: [
			result := builder string: self contents in: (box translateBy: -1) font: self fontToUse color: self color veryMuchLighter
		].
		result := result ,
			(builder string: self contents in: (box translateBy: 1) font: self fontToUse color: self color muchDarker),
			(builder string: self contents in: box font: self fontToUse color: self color)
	].
	^ result
]
