Extension { #name : #AbstractFont }

{ #category : #'*FormSceneGraph-Core' }
AbstractFont >> buildString: string formSceneGraphWith: builder from: startIndex to: stopIndex at: aPoint kern: kern [
	self subclassResponsibility
]
