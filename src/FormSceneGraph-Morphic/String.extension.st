Extension { #name : #String }

{ #category : #'*FormSceneGraph-Morphic' }
String >> listBuildSceneGraphWith: builder atRow: aRow bounds: bounds color: color backgroundColor: backgroundColor from: aMorph [
	^ builder string: self in: bounds font: aMorph font color: color
]
