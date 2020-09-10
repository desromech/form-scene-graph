Extension { #name : #GLMBrickRenderer }

{ #category : #'*FormSceneGraph-Morphic' }
GLMBrickRenderer >> buildBackgroundColorSceneGraphNodeFor: aBrick in: rectangle with: builder [
	| result |
	result := builder rectangle: rectangle color: aBrick color.
	(aBrick fillStyle = Color transparent) ifFalse: [
		result := result , (builder fillRectangle: rectangle fillStyle: aBrick fillStyle borderStyle: aBrick borderStyle)
	].
	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
GLMBrickRenderer >> buildBackgroundColorSceneGraphNodeFor: aBrick with: builder [
	| rectangle |
	rectangle := aBrick brickBounds expandBy: aBrick shadowWidth negated.
	^ self buildBackgroundColorSceneGraphNodeFor: aBrick in: rectangle with: builder
]

{ #category : #'*FormSceneGraph-Morphic' }
GLMBrickRenderer >> buildBorderSceneGraphNodeFor: aBrick with: builder [
	^ builder null
]

{ #category : #'*FormSceneGraph-Morphic' }
GLMBrickRenderer >> buildSceneGraphNodeFor: aBrick with: builder [
	^ (self buildShadowSceneGraphNodeFor: aBrick with: builder) ,
	(self buildBackgroundColorSceneGraphNodeFor: aBrick with: builder) ,
	(self buildBorderSceneGraphNodeFor: aBrick with: builder)
]

{ #category : #'*FormSceneGraph-Morphic' }
GLMBrickRenderer >> buildShadowSceneGraphNodeFor: aBrick with: builder [
	^ builder null
]
