Extension { #name : #String }

{ #category : #'*FormSceneGraph-Morphic' }
String >> listBuildSceneGraphWith: builder atRow: aRow bounds: bounds color: color backgroundColor: backgroundColor from: aMorph [
	^ builder string: self in: bounds font: aMorph font color: color
]

{ #category : #'*FormSceneGraph-Morphic' }
String >> treeRenderSceneNodeWith: builder bounds: drawBounds color: drawColor font: aFont from: aMorph [

	^ builder
		string: self
		in: drawBounds 
		font: aMorph font
		color: drawColor
]
