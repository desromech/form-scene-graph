Extension { #name : #TransformationMorph }

{ #category : #'*FormSceneGraph-Morphic' }
TransformationMorph >> buildSceneGraphNodeWith: builder [
	submorphs isEmpty ifTrue: [^ super buildSceneGraphNodeWith: builder].
	^ builder null
]
