Extension { #name : #Morph }

{ #category : #'*FormSceneGraph-Morphic' }
Morph >> buildChildrenSceneGraphNodeWith: builder [
	submorphs isEmpty ifTrue: [ ^ builder null ].
	^ builder withClippingBounds: self clippingBounds when: self clipSubmorphs build: [ 
		self buildClippedChildrenSceneGraphNodeWith: builder
	].

]

{ #category : #'*FormSceneGraph-Morphic' }
Morph >> buildClippedChildrenSceneGraphNodeListWith: builder [
	| submorphNodes |
	submorphNodes := OrderedCollection new.
	submorphs reverseDo: [ :each |
		| childNode |
		childNode := each buildFullSceneGraphWith: builder.
		childNode isNullNode ifFalse: [
			submorphNodes add: childNode
		]
	].

	^ submorphNodes
]

{ #category : #'*FormSceneGraph-Morphic' }
Morph >> buildClippedChildrenSceneGraphNodeWith: builder [
	^ builder containerWith: (self buildClippedChildrenSceneGraphNodeListWith: builder)
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
Morph >> buildSceneGraphNodeWith: builder [
	^ builder fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle
]
