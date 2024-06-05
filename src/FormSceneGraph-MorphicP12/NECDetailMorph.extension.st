Extension { #name : 'NECDetailMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
NECDetailMorph >> buildArrowSceneGraphNodeWith: builder [
	self flag: 'TODO:'.
	^ builder null
]

{ #category : '*FormSceneGraph-MorphicP12' }
NECDetailMorph >> buildMessageSceneGraphNodeWith: builder [
	self flag: 'TODO:'.
	^ builder null
]

{ #category : '*FormSceneGraph-MorphicP12' }
NECDetailMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	arrowPosition ifNotNil: [
		result := result , (self buildArrowSceneGraphNodeWith: builder).
		result := result , (self buildMessageSceneGraphNodeWith: builder).
	].
	^ result
]
