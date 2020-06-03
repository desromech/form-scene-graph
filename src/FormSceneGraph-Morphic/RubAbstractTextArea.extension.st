Extension { #name : #RubAbstractTextArea }

{ #category : #'*FormSceneGraph-Morphic' }
RubAbstractTextArea >> buildChildrenSceneGraphNodeWith: builder [
	| result |
	result := super buildChildrenSceneGraphNodeWith: builder.
	^ result , (self paragraph buildSceneGraphNodeWith: builder bounds: self drawingBounds color: self textColor).

]
