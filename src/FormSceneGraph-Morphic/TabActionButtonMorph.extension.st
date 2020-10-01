Extension { #name : #TabActionButtonMorph }

{ #category : #'*FormSceneGraph-Morphic' }
TabActionButtonMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	icon ifNil: [ ^ result ].
	icon form ifNil: [ ^ result ].
	^ builder textureForm: icon form at: self topLeft
]
