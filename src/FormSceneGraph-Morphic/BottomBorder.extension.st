Extension { #name : #BottomBorder }

{ #category : #'*FormSceneGraph-Morphic' }
BottomBorder >> buildSceneGraphNodeForBorder: aRectangle with: builder [
	| trimOffset trimmedRectangle |
	trimOffset := self trimSize @ 0.
	trimmedRectangle := aRectangle origin + trimOffset corner: aRectangle corner - trimOffset.
	^ builder borderRectangle: trimmedRectangle color: self color leftWidth: 0 rightWidth: 0 bottomWidth: 0 topWidth: self width.
]
