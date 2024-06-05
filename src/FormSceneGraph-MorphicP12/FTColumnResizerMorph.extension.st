Extension { #name : 'FTColumnResizerMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
FTColumnResizerMorph >> buildSceneGraphNodeWith: builder [
	(owner notNil and: [owner containsPoint: self position]) ifFalse: [ ^ builder null ].
	^ super buildSceneGraphNodeWith: builder
]
