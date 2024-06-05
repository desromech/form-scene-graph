Extension { #name : 'FillStyle' }

{ #category : '*FormSceneGraph-MorphicP12' }
FillStyle >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	| color |
	color := self asColor.
	color isTransparent ifTrue: [ ^ builder null ].
	^ builder rectangle: aRectangle color: color
]
