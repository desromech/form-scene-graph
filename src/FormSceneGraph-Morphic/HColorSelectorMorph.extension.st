Extension { #name : #HColorSelectorMorph }

{ #category : #'*FormSceneGraph-Morphic' }
HColorSelectorMorph >> buildSceneGraphNodeWith: builder [
	^ (builder texturedRectangle: self bounds form: self hueForm) ,
		(builder borderRectangle: self bounds style: self borderStyle)
]

{ #category : #'*FormSceneGraph-Morphic' }
HColorSelectorMorph >> hueForm [
	^ self valueOfProperty: #hueForm ifAbsentPut: [
		|hueColors hueForm|
		hueColors := (0.0 to: 359.9 by: 0.1) collect: [:a | Color h: a s: 1.0 v: 1.0].
		hueForm := Form extent: 1 @ hueColors size depth: 32.
		hueColors doWithIndex: [ :each :index |
			hueForm colorAt: 0@(index - 1) put: each
		].
		hueForm
	]

]
