Extension { #name : #GLMBrick }

{ #category : #'*FormSceneGraph-Morphic' }
GLMBrick >> buildChildrenSceneGraphNodeWith: builder [
	submorphs ifEmpty: [ ^ builder null ].
	^ builder withClippingBounds: self globalInnerBounds build: [ 
		self buildClippedChildrenSceneGraphNodeWith: builder
	].

]

{ #category : #'*FormSceneGraph-Morphic' }
GLMBrick >> buildSceneGraphNodeWith: builder [
	^ builder withTranslation: self globalBounds origin - self brickBounds origin build: [
		self onBuildSceneGraphNodeWith: builder
	]
]

{ #category : #'*FormSceneGraph-Morphic' }
GLMBrick >> onBuildSceneGraphNodeWith: builder [
	^ self renderer buildSceneGraphNodeFor: self with: builder

]
