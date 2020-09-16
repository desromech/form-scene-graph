Extension { #name : #RSAthensMorph }

{ #category : #'*FormSceneGraph-Roassal' }
RSAthensMorph >> buildSceneGraphNodeWith: builder [
	self checkSession.
	^ (builder rectangle: self bounds color: roassalCanvas color) ,
	(builder rectangle: self bounds surface: surface drawWithAthens: [ :drawSurface :scaleFactorX :scaleFactorY |
		self drawOnAthensNodeSurface: drawSurface withScaleX: scaleFactorX Y: scaleFactorY
	])
]

{ #category : #'*FormSceneGraph-Roassal' }
RSAthensMorph >> drawOnAthensNodeSurface: aSurface withScaleX: scaleFactorX Y: scaleFactorY [
	"Draw the whole visualization"
	isDrawing ifTrue: [ ^ self ].
	isDrawing := true.
	
	[
		surface := aSurface.
		roassalCanvas extent = self extent ifFalse: [ roassalCanvas extent: self extent ].
		roassalCanvas playAnimations.
		self drawShapesWithScaleX: scaleFactorX Y: scaleFactorY.
	] ensure: [ isDrawing := false ]
]

{ #category : #'*FormSceneGraph-Roassal' }
RSAthensMorph >> drawShapesWithScaleX: scaleX Y: scaleY [
	"The drawing has to be done when a change in the shapes occured or when there is an animation."
	
	surface drawDuring: [ :athensCanvas | 
		| camera canvasRect |
		roassalCanvas clearBackground
			ifTrue: [ surface clear ].
		"We display the elements that are subject to the camera"
		camera := roassalCanvas camera.
		athensCanvas pathTransform scaleX: scaleX Y: scaleX.
		athensCanvas pathTransform restoreAfter: [ 
			athensCanvas pathTransform
				translateBy: (self extent / 2) asFloatPoint;
				scaleBy: camera scale asFloat;
				translateBy: camera position negated asFloatPoint.
			renderer canvas: athensCanvas.
			canvasRect := roassalCanvas visibleRectangle.
		
			roassalCanvas shapes do: [ :roassalShape | 
				(roassalShape intersects: canvasRect)
					ifTrue: [ roassalShape accept: renderer ] ].
		
			self showRectanglesIfNecessary: roassalCanvas shapes.
		].
	
		athensCanvas pathTransform restoreAfter: [ 
			"We display the elements that are _NOT_ subject to the camera"
			roassalCanvas fixedShapes do: [ :roassalShape | 
				roassalShape accept: renderer ].
			"debug mode to show encompassingRectangles"
			self showRectanglesIfNecessary: roassalCanvas fixedShapes.
		].
	]
		

]
