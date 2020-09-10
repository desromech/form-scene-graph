Extension { #name : #Color }

{ #category : #'*FormSceneGraph-Morphic' }
Color >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	self isTransparent ifTrue: [ ^ builder null ].
	^ builder rectangle: aRectangle color: self
]
