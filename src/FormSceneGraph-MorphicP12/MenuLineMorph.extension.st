Extension { #name : 'MenuLineMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
MenuLineMorph >> buildSceneGraphNodeWith: builder [
	^ self theme flatMenu ifFalse: [
		(builder rectangle: (bounds topLeft corner: bounds rightCenter) color: self baseColor twiceDarker) ,
		(builder rectangle: (bounds leftCenter corner: bounds bottomRight) color: self baseColor twiceLighter)
	] ifTrue: [
		(builder rectangle: bounds color: self baseColor)
	].
]
