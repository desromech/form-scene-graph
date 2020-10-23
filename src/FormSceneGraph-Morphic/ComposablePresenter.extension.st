Extension { #name : #ComposablePresenter }

{ #category : #'*FormSceneGraph-Morphic' }
ComposablePresenter >> treeRenderSceneNodeWith: builder bounds: drawBounds color: drawColor font: aFont from: aMorph [
	"Specify how this object as a list item should be drawn"

	^ self ensureMorphicAdapterDo: [ :adapter | adapter 
		treeRenderSceneNodeWith: builder
		bounds: drawBounds 
		color: drawColor 
		font: aFont 
		from: aMorph ]
]
