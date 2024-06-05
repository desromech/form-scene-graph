Extension { #name : 'String' }

{ #category : '*FormSceneGraph-MorphicP12' }
String >> listBuildSceneGraphWith: builder atRow: aRow bounds: bounds color: color backgroundColor: backgroundColor from: aMorph [
	^ builder string: self in: bounds font: aMorph font color: color
]

{ #category : '*FormSceneGraph-MorphicP12' }
String >> treeRenderSceneNodeWith: builder bounds: drawBounds color: drawColor font: aFont from: aMorph [

	^ builder
		string: self
		in: drawBounds 
		font: aMorph font
		color: drawColor
]
