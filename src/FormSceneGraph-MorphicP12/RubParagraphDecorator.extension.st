Extension { #name : 'RubParagraphDecorator' }

{ #category : '*FormSceneGraph-MorphicP12' }
RubParagraphDecorator >> buildSceneGraphNodeWith: builder [
	^ builder null
]

{ #category : '*FormSceneGraph-MorphicP12' }
RubParagraphDecorator >> buildSceneGraphNodeWith: builder bounds: aRectangle color: aColor [

   (self canBuildDecoratorsSceneGraphWith: builder) ifFalse: [ ^ builder null ].

	^ (self buildSceneGraphNodeWith: builder) ,
	(next buildSceneGraphNodeWith: builder bounds: aRectangle color: aColor)
]

{ #category : '*FormSceneGraph-MorphicP12' }
RubParagraphDecorator >> canBuildDecoratorsSceneGraphWith: builder [
	^self drawingEnabled and: [ 
		self selectionStart notNil and: [ 
			self selectionStop notNil
		]
	]
]
