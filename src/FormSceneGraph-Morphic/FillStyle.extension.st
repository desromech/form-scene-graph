Extension { #name : #FillStyle }

{ #category : #'*FormSceneGraph-Morphic' }
FillStyle >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	| color |
	color := self asColor.
	color isTransparent ifTrue: [ ^ builder null ].
	^ builder solidRectangle: aRectangle color: color
]
