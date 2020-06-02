Extension { #name : #Morph }

{ #category : #'*FormSceneGraph-Morphic' }
Morph >> buildChildrenSceneGraphNodeWith: builder [
	| submorphNodes |
	submorphs isEmpty ifTrue: [ ^ builder null ].
	submorphNodes := OrderedCollection new.
	submorphs reverseDo: [ :each |
		| childNode |
		childNode := each buildFullSceneGraphWith: builder.
		childNode isNullNode ifFalse: [
			submorphNodes add: childNode
		]
	].

	submorphNodes isEmpty ifTrue: [ ^ builder null ].
	^ builder containerWith: submorphNodes
]

{ #category : #'*FormSceneGraph-Morphic' }
Morph >> buildFullSceneGraphWith: builder [ 
	| contentNode childrenNode |
	self visible ifFalse: [^ builder null].
	(self hasProperty: #errorOnDraw) ifTrue: [^ builder null ].

	contentNode :=	self buildSceneGraphNodeWith: builder.
	childrenNode := self buildChildrenSceneGraphNodeWith: builder.
	contentNode isNullNode ifTrue: [ ^ childrenNode ].
	childrenNode isNullNode ifTrue: [ ^ contentNode ].
	^ builder containerWith: {contentNode . childrenNode}
]

{ #category : #'*FormSceneGraph-Morphic' }
Morph >> buildSceneGraphClippingFor: submorphNodes with: builder [
	| container |
	container := builder containerWith: submorphNodes.
	self clipSubmorphs ifTrue: [ ^ builder clip: container withRectangle: self clippingBounds ].
	^ container
]

{ #category : #'*FormSceneGraph-Morphic' }
Morph >> buildSceneGraphNodeWith: builder [
	^ builder fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle
]
