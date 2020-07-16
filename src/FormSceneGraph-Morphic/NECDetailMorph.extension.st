Extension { #name : #NECDetailMorph }

{ #category : #'*FormSceneGraph-Morphic' }
NECDetailMorph >> buildArrowSceneGraphNodeWith: builder [
	self flag: 'TODO:'.
	^ builder null
]

{ #category : #'*FormSceneGraph-Morphic' }
NECDetailMorph >> buildMessageSceneGraphNodeWith: builder [
	self flag: 'TODO:'.
	^ builder null
]

{ #category : #'*FormSceneGraph-Morphic' }
NECDetailMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	arrowPosition ifNotNil: [
		result := result , (self buildArrowSceneGraphNodeWith: builder).
		result := result , (self buildMessageSceneGraphNodeWith: builder).
	].
	^ result
]
