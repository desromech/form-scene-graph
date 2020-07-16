Extension { #name : #NECMenuMorph }

{ #category : #'*FormSceneGraph-Morphic' }
NECMenuMorph >> buildBottomScrollSceneGraphNodeWith: builder [
	self flag: 'TODO:'.
	^ builder null
]

{ #category : #'*FormSceneGraph-Morphic' }
NECMenuMorph >> buildLine: index sceneGraphNodeWith: builder rectangle: rectangle [
	| necEntry string preString type font result highlightRectangle clippedHighlightRectangle |
	necEntry := context entries at: index.
	string := necEntry contents.
	preString := string asLowercase findString: context completionToken asLowercase.
	preString := preString <= 0
		ifFalse: [ string first: preString - 1 ]
		ifTrue: [ String empty ].
	type := necEntry hightlightSymbol.
	font := self selectFont: type.
	result := builder null.
	index = self selected ifTrue: [ 
		| rect |
		rect := rectangle withBottom: rectangle top + self class itemHeight.
		result := builder solidRectangle: rect color: self class scrollColor.
		self detailPosition: rect topRight
	].
	highlightRectangle := rectangle translateBy: (font widthOfString: preString) @ 0.
	highlightRectangle := highlightRectangle withWidth: (font widthOfString: context completionToken).
	
	clippedHighlightRectangle := highlightRectangle intersect: rectangle ifNone: [Rectangle empty].
	clippedHighlightRectangle isEmpty ifFalse: [ 
		result := result , (builder solidRectangle: clippedHighlightRectangle color: (Color gray alpha: 0.3))
	].

	^ result , (builder string: string in: (rectangle insetBy: 1) font: font color: (self selectColor: type))
]

{ #category : #'*FormSceneGraph-Morphic' }
NECMenuMorph >> buildMessageSceneGraphNodeWith: builder in: rectangle [
	| result |
	self hasMessage ifFalse: [ ^ builder null ].
	result := builder null.
	context hasEntries ifTrue: [
		result := builder solidRectangle: (rectangle topLeft extent: rectangle width @ 1) color: Color gray.
	].

	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
NECMenuMorph >> buildSceneGraphNodeWith: builder [
	| result rectangle |
	result := super buildSceneGraphNodeWith: builder.
	
	rectangle := self bounds insetBy: 1.
	rectangle := rectangle bottom: rectangle top + self class itemHeight.
	rectangle := rectangle left: rectangle left + 20.
	
	self extent: self extent.
	self firstVisible > 1 
		ifTrue: [ result := result , (self buildTopScrollSceneGraphNodeWith: builder) ].
	self lastVisible ~= self itemsCount 
		ifTrue: [ result := result , (self buildBottomScrollSceneGraphNodeWith: builder) ].
		
	context hasEntries ifTrue: [ 
		self firstVisible to: self lastVisible do: [ :index | 
			result := result , (self buildLine: index sceneGraphNodeWith: builder rectangle: rectangle).
			rectangle := self prepareRectForNextRow: rectangle
		]
	].

	result := result , (self buildMessageSceneGraphNodeWith: builder in: rectangle).
	^ result
]

{ #category : #'*FormSceneGraph-Morphic' }
NECMenuMorph >> buildTopScrollSceneGraphNodeWith: builder [
	self flag: 'TODO:'.
	^ builder null
]
