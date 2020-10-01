Extension { #name : #ClyNotebookPageActionButtonMorph }

{ #category : #'*FormSceneGraph-Morphic' }
ClyNotebookPageActionButtonMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	icon ifNil: [ ^ result ].
	icon form ifNil: [ ^ result ].
	^ builder textureForm: icon form at: self topLeft
]
