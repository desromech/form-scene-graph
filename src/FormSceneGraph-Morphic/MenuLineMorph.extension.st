Extension { #name : #MenuLineMorph }

{ #category : #'*FormSceneGraph-Morphic' }
MenuLineMorph >> buildSceneGraphNodeWith: builder [
	^ self theme flatMenu ifFalse: [
		(builder solidRectangle: (bounds topLeft corner: bounds rightCenter) color: self baseColor twiceDarker) ,
		(builder solidRectangle: (bounds leftCenter corner: bounds bottomRight) color: self baseColor twiceLighter)
	] ifTrue: [
		(builder solidRectangle: bounds color: self baseColor)
	].
]
