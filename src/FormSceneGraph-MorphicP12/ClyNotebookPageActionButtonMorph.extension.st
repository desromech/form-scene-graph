Extension { #name : 'ClyNotebookPageActionButtonMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
ClyNotebookPageActionButtonMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	icon ifNil: [ ^ result ].
	icon form ifNil: [ ^ result ].
	^ builder textureForm: icon form at: self topLeft
]
