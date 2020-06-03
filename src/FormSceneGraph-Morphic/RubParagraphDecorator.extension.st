Extension { #name : #RubParagraphDecorator }

{ #category : #'*FormSceneGraph-Morphic' }
RubParagraphDecorator >> buildSceneGraphNodeWith: builder [
	^ builder null
]

{ #category : #'*FormSceneGraph-Morphic' }
RubParagraphDecorator >> buildSceneGraphNodeWith: builder bounds: aRectangle color: aColor [

   (self canBuildDecoratorsSceneGraphWith: builder) ifFalse: [ ^ builder null ].

	^ (self buildSceneGraphNodeWith: builder) ,
	(next buildSceneGraphNodeWith: builder bounds: aRectangle color: aColor)
]

{ #category : #'*FormSceneGraph-Morphic' }
RubParagraphDecorator >> canBuildDecoratorsSceneGraphWith: builder [
	^self drawingEnabled and: [ 
		self selectionStart isNotNil and: [ 
			self selectionStop isNotNil
		]
	]
]
