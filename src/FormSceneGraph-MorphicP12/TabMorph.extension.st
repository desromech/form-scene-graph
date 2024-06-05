Extension { #name : 'TabMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
TabMorph >> buildSceneGraphNodeWith: builder [
	^ (builder rectangle: self bounds color: self backgroundColor) ,
	(builder borderRectangle: self bounds color: self borderColor leftWidth: 1 rightWidth: 1 bottomWidth: 1 topWidth: 0)
]
