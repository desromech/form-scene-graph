Extension { #name : 'LabelMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
LabelMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	(self enabled not and: [ self disabledStyle = #inset ])	ifTrue: [
		result := result , (builder
			string: self contents
			in: (self stringBounds translateBy: 1)
			font: self fontToUse
			color: self theme lightBackgroundColor)
	].
	^ result
]
