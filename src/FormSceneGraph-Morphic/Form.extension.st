Extension { #name : #Form }

{ #category : #'*FormSceneGraph-Morphic' }
Form >> buildSceneGraphNodeForFilling: aRectangle with: builder [
	^ builder texturedRectangle: aRectangle form: self
]

{ #category : #'*FormSceneGraph-Morphic' }
Form >> listBuildSceneGraphWith: builder atRow: aRow bounds: bounds color: color backgroundColor: backgroundColor from: aMorph [
	^ self asMorph listBuildSceneGraphWith: builder atRow: aRow bounds: bounds color: color backgroundColor: backgroundColor from: aMorph
]
