Extension { #name : 'TransformationMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
TransformationMorph >> buildSceneGraphNodeWith: builder [
	submorphs isEmpty ifTrue: [^ super buildSceneGraphNodeWith: builder].
	^ builder null
]
