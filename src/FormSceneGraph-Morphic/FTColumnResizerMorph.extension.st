Extension { #name : #FTColumnResizerMorph }

{ #category : #'*FormSceneGraph-Morphic' }
FTColumnResizerMorph >> buildSceneGraphNodeWith: builder [
	(owner notNil and: [owner containsPoint: self position]) ifFalse: [ ^ builder null ].
	^ super buildSceneGraphNodeWith: builder
]
