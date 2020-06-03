Extension { #name : #LogicalFont }

{ #category : #'*FormSceneGraph-Core' }
LogicalFont >> buildString: string formSceneGraphWith: builder from: startIndex to: stopIndex at: aPoint kern: kern [
	^ self realFont buildString: string formSceneGraphWith: builder from: startIndex to: stopIndex at: aPoint kern: kern
]
