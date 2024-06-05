Extension { #name : 'Color' }

{ #category : '*FormSceneGraph-MorphicP12' }
Color >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	self isTransparent ifTrue: [ ^ builder null ].
	^ builder rectangle: aRectangle color: self
]
