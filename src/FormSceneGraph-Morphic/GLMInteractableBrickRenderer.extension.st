Extension { #name : #GLMInteractableBrickRenderer }

{ #category : #'*FormSceneGraph-Morphic' }
GLMInteractableBrickRenderer >> buildColorSceneGraphNodeFor: aBrick with: builder [
	|color|
	color := aBrick currentColor.
	^ color
		ifNil: [ builder null ]
		ifNotNil: [ builder rectangle: (aBrick brickBounds expandBy: aBrick shadowWidth negated) color: color]
]

{ #category : #'*FormSceneGraph-Morphic' }
GLMInteractableBrickRenderer >> buildImageSceneGraphNodeFor: aBrick with: builder [
	|image|
	
	image := aBrick currentImage.
	
	^ image
		ifNil: [ builder null ]
		ifNotNil: [
			builder textureForm: (GLMBrick resizeImage: image scale: ((aBrick brickBounds expandBy: aBrick shadowWidth negated) extent / image extent))
			at: (aBrick brickBounds expandBy: aBrick shadowWidth negated) origin + (((aBrick paddingLeft - aBrick paddingRight)@(aBrick paddingTop - aBrick paddingBottom)) / 2.0) ]
]

{ #category : #'*FormSceneGraph-Morphic' }
GLMInteractableBrickRenderer >> buildSceneGraphNodeFor: aBrick with: builder [
	^ (self buildShadowSceneGraphNodeFor: aBrick with: builder) ,
	(self buildBackgroundColorSceneGraphNodeFor: aBrick with: builder) ,
	(self buildColorSceneGraphNodeFor: aBrick with: builder) ,
	(self buildImageSceneGraphNodeFor: aBrick with: builder) ,
	(self buildBorderSceneGraphNodeFor: aBrick with: builder)
]
