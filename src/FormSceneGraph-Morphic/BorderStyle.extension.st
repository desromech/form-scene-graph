Extension { #name : #BorderStyle }

{ #category : #'*FormSceneGraph-Morphic' }
BorderStyle >> buildSceneGraphNodeForBorder: aRectangle with: builder [
	^ builder borderRectangle: aRectangle color: self color width: self width
]

{ #category : #'*FormSceneGraph-Morphic' }
BorderStyle >> buildSceneGraphNodeForLineStart: startPoint end: endPoint with: builder [
	^ builder lineFrom: startPoint to: endPoint width: self width color: self color
]
