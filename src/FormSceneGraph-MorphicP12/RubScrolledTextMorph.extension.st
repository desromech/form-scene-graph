Extension { #name : 'RubScrolledTextMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
RubScrolledTextMorph >> buildClippedChildrenSceneGraphNodeListWith: builder [
	| submorphNodes drawBlock subs |
	submorphNodes := OrderedCollection new.
	drawBlock := [ :each |
		| childNode |
		childNode := each buildFullSceneGraphWith: builder.
		childNode isNullNode ifFalse: [
			submorphNodes add: childNode
		]
	].

	subs := submorphs copyWithoutAll: self sideRulers.
	subs reverseDo: drawBlock.

	subs := self sideRulers.
	subs reverseDo: drawBlock.

	^ submorphNodes

]

{ #category : '*FormSceneGraph-MorphicP12' }
RubScrolledTextMorph >> buildHighlightsSceneGraphNodeWith: builder [
	| scrollBounds scrollOffset |
	
	scrollBounds := self scrollPane innerBounds.
	scrollOffset := self scrollPane scroller offset.
	
	^ builder withClippingBounds: self clippingBounds build: [ 
		builder containerWith: (self highlights collect: [:highlight |
			highlight buildSceneGraphNodeWith: builder in: scrollBounds offset: scrollOffset 
		])
	].
]

{ #category : '*FormSceneGraph-MorphicP12' }
RubScrolledTextMorph >> buildSceneGraphNodeWith: builder [
	^ (super buildSceneGraphNodeWith: builder) ,
	(self buildHighlightsSceneGraphNodeWith: builder)
]

{ #category : '*FormSceneGraph-MorphicP12' }
RubScrolledTextMorph >> shouldCacheSceneGraphSurface [
	^ self fillStyle isTransparent not
]
