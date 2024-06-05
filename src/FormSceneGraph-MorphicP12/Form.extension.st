Extension { #name : 'Form' }

{ #category : '*FormSceneGraph-MorphicP12' }
Form >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ builder texturedRectangle: aRectangle form: self
]

{ #category : '*FormSceneGraph-MorphicP12' }
Form >> listBuildSceneGraphWith: builder atRow: aRow bounds: bounds color: color backgroundColor: backgroundColor from: aMorph [
	^ self asMorph listBuildSceneGraphWith: builder atRow: aRow bounds: bounds color: color backgroundColor: backgroundColor from: aMorph
]
