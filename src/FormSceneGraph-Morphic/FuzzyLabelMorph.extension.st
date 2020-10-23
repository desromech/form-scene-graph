Extension { #name : #FuzzyLabelMorph }

{ #category : #'*FormSceneGraph-Morphic' }
FuzzyLabelMorph >> buildSceneGraphNodeWith: builder [
	|pc fuzzColor labelColor result|
	pc := self paneColor.
	labelColor := self enabled
		ifTrue: [self color]
		ifFalse: [pc twiceDarker].
	fuzzColor := self enabled
		ifTrue: [labelColor twiceDarker darker contrastingBlackAndWhiteColor alpha: self 
alpha]
		ifFalse: [Color transparent].
	result := builder null.
	fuzzColor isTransparent ifFalse: [
		result := result ,
			(builder string: self contents
				in: (self bounds translateBy: 0 @ -1)
				font: self fontToUse
				color: fuzzColor) ,
			(builder string: self contents
				in: (self bounds translateBy: (self offset * 2) @ -1)
				font: self fontToUse
				color: fuzzColor) ,
			(builder string: self contents
				in: (self bounds translateBy: (self offset * 2) @ (self offset 
* 2 - 1))
				font: self fontToUse
				color: fuzzColor) ,
			(builder string: self contents
				in: (self bounds translateBy: 0 @ (self offset * 2 - 1))
				font: self fontToUse
				color: fuzzColor)
	].

	result := result , (builder string: self contents
		in: (self bounds translateBy: self offset @ (self offset - 1))
		font: self fontToUse
		color: labelColor).

	^ result
]
