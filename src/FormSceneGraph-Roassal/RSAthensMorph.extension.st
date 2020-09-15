Extension { #name : #RSAthensMorph }

{ #category : #'*FormSceneGraph-Roassal' }
RSAthensMorph >> buildSceneGraphNodeWith: builder [
	self checkSession.
	^ (builder rectangle: self bounds color: roassalCanvas color) ,
	(builder rectangle: self bounds surface: surface drawWithAthens: [ :drawSurface |
		self drawOnAthensNodeSurface: drawSurface
	])
]

{ #category : #'*FormSceneGraph-Roassal' }
RSAthensMorph >> drawOnAthensNodeSurface: aSurface [
	"Draw the whole visualization"
	isDrawing ifTrue: [ ^ self ].
	isDrawing := true.
	
	[
		surface := aSurface.
		roassalCanvas playAnimations.
		self drawShapes.
	] ensure: [ isDrawing := false ]
]
