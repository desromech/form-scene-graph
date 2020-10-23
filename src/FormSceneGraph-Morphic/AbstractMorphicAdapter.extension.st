Extension { #name : #AbstractMorphicAdapter }

{ #category : #'*FormSceneGraph-Morphic' }
AbstractMorphicAdapter >> treeRenderSceneNodeWith: builder bounds: drawBounds color: drawColor font: aFont from: aMorph [
	"Specify how this object as a list item should be drawn"

	self widget ifNil: [ self buildWithSpec ].
	^ self widget treeRenderSceneNodeWith: builder bounds: drawBounds color: drawColor font: aFont from: aMorph
]
